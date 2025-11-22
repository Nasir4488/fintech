import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fin_tech/Utils/utils.dart';
import 'package:fin_tech/assets.dart';
import '/GlobalWidgets/expended_button.dart';
import '/Pages/Wallet/WalletSetupPages/wallet_terms_of_use.dart';
import '/Provider/theme_provider.dart';
import '/utils/extension.dart';

class WalletPrivacyPolicy extends StatelessWidget {
  final bool? isImport;

  const WalletPrivacyPolicy(this.isImport, {super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight=Get.height*.015;

    return Scaffold(
      body: Stack(
        children: [
          // Positioned.fill(child: Image.asset(ImageSrc.CREATE_WALLET_BG, fit: BoxFit.fill)),
          SizedBox(
            height: Get.height,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "HELP US IMPROVE $appName",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                  ).paddingOnly(bottom:screenHeight/2, top: screenHeight*5),
                  Text(
                    "agreement info1".tr,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(color: Colors.grey, fontWeight: FontWeight.w400),
                  ).paddingOnly(bottom: screenHeight),
                  Text(
                    "VRC Network will...".tr,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w400,
                          color: textColor,
                        ),
                  ).paddingOnly(bottom: screenHeight),
                  getPrivacy(context),
                  Column(
                    children: [
                      Text(
                        "This data is aggregated and is therefore anonymous for"
                                " the purposes of General Data Protection Regulation (EU) 2016/679."
                            .tr,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(color: Colors.grey, fontWeight: FontWeight.w500),
                      ).paddingOnly(bottom: screenHeight),
                      Text(
                        "agreement info1".tr,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(color: Colors.grey, fontWeight: FontWeight.w500),
                      ).paddingOnly(bottom: screenHeight),
                      RichText(
                        text: TextSpan(
                          text: 'configure your RPC provider '.tr,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(color: Colors.grey, fontWeight: FontWeight.w500),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'here'.tr,
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: textColor,
                                  ),
                            ),
                            TextSpan(
                              text:
                                  ' before proceeding. For more information on how VRC Network and Infura interact from a data collection perspective, see our update'
                                      .tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(color: Colors.grey, fontWeight: FontWeight.w500),
                            ),
                            TextSpan(
                                text: ' here'.tr,
                                style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                          ],
                        ),
                      ).paddingOnly(bottom: 15),
                      RichText(
                        text: TextSpan(
                          text:
                              'For more information on our privacy practices in general, see our Privacy Policy '
                                  .tr,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(color: Colors.grey, fontWeight: FontWeight.w500),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'here'.tr,
                                style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                          ],
                        ),
                      ).paddingOnly(bottom: screenHeight),
                    ],
                  ).paddingAll(screenHeight).paddingOnly(bottom: screenHeight*4),
                ],
              ).paddingSymmetric(horizontal: screenHeight).paddingOnly(bottom: screenHeight),
            ),
          ),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Row(
                children: [
                  Expanded(
                    child: ExpandedButton(
                      filled: true,
                      label: "I AGREE".tr,
                    ).onTap(() {
                      Get.to(() => WalletTermsOfUse(import: isImport));
                    }),
                  ),
                   SizedBox(width: screenHeight*2),
                  Expanded(
                      child: ExpandedButton(
                    label: "NO THANKS".tr,
                  ).onTap(() => Get.back())),
                ],
              ).paddingSymmetric(horizontal: screenHeight*2, vertical: screenHeight*2))
        ],
      ),
    );
  }

  Widget getPrivacy(context) {
    return Column(
      children: [
        Row(
          children: [
            Image.asset(
              ImageSrc.CHECK_CIRCLE,
              height: Get.height * .015,
            ).paddingOnly(right: 10),
            Expanded(
                child: Text(
              "Always allow you to opt-out via Settings".tr,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: Colors.grey, fontWeight: FontWeight.w500),
            ))
          ],
        ).paddingOnly(bottom: 5),
        Row(
          children: [
            Image.asset(
              ImageSrc.CHECK_CIRCLE,
              height: Get.height * .015,
            ).paddingOnly(right: 10),
            Expanded(
                child: Text(
              "Send anonymized click & page view events".tr,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: Colors.grey, fontWeight: FontWeight.w500),
            ))
          ],
        ).paddingOnly(bottom: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              ImageSrc.UN_CHECK_CIRCLE,
              height: Get.height * .015,
            ).paddingOnly(right: 10),
            Expanded(
                child: Text(
              "Never collect information we don’t need to provide the service (such as keys, addresses, transaction hashes, or balances)"
                  .tr,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: Colors.grey, fontWeight: FontWeight.w500),
            ))
          ],
        ).paddingOnly(bottom: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              ImageSrc.UN_CHECK_CIRCLE,
              height: Get.height * .015,
            ).paddingOnly(right: 10),
            Expanded(
                child: Text(
              "Never collect your full IP address*".tr,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: Colors.grey, fontWeight: FontWeight.w500),
            ))
          ],
        ).paddingOnly(bottom: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              ImageSrc.UN_CHECK_CIRCLE,
              height: Get.height * .015,
            ).paddingOnly(right: 10),
            Expanded(
                child: Text(
              "Never sell data, Ever!".tr,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: Colors.grey, fontWeight: FontWeight.w500),
            ))
          ],
        ).paddingOnly(bottom: 5),
      ],
    );
  }
}
