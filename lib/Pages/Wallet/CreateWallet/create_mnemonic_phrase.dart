import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/GlobalWidgets/expended_button.dart';
import '/GlobalWidgets/progress_bar_widget.dart';
import '/Pages/Wallet/CreateWallet/verify_mnemonic_page.dart';
import '/Provider/providers.dart';
import '/Provider/theme_provider.dart';

class CreateMnemonicPage extends StatefulWidget {
  const CreateMnemonicPage({super.key});

  @override
  State<CreateMnemonicPage> createState() => _CreateMnemonicPageState();
}

class _CreateMnemonicPageState extends State<CreateMnemonicPage> {
  @override
  void initState() {
    walletProvider.mnemonic = walletProvider.generateMnemonic();
    authProviders.preventScreenshotOn();

    super.initState();
  }

  @override
  void dispose() {
    authProviders.preventScreenshotOff();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight=Get.height*.015;

    final List<String>? mnemonicWords = walletProvider.mnemonic?.split(" ");
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
           SizedBox(height: screenHeight*4),
          const ProgressBarWidgetWalletCreating(2, fill2: true),
          Text(
            "Write down your Secret Recovery Phrase".tr,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: textColor),
          ).paddingOnly(bottom: screenHeight*2),
          Text(
            "This is your Secret Recovery Phrase. Write it down on a paper and keep it in "
                    "a safe place. You'll be asked to re-enter this phrase (in order) "
                    "on the next step."
                .tr,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w400),
          ).paddingOnly(bottom: screenHeight*2),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(screenHeight),
              gradient: linearGradient,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    children: List.generate(
                      6,
                      (index) => Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius:
                                BorderRadius.circular(MediaQuery.of(context).size.height * .1)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                "${index + 1}. ${mnemonicWords![index].toLowerCase()}",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(color: Colors.black),
                              ).paddingSymmetric(horizontal: screenHeight, vertical: 2.5),
                            ],
                          ),
                        ),
                      ).paddingOnly(bottom: screenHeight),
                    ),
                  ),
                ),
                 SizedBox(width: screenHeight),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                        12,
                        (index) => index > 5
                            ? Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        MediaQuery.of(context).size.height * .1),
                                    border: Border.all(color: Colors.black)),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      "${index + 1}. ${mnemonicWords![index].toLowerCase()}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(color: Colors.black),
                                    ).paddingSymmetric(horizontal: screenHeight, vertical: 2.5),
                                  ],
                                ),
                              ).paddingOnly(bottom: screenHeight)
                            : const SizedBox()),
                  ),
                ),
              ],
            ).paddingAll(screenHeight*2),
          ).paddingOnly(bottom: screenHeight*3),
          ExpandedButton(
            label: "CONFIRM".tr,
            filled: true,
            onPress: () async {
              authProviders.preventScreenshotOff();

              Get.to(VerifyMnemonicPage(mnemonicWords!));
            },
          ),
        ],
      ).paddingSymmetric(horizontal: screenHeight*2),
    );
  }
}
