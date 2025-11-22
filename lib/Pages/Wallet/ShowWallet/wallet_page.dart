import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:fin_tech/Pages/Wallet/ImportWallets/import_wallet_with_private_key.dart';
import '../../transcation_history.dart';
import '/Pages/Wallet/ShowWallet/Widgets/accounts_and_actions.dart';
import '/Pages/Wallet/ShowWallet/Widgets/wallet_address.dart';
import '/Pages/Wallet/Transaction/receive_funds.dart';
import '/Pages/Wallet/Transaction/send_funds_page.dart';
import '/assets.dart';
import '/Pages/Wallet/ImportWallets/scan_qr_import_wallets_page.dart';
import '/Provider/WalletProviders/wallet_provider.dart';
import '/Provider/providers.dart';
import '/Utils/utils.dart';
import '/utils/extension.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    walletProvider.getWallets();
    super.initState();
  }
  Future<void> getData() async {
    walletProvider.getWallets();
    await walletProvider.getBalance();
    return;
  }
  @override
  Widget build(BuildContext context) {
    final screenHeight = Get.height * 0.015;
    return Scaffold(
      appBar: AppBar(
        // leading: GestureDetector(
        //   onTap: () async {
        //     final res = await Get.to(() => const ScanQrImportWalletPage());
        //     if (walletProvider.validatePrivateKey(res)) {
        //       return Get.to(ImportWalletWithPrivateKeyPage(privateKey: res));
        //     } else if (walletProvider.validatePublicAddress(res)) {
        //       return Get.to(() => SendFundsPage(address: res));
        //     }
        //     return showToast("Invalid Qr Data");
        //   },
        //   child: Image.asset(
        //     ImageSrc.QR_CODE,
        //     scale: 3.5,
        //   ),
        // ),
        actions: [
          const Icon(
            Icons.refresh,
          ).paddingOnly(right: screenHeight).onTap(getData),
        ],
      ),
      body: Column(
        children: [
          Column(
            children: [
              const AccountsAndActions().paddingOnly(bottom: screenHeight),
              const WalletAddress().paddingOnly(bottom: screenHeight),

              /// Show Balance
              Consumer<WalletProvider>(
                builder: (BuildContext context, value, Widget? child) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "${formatBalance(value.evmWallet?.lastBalance)} ${AppCurrency.ETH}",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                      ),
                    ],
                  );
                },
              ).paddingOnly(bottom: 10),

              /// SEND OR RECEIVE FUNDS BUTTONS

              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Container(
                  width: Get.width * .4,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(
                      100,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: screenHeight * 2,
                          child: const Icon(Icons.call_made,color: Colors.white).paddingOnly(right: screenHeight)),
                      Text(
                        "Send",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w400,color: Colors.white),
                      )
                    ],
                  ).paddingSymmetric(vertical: screenHeight),
                ).onTap(() async {
                  await Get.to(() => const SendFundsPage());
                }),
                Container(
                  width: Get.width * .4,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(screenHeight * 100),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: screenHeight * 2,
                          child:  const Icon(Icons.call_received,color: Colors.white,).paddingOnly(right: screenHeight)),
                      Text(
                        "Receive",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w400, color: Colors.white),
                      )
                    ],
                  ).paddingSymmetric(vertical: screenHeight),
                ).onTap(() async {
                  await Get.to(() => const ReceiveFundsPage());
                }),
              ]).paddingOnly(bottom: screenHeight),
            ],
          ),

        ],
      ),
    );
  }
}
