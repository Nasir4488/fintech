import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:fin_tech/assets.dart';
import '/Pages/Wallet/ImportWallets/import_wallet_with_private_key.dart';
import '/Provider/WalletProviders/wallet_provider.dart';
import '/Provider/providers.dart';
import '/Provider/theme_provider.dart';
import '/Utils/extension.dart';
import '/Utils/utils.dart';

class ShowAllWalletsWidget extends StatelessWidget {
  final bool showCreateImportOptions;

  const ShowAllWalletsWidget({this.showCreateImportOptions = true, super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletProvider>(
      builder: (BuildContext context, value, Widget? child) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showCreateImportOptions)
                ListTile(
                  onTap: () {
                    value.createNewAccount().then((_) {});
                  },
                  dense: true,
                  leading: Image.asset(ImageSrc.ADD, scale: 2),
                  title: Text("Add new account",
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.w400)),
                ),
              if (showCreateImportOptions)
                ListTile(
                  onTap: () {
                    Get.back();
                    Get.to(() => const ImportWalletWithPrivateKeyPage());
                  },
                  dense: true,
                  leading: Image.asset(ImageSrc.IMPORT, scale: 2),
                  title: Text("Import new account",
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.w400)),
                ),
              Container(height: 1, color: primaryColor),
              Text(
                "YOUR ACCOUNTS",
                style:
                    Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ).paddingOnly(top: 5, bottom: 5, left: 10),
              ListView.builder(
                reverse: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: value.walletsList.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  final data = value.walletsList[index];
                  return Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: data.isActive ? Colors.grey.withOpacity(.5) : null,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        width: Get.width,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(ImageSrc.GROOT_DP, scale: 4).paddingAll(5),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(data.accountTitle ?? "Vrc Account",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(fontWeight: FontWeight.w400))
                                    .paddingOnly(bottom: 5),
                                Text(formatWalletAddress(data.walletAddress ?? ""),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(fontWeight: FontWeight.w400, color: textColor)),
                              ],
                            ),
                            const Expanded(child: SizedBox()),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${formatBalance(data.lastBalance)} ${AppCurrency.ETH}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ).paddingOnly(right: 20),
                                Text(
                                  data.status ?? "",
                                  style:
                                      Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 8),
                                ).paddingAll(2.5)
                              ],
                            )
                          ],
                        ),
                      ).onTap(() {
                        walletProvider.changeAccount(data.privateKey!).then((value) {
                          Get.back();
                        });
                      })
                    ],
                  );
                },
              ).paddingOnly(bottom: 20),
            ],
          ),
        );
      },
    );
  }

  String formatWalletAddress(String address) {
    if (address.length <= (7 + 7)) {
      return address;
    }
    return '${address.substring(0, 7)}...${address.substring(address.length - 7)}';
  }
}

Future<void> showAccountDetailBottomSheet({bool showCreateImportOptions = true}) async {
  await Get.bottomSheet(
    ShowAllWalletsWidget(showCreateImportOptions: showCreateImportOptions),
    backgroundColor: Colors.white,
    shape: const OutlineInputBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(10),
        topLeft: Radius.circular(10),
      ),
    ),
  );
}
