import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fin_tech/assets.dart';
import '/GlobalWidgets/progress_bar_widget.dart';
import '/Pages/Wallet/CreateWallet/create_mnemonic_phrase.dart';

import '/Provider/theme_provider.dart';
import '/Utils/utils.dart';

class ShowRecoveryPhrase extends StatefulWidget {
  const ShowRecoveryPhrase({super.key});

  @override
  State<ShowRecoveryPhrase> createState() => _ShowRecoveryPhraseState();
}

class _ShowRecoveryPhraseState extends State<ShowRecoveryPhrase> {
  bool showPhrase = false;

  @override
  Widget build(BuildContext context) {
    final screenHeight = Get.height * .015;

    return Scaffold(
        body: SizedBox(
      height: Get.height,
      child: Stack(
        children: [
          // Positioned.fill(child: Image.asset(ImageSrc.CREATE_WALLET_BG, fit: BoxFit.fill)),
          !showPhrase
              ? SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: screenHeight * 4),
                      const ProgressBarWidgetWalletCreating(2),
                      Text(
                        "Write down your Secret Recovery Phrase".tr,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w700, color: textColor),
                        textAlign: TextAlign.center,
                      ).paddingSymmetric(vertical: screenHeight * 2),
                      Text(
                              "This is your Secret Recovery Phrase. "
                                      "Write it down on a paper and keep it in a safe "
                                      "place. You'll be asked to re-enter this phrase "
                                      "(in order) on the next step."
                                  .tr,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w400))
                          .paddingSymmetric(horizontal: Get.width * .1)
                          .paddingOnly(bottom: 20),
                      Container(
                        decoration: BoxDecoration(
                            gradient: linearGradient,
                            borderRadius: BorderRadius.circular(screenHeight)),
                        child: Column(
                          children: [
                            Image.asset(ImageSrc.EYE_OFF),
                            Text(
                              "Long press to reveal your Secret Recovery Phrase",
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700, color: Colors.black),
                            ).paddingOnly(bottom: screenHeight / 2),
                            Text(
                              "Make sure no one is watching your screen".tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w500, color: Colors.black),
                              textAlign: TextAlign.center,
                            ).paddingOnly(bottom: screenHeight * 2),
                            SizedBox(
                              width: Get.width * .4,
                              child: GestureDetector(
                                onTap: () {
                                  showSnack("Long Press to reveal Phrase".tr);
                                },
                                onLongPress: () {
                                  showPhrase = true;
                                  setState(() {});
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.circular(100)),
                                  child: Center(
                                    child: Text(
                                      "Hold to View".tr,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(color: Colors.black),
                                    ).paddingSymmetric(vertical: screenHeight),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ).paddingAll(screenHeight * 2),
                      )
                    ],
                  ).paddingSymmetric(horizontal: screenHeight * 2),
                )
              : const CreateMnemonicPage(),
        ],
      ),
    ));
  }
}
