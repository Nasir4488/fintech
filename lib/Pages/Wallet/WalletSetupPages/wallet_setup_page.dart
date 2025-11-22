import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fin_tech/Provider/theme_provider.dart';
import '/GlobalWidgets/expended_button.dart';
import '/Pages/Wallet/WalletSetupPages/wallet_privacy_policy.dart';
import '/Utils/extension.dart';

class WalletSetupPage extends StatefulWidget {
  const WalletSetupPage({super.key});

  @override
  State<WalletSetupPage> createState() => _WalletSetupPageState();
}

class _WalletSetupPageState extends State<WalletSetupPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = Get.height * .015;
    return Scaffold(
      body: Stack(
        children: [
          // Positioned.fill(child: Image.asset(ImageSrc.CREATE_WALLET_BG, fit: BoxFit.fill)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                "Wallet Setup".tr,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      color: textColor,
                    ),
              ).paddingOnly(top: Get.height * .1),
              Text(
                "Import an existing wallet or create a new one".tr,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey,
                      fontWeight: FontWeight.w700,
                    ),
                textAlign: TextAlign.center,
              ),
              const Expanded(child: SizedBox()),
              // Image.asset(ImageSrc.WALLET_SETUP, height: Get.height * .5),
              const Expanded(child: SizedBox()),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ExpandedButton(
                    label: "Import Using Secret Phrases ".tr,
                  )
                      .paddingOnly(bottom: screenHeight, left: screenHeight, right: screenHeight)
                      .onTap(
                    () {
                      Get.to(() => const WalletPrivacyPolicy(true));
                    },
                  ),
                  ExpandedButton(
                    filled: true,
                    label: "Create a New Wallet".tr,
                  )
                      .paddingOnly(
                          bottom: screenHeight * 2, left: screenHeight, right: screenHeight)
                      .onTap(
                    () {
                      Get.to(() => const WalletPrivacyPolicy(false));
                    },
                  ),
                ],
              )
            ],
          ).paddingAll(10),
        ],
      ),
    );
  }
}
