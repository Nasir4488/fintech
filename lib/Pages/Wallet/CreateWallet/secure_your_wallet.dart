import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/GlobalWidgets/expended_button.dart';
import '/GlobalWidgets/progress_bar_widget.dart';
import '/Pages/Wallet/CreateWallet/secret_phrase_info.dart';
import '/Provider/theme_provider.dart';

class SecureYourWallet extends StatelessWidget {
  const SecureYourWallet({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight=Get.height*.015;

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Positioned.fill(child: Image.asset(ImageSrc.CREATE_WALLET_BG, fit: BoxFit.fill)),
            SizedBox(
              height: Get.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const ProgressBarWidgetWalletCreating(2),
                  Text(
                    "SECURE YOUR WALLET".tr,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.w700, color: textColor),
                  ),
                  // Image.asset(ImageSrc.SECURE_WALLET, height: Get.height * .5),
                  RichText(
                    text: TextSpan(
                      text: "Don’t risk losing your funds. Protect your "
                              "wallet by saving your "
                          .tr,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                      children: <TextSpan>[
                        TextSpan(
                          text: "Secret Recovery Phrase ".tr,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(color: textColor, fontWeight: FontWeight.w600),
                        ),
                        TextSpan(
                          text: "in a place you trust. ".tr,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        TextSpan(
                            text: "It’s the only way to recover your wallet if you get "
                                    "locked out of the app or get a new device."
                                .tr,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontWeight: FontWeight.w600)),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ).paddingOnly(bottom: screenHeight*5),
                ],
              ).paddingSymmetric(horizontal: screenHeight*2),
            ),
            Positioned(bottom: 0,left: 0,right: 0,child: ExpandedButton(
                label: "Start".tr,
                filled: true,
                onPress: () {
                  Get.to(() => const SecretPhraseInfo());
                }).paddingAll(screenHeight*2),)
          ],
        ),
      ),
    );
  }
}
