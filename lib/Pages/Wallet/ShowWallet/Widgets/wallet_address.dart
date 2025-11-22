import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fin_tech/GlobalWidgets/input_field.dart';
import 'package:fin_tech/Pages/Wallet/ShowWallet/wallet_detail.dart';
import 'package:fin_tech/Provider/WalletProviders/wallet_provider.dart';
import 'package:fin_tech/Provider/providers.dart';
import 'package:fin_tech/Provider/theme_provider.dart';
import 'package:fin_tech/Utils/extension.dart';
import 'package:fin_tech/Utils/utils.dart';
import 'package:fin_tech/assets.dart';

class WalletAddress extends StatelessWidget {
  const WalletAddress({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight=Get.height*.015;
    return Consumer<WalletProvider>(
      builder: (BuildContext context, value, Widget? child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(screenHeight*100),
                border: Border.all(
                  color: Colors.black,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    formatWalletAddress(value.evmWallet?.walletAddress ?? ""),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                  Image.asset(ImageSrc.COPY, scale: 2).paddingOnly(left: screenHeight)
                ],
              ).paddingSymmetric(horizontal: screenHeight, vertical: screenHeight/2),
            ).onTap(() {
              walletProvider.copyToClipBoard(value.evmWallet?.walletAddress ?? "");
            }).paddingOnly(right: 5),
            Image.asset(ImageSrc.MORE, scale: 2).paddingOnly(left: screenHeight).onTap(
              () async {
                await accountActions().then(
                  (value) {
                    return handleAccountActions(value);
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future<int> accountActions() async {
    int id = -1;
    await Get.bottomSheet(
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration:
                BoxDecoration(gradient: linearGradient, borderRadius: BorderRadius.circular(20)),
            width: 100,
            height: 5,
          ).paddingSymmetric(vertical: 10),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BottomSheetDataModel(
                "Edit Account Name".tr,
                Image.asset(ImageSrc.EDIT, scale: 2),
                0,
              ),
              BottomSheetDataModel(
                "View on Eth Scan".tr,
                Image.asset(ImageSrc.EYE, scale: 2),
                1,
              ),
              BottomSheetDataModel(
                "Share my Public Address".tr,
                Image.asset(ImageSrc.SHARE, scale: 2),
                2,
              ),
              BottomSheetDataModel(
                "Show Private Key/Secrete Phrases".tr,
                Image.asset(ImageSrc.KEY, scale: 2),
                3,
              ),
              BottomSheetDataModel(
                "Delete Account".tr,
                Image.asset(ImageSrc.DELETE, scale: 2),
                4,
              ),
            ]
                .map(
                  (e) => ListTile(
                    dense: true,
                    leading: e.icon,
                    title: Text(
                      e.title,
                      style: Theme.of(Get.context!).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                    onTap: () {
                      id = e.id;
                      Get.back();
                    },
                  ),
                )
                .toList(),
          ).paddingSymmetric(horizontal: 20),
        ],
      ),
      backgroundColor: Colors.white,

      shape: const OutlineInputBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
    );

    return id;
  }

  handleAccountActions(int id) async {
    switch (id) {
      case -1:
        break;
      case 0:
        Get.back();
        editAccountName(walletProvider.evmWallet?.privateKey ?? "");
        break;

      case 1:
        Get.back();

        Uri uri = Uri.parse(vrcUrl);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        } else {
          showSnack("Cant launch Now", isError: true);
        }

        break;

      case 2:
        Get.back();
        openWhatsApp(Get.context!);
        break;

      case 3:
        Get.back();

        Get.to(() => const WalletDetail());

        break;
      case 4:
        Get.back();

        await confirmToRemoveAccount();

        break;

      default:
    }
  }

  void editAccountName(String privateKey) async {
    await showDialog(
      context: Get.context!,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: Text('Please Type Account Name'.tr, style: Theme.of(context).textTheme.titleSmall),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppFormField(controller: walletProvider.accNameController).paddingOnly(bottom: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    if (walletProvider.accNameController.text.isEmpty) {
                      showSnack("Empty Text".tr, isError: true);

                      return;
                    }
                    await authProviders.authenticateUser()?.then((value) {
                      if (value == true) {
                        Get.back();

                        walletProvider.changeAccountName(privateKey);
                      }
                    });
                  },
                  child: Text("Submit".tr),
                ),
                TextButton(
                    onPressed: () async {
                      Get.back();
                    },
                    child: Text(
                      "Cancel".tr,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: primaryColor,
                          ),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> confirmToRemoveAccount() async {
    await showCupertinoModalPopup<void>(
      context: Get.context!,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Icon(
          Icons.warning,
          color: Colors.orangeAccent,
          size: 50,
        ),
        content: Text(
            'Do you want to remove account? Please import your private key before remove wallet'
                .tr),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(Get.context!);
            },
            child: Text('No'.tr),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () async {
              await authProviders.authenticateUser()?.then((value) {
                if (value == true) {
                  Navigator.pop(Get.context!);

                  walletProvider.deleteAccount();
                }
              });
            },
            child: Text('Yes'.tr),
          ),
        ],
      ),
    );
  }

  void openWhatsApp(context) async {
    Share.share(
      walletProvider.evmWallet?.walletAddress ?? "",
    );
  }
}

class BottomSheetDataModel {
  final String title;
  final Widget icon;
  int id;

  BottomSheetDataModel(this.title, this.icon, this.id);
}
