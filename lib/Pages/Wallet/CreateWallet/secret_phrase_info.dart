import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fin_tech/Utils/extension.dart';
import '/GlobalWidgets/expended_button.dart';
import '/GlobalWidgets/progress_bar_widget.dart';
import '/Pages/Wallet/CreateWallet/confirm_password.dart';
import '/Provider/providers.dart';
import '/Provider/theme_provider.dart';
import '/assets.dart';

class SecretPhraseInfo extends StatefulWidget {
  const SecretPhraseInfo({super.key});

  @override
  State<SecretPhraseInfo> createState() => _SecretPhraseInfoState();
}

class _SecretPhraseInfoState extends State<SecretPhraseInfo> {

  @override
  Widget build(BuildContext context) {
    final screenHeight=Get.height*.015;

    return Scaffold(
      body: Stack(
        children: [
          // Positioned.fill(
          //     child: Image.asset(
          //   ImageSrc.CREATE_WALLET_BG,
          //   fit: BoxFit.fill,
          // )),
          SizedBox(
            height: Get.height,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                       SizedBox(height: screenHeight*3),
                      const ProgressBarWidgetWalletCreating(2),
                      Image.asset(ImageSrc.LOCK_ICON_PNG).paddingOnly(top: screenHeight, bottom: screenHeight),
                      Text(
                        "SECURE YOUR WALLET".tr,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w700, color: textColor),
                      ).paddingOnly(bottom: screenHeight*2),
                      RichText(
                        text: TextSpan(
                            text: "Secure your wallet’s ".tr,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontWeight: FontWeight.w500),
                            children: [
                              TextSpan(
                                text: "Secret Recovery Phrase.".tr,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(color: textColor, fontWeight: FontWeight.w600),
                              )
                            ]),
                      ).paddingOnly(bottom: screenHeight),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(ImageSrc.INFO).paddingOnly(right: 3),
                          Text(
                            "Why is it important?".tr,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: textColor, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Manual".tr,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.w700, color: textColor),
                          ).paddingOnly(bottom: screenHeight/2),
                          Text(
                            "Write down your Secret Recovery Phrase on a piece of paper and store in a safe place."
                                .tr,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontWeight: FontWeight.w500),
                          ).paddingOnly(bottom: screenHeight/2),
                          Text(
                            "Security level:".tr,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.w700, color: textColor),
                          ).paddingOnly(bottom: 5),
                          Row(
                            children: List.generate(
                                5,
                                (index) => Image.asset(
                                      index < 2
                                          ? ImageSrc.ARROW_UP
                                          : ImageSrc.ARROW_UP,
                                      height: screenHeight*2,
                                    ).toGradientMask().paddingOnly(right: screenHeight/2)),
                          ).paddingOnly(bottom: screenHeight/2),
                          Text(
                            "Risks are:".tr,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.w700, color: textColor),
                          ).paddingOnly(bottom: screenHeight/2),
                          Row(children: [
                            CircleAvatar(
                                    backgroundColor:
                                        themeProvider.isDarkMode ? Colors.white : Colors.black,
                                    radius: 3)
                                .paddingOnly(right: screenHeight),
                            Text("You lose it".tr,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(fontWeight: FontWeight.w400))
                          ]).paddingOnly(bottom: screenHeight/2),
                          Row(children: [
                            CircleAvatar(
                                    backgroundColor:
                                        themeProvider.isDarkMode ? Colors.white : Colors.black,
                                    radius: 3)
                                .paddingOnly(right: screenHeight),
                            Text("You forget where you put it".tr,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(fontWeight: FontWeight.w400))
                          ]).paddingOnly(bottom: screenHeight/2),
                          Row(children: [
                            CircleAvatar(
                                    backgroundColor:
                                        themeProvider.isDarkMode ? Colors.white : Colors.black,
                                    radius: 3)
                                .paddingOnly(right: screenHeight),
                            Text("Someone else finds it".tr,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(fontWeight: FontWeight.w400))
                          ]).paddingOnly(bottom: screenHeight/2),
                          Text("Other options: Doesn't have to be paper!".tr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(fontWeight: FontWeight.w400))
                              .paddingOnly(bottom: screenHeight/2),
                          Text(
                            "Tips:".tr,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.w700, color: textColor),
                          ).paddingOnly(bottom: screenHeight),
                          Row(children: [
                            CircleAvatar(
                                    backgroundColor:
                                        themeProvider.isDarkMode ? Colors.white : Colors.black,
                                    radius: 3)
                                .paddingOnly(right: screenHeight),
                            Text("Store in bank vault".tr,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(fontWeight: FontWeight.w400))
                          ]).paddingOnly(bottom: screenHeight/2),
                          Row(children: [
                            CircleAvatar(
                                    backgroundColor:
                                        themeProvider.isDarkMode ? Colors.white : Colors.black,
                                    radius: 3)
                                .paddingOnly(right: screenHeight),
                            Text("Store in a safet".tr,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(fontWeight: FontWeight.w400))
                          ]).paddingOnly(bottom: screenHeight/2),
                          Row(children: [
                            CircleAvatar(
                                    backgroundColor:
                                        themeProvider.isDarkMode ? Colors.white : Colors.black,
                                    radius: 3)
                                .paddingOnly(right: screenHeight),
                            Text("Store in multiple secret places".tr,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(fontWeight: FontWeight.w400))
                          ]).paddingOnly(bottom: screenHeight*2),
                        ],
                      )
                    ],
                  ).paddingSymmetric(horizontal: screenHeight*2),
                ],
              ),
            ),
          ),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ExpandedButton(
                  label: "Start".tr,
                  filled: true,
                  onPress: () {
                    Get.to(() => const ConfirmPasswordPage());
                  }).paddingSymmetric(horizontal: screenHeight*2, vertical: screenHeight*2))
        ],
      ),
    );
  }
}
