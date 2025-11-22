import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../Models/transfer_history_model.dart';
import '/Provider/providers.dart';
import '/Utils/extension.dart';
import '/Models/wallet_model.dart';
import '/Services/storage_services.dart';
import '/Utils/utils.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:bip32/bip32.dart' as bip32;
import 'package:bip39/bip39.dart' as bip39;
import 'package:hex/hex.dart';

class WalletProvider extends ChangeNotifier with AppUtils {
  String? mnemonic;

  String generateMnemonic() {
    return bip39.generateMnemonic();
  }

  Future<String> getPrivateKey(String mnemonic) async {
    final seeds = bip39.mnemonicToSeed(mnemonic);
    bip32.BIP32 root = bip32.BIP32.fromSeed(seeds);
    bip32.BIP32 child = root.derivePath("m/44'/60'/0'/0/0");
    return HEX.encode(child.privateKey ?? []);
  }

  Future<EthereumAddress> getPublicKey(String privateKey) async {
    final private = EthPrivateKey.fromHex(privateKey);
    final address = private.address;
    return address;
  }

  Uint8List mnemonicToSeed(String mnemonic) {
    return bip39.mnemonicToSeed(mnemonic);
  }

  bip32.BIP32 deriveAccount(Uint8List seed, int accountIndex) {
    String path = "m/44'/60'/0'/0/$accountIndex";
    return bip32.BIP32.fromSeed(seed).derivePath(path);
  }

  String unit8ListToHex(Uint8List unit8list) {
    return unit8list.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
  }

  bool validateMnemonic(String userEnteredPhrase) {
    return bip39.validateMnemonic(userEnteredPhrase);
  }

  /// Validate Private Key

  bool validatePrivateKey(String privateKeyHex) {
    try {
      if (privateKeyHex.length != 64) {
        return false;
      }

      final privateKey = EthPrivateKey.fromHex(privateKeyHex);

      return privateKey.address.hexNo0x.length == 40;
    } catch (e) {
      showSnack(e.toString(), isError: true);
      return false;
    }
  }

  bool validatePublicAddress(String? publicAddress) {
    try {
      if (publicAddress == null || publicAddress.length != 42) {
        return false;
      }

      if (!publicAddress.startsWith('0x')) {
        return false;
      }
      final addressWithoutPrefix = publicAddress.substring(2);
      final isHex = RegExp(r'^[0-9a-fA-F]+$').hasMatch(addressWithoutPrefix);

      return isHex;
    } catch (e) {
      return false;
    }
  }

  /// Save Wallets to Local
  List<VrcWalletModel> walletsList = <VrcWalletModel>[];

  getWallets() {
    walletsList = [];
    final String data = AppStorage.box.read(AppStorage.WALLETS_DATA) ?? "[]";
    final walletModel = vrcWalletModelFromJson(data);
    walletsList.addAll(walletModel);
    if (walletsList.isEmpty) return;
    evmWallet = walletsList.firstWhereOrNull((element) => element.isActive == true);
    Future.delayed(Duration.zero, () {
      notifyListeners();
    });
  }

  int generateRandomColor() {
    final r = math.Random().nextInt(256);
    final g = math.Random().nextInt(256);
    final b = math.Random().nextInt(256);

    return Color.fromARGB(255, r, g, b).value;
  }

  Future<void> saveWallets({
    String? privateKey,
    String? walletAddress,
    String? lastBalance,
    required String status,
  }) async {
    for (var element in walletsList) {
      element.isActive = false;
    }
    String accountTitle = "Ethereum Account ${(walletsList.length + 1).toString()}";

    walletsList.add(
      VrcWalletModel(
        status: status,
        accountTitle: accountTitle,
        privateKey: privateKey,
        walletAddress: walletAddress,
        color: generateRandomColor(),
        isActive: true,
        lastBalance: lastBalance,
      ),
    );
    String jsonString = jsonEncode(walletsList.map((user) => user.toJson()).toList());
    await AppStorage.box.write(AppStorage.WALLETS_DATA, jsonString);
  }

  /// Create New Account
  ///
  ///

  Future<void> createNewAccount() async {
    super.showProgress();
    Future.delayed(
      const Duration(seconds: 2),
      () async {
        if (AppStorage.box.read(AppStorage.MASTER_SEEDS) == null) {
          super.stopProgress();
          showSnack("Please Import Mnemonic Phrases/Secrete Phrases Before Add New Account",
              isError: true);
          return;
        }

        Uint8List seed = mnemonicToSeed(AppStorage.box.read(AppStorage.MASTER_SEEDS));
        bip32.BIP32 account = deriveAccount(seed, walletsList.length);
        final privateKey = unit8ListToHex(account.privateKey!);
        EthereumAddress walletAddress = await getPublicKey(privateKey);
        final balance = await getBalance();
        await saveWallets(
          privateKey: privateKey,
          status: "Created",
          walletAddress: walletAddress.hex,
          lastBalance: balance,
        );

        final id =
            walletsList.firstWhereOrNull((element) => element.privateKey == privateKey)!.privateKey;
        await changeAccount(id!);

        stopProgress();
      },
    );

    notifyListeners();
  }

  /// Import Account
  ///

  Future<bool> importWallet(String privateKey) async {
    return await Future.delayed(
      const Duration(milliseconds: 500),
      () async {
        for (var element in walletsList) {
          if (element.privateKey == privateKey) {
            showSnack("Duplicate Entry", isError: true);
            return false;
          }
        }

        final publicAddress = await getPublicKey(privateKey);
        await saveWallets(
            privateKey: privateKey, walletAddress: publicAddress.hex, status: "Imported");
        final key =
            walletsList.firstWhereOrNull((element) => element.privateKey == privateKey)?.privateKey;
        try {
          await changeAccount(key!);
        } on Exception catch (e) {
          throw Exception(e);
        }

        return true;
      },
    );
  }

  /// Select Account

  Future<void> changeAccount(String privateKey) async {
    for (var element in walletsList) {
      if (element.privateKey == privateKey) {
        element.isActive = true;
      } else {
        element.isActive = false;
      }
    }
    String jsonString = jsonEncode(walletsList.map((user) => user.toJson()).toList());
    await AppStorage.box.write(AppStorage.WALLETS_DATA, jsonString);
    evmWallet = walletsList.firstWhereOrNull((element) => element.isActive == true);

    ///
    ///
    getBalance();
    notifyListeners();
  }

  /// Change Account Name
  final accNameController = TextEditingController();

  void changeAccountName(String privateKey) async {
    walletsList.firstWhere((element) => element.privateKey == privateKey).accountTitle =
        accNameController.text;
    String jsonString = jsonEncode(walletsList.map((user) => user.toJson()).toList());
    await AppStorage.box.write(AppStorage.WALLETS_DATA, jsonString);

    accNameController.clear();

    getWallets();
    notifyListeners();
  }

  /// Delete Account
  Future<void> deleteAccount() async {
    walletsList.removeWhere((element) => element.privateKey == evmWallet?.privateKey);
    if (walletsList.isEmpty) {
      await AppStorage.box.remove(AppStorage.WALLETS_DATA);
      return;
    }
    await changeAccount(walletsList.last.privateKey ?? "");

    notifyListeners();
  }

  /// Copy to Clip Board
  Future<void> copyToClipBoard(String value) async {
    await Clipboard.setData(ClipboardData(text: value));
    showToast("Copied to clipboard");
  }

  /// Get Balance
  String? balance;
  VrcWalletModel? evmWallet;

  Future<String> getBalance() async {
    try {
      final ethClient = contractProvider.web3client;
      EthereumAddress ethAdd = EthereumAddress.fromHex(evmWallet?.walletAddress ?? "");
      EtherAmount amount = await ethClient.getBalance(ethAdd);
      double threshold = 1e-6;

      String? balance;

      if (amount.getInWei < threshold.toBigInt()) {
        balance = "0";
      } else {
        balance = amount.getValueInUnit(EtherUnit.ether).toString();
      }
      await updateBalanceToLocal(balance);
      logger.i(balance);
      Future.delayed(
        const Duration(seconds: 6),
        () async {
          await updateBalanceToLocal(balance ?? "0.0");
        },
      );
      notifyListeners();
      return balance;
    } on Exception catch (_) {
      logger.i(_.toString());
      notifyListeners();
      return "";
    }
  }

  /// Update Balance Wallet to local

  Future<void> updateBalanceToLocal(String balance) async {
    for (var element in walletsList) {
      if (element.walletAddress == evmWallet?.walletAddress) {
        element.lastBalance = balance.toString();
      }

      String jsonString = jsonEncode(walletsList.map((user) => user.toJson()).toList());
      await AppStorage.box.write(AppStorage.WALLETS_DATA, jsonString);
      notifyListeners();
    }
  }

  /// Send Translation

  String _hash = '';
  TransactionReceipt? transactionReceipt;

  final amountCtrl = TextEditingController();

  Future<bool> sendFunds({
    String? receiverAddress,
  }) async {
    if (receiverAddress == null || amountCtrl.text.isEmpty) {
      return false;
    }
    try {
      showProgress();

      final gasLimit = BigInt.from(2100000);

      final credentials = EthPrivateKey.fromHex(evmWallet?.privateKey ?? "");

      EtherAmount gasPrice = await contractProvider.web3client.getGasPrice();
      BigInt totalGasCost = gasPrice.getInWei * gasLimit;

      EtherAmount etherAmount =
          EtherAmount.inWei(BigInt.from(double.parse(amountCtrl.text) * 1e18));

      BigInt totalFund = (etherAmount.getInWei) + (totalGasCost);

      if (BigInt.from(double.parse(amountCtrl.text) * 1e18) > totalFund) {
        showSnack("Insufficient Gas", isError: true);

        return false;
      }

      _hash = await contractProvider.web3client.sendTransaction(
        credentials,
        Transaction(
          to: EthereumAddress.fromHex(receiverAddress),
          gasPrice: gasPrice,
          maxGas: 2100000,
          value: EtherAmount.inWei(
            BigInt.from(double.parse(amountCtrl.text) * 1e18),
          ),
        ),
        chainId: int.parse(contractProvider.chainId),
      );
      stopProgress();
      if (_hash.isNotEmpty) {
        fetchReceipt(amountCtrl.text);
        // amountCtrl.clear();
      }

      Future.delayed(const Duration(seconds: 6), () async {
        await getBalance().then((value) {});
      });
      return true;
    } on Exception catch (e) {
      stopProgress();
      logger.e(e);
      showSnack("Insufficient Gas", isError: true);
      return false;
    }
  }

  Future<void> fetchReceipt(String amount) async {
    logger.i('Waiting for confirmation...');
    while (true) {
      final receipt = await contractProvider.web3client.getTransactionReceipt(_hash);
      if (receipt != null) {
        studentFeeProvider.saveTransactionHistory(
            TransferHistoryModel(
                transactionHash: _hash,
                senderAddress: receipt.from?.hex,
                receiverAddress: receipt.to?.hex,
                amount: amount,
                timestamp: DateTime.now().toIso8601String(),
                status: true,
                studentId: authProviders.getUser()?.id),
            _hash);

        break;
      } else {
        // print('Transaction is still pending...');
        await Future.delayed(const Duration(seconds: 10));
      }
    }
  }
}
