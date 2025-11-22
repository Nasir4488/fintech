import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fin_tech/Models/rpc_model.dart';
import 'package:fin_tech/Services/storage_services.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;

class ContractProvider extends ChangeNotifier {
  String chainId = '11155111';

  late RPCModel rpcModel;

  final rpcList = <RPCModel>[
    RPCModel(title: "Sepolia ", rpc: "https://sepolia.infura.io/v3/2a95562c61894725a5ce23a5595cec38"),

  ];

  /// Set init value of RPC
  setInitRPC() {
    String? localRpcString = AppStorage.box.read(AppStorage.RPC);

    if (localRpcString == null) {
      rpcModel = rpcList.first;
    } else {
      final rpcModel = rpcModelFromJson(localRpcString);

      /// Apply this dor dropdown button
      this.rpcModel =
          rpcList.firstWhereOrNull((element) => element.title == rpcModel.title) ?? rpcList.first;
    }
    initClient();
    // loadContractData();

    Future.delayed(Duration.zero, () {
      notifyListeners();
    });
  }

  /// User Change RPC
  void setRPC(RPCModel? rpcModel) {
    this.rpcModel = rpcModel ?? this.rpcModel;
    AppStorage.box.write(AppStorage.RPC, rpcModelToJson(rpcModel!));
    notifyListeners();
  }

  late Web3Client web3client;

  /// Initialize Http Client
  void initClient() async {
    web3client = Web3Client(rpcModel.rpc, http.Client());

  }

  /// Load Contract Data
  DeployedContract? contract;

  Future<void> loadContractData() async {
    // String abi = await rootBundle.loadString(_contractPath);
    //
    // contract = DeployedContract(
    //     ContractAbi.fromJson(abi, _contractName), EthereumAddress.fromHex(_contractAddress));
  }
}
