import 'package:fin_tech/Pages/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fin_tech/Pages/Wallet/ShowWallet/wallet_page.dart';
import '/GlobalWidgets/expended_button.dart';
import '/Provider/theme_provider.dart';
import '/assets.dart';

class GreetingPage extends StatelessWidget {
  const GreetingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = Get.height * .015;
    return Scaffold(
      body: SizedBox(
        height: Get.height,
        child: Stack(
          children: [
            // Positioned.fill(child: Image.asset(ImageSrc.CREATE_WALLET_BG, fit: BoxFit.fill)),
            Column(
              children: [
                Image.asset(
                  ImageSrc.GREETING_PNG,
                ).paddingOnly(top: screenHeight),
                Text(
                  "CONGRATULATIONS".tr,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700, color: textColor, fontSize: screenHeight * 2),
                ).paddingOnly(bottom: screenHeight / 2),
                Text(
                  "You've successfully protected your wallet."
                          " Remember to keep your Secret Recovery Phrase safe,"
                          " it's your responsibility!"
                      .tr,
                  style:
                      Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                )
                    .paddingSymmetric(horizontal: Get.width * .1)
                    .paddingOnly(bottom: screenHeight * 2),
                Text(
                  "Leave yourself a hint?".tr,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.w400,
                      ),
                ).paddingOnly(bottom: screenHeight),
                Text(
                  "VRC Network cannot recover your wallet "
                          "should you lose it. You can find your Secret "
                          "Recovery Phrase in Settings > Security & Privacy."
                      .tr,
                  textAlign: TextAlign.center,
                  style:
                      Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w400),
                )
                    .paddingSymmetric(horizontal: Get.width * .1)
                    .paddingOnly(bottom: screenHeight * 2),
              ],
            ).paddingSymmetric(horizontal: screenHeight * 2).paddingOnly(bottom: screenHeight * 5),
            Positioned(
                bottom: screenHeight,
                left: screenHeight,
                right: screenHeight,
                child: ExpandedButton(
                  label: "Done".tr,
                  onPress: () {
                    Get.offAll(()=> const LandingPage());
                    Get.to(()=> const WalletPage());
                  },
                  filled: true,
                ))
          ],
        ),
      ),
    );
  }
}
