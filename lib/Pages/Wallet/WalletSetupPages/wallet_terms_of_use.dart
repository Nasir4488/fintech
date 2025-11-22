import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:fin_tech/Provider/theme_provider.dart';
import 'package:fin_tech/Utils/extension.dart';
import '/GlobalWidgets/expended_button.dart';
import '/Pages/Wallet/CreateWallet/create_password_page.dart';
import '/Pages/Wallet/ImportWallets/import_wallet.dart';

class WalletTermsOfUse extends StatefulWidget {
  final bool? import;

  const WalletTermsOfUse({this.import, super.key});

  @override
  State<WalletTermsOfUse> createState() => _WalletTermsOfUseState();
}

class _WalletTermsOfUseState extends State<WalletTermsOfUse> {
  bool agree = false;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    scrollController.addListener(() {
      return scrollListener();
    });
    super.initState();
  }

  void scrollListener() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent) {
      // showAgree = true;
      setState(() {});
      return;
    } else {
      // showAgree=true;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight=Get.height*.015;

    return Scaffold(

      body: SafeArea(
        child: Stack(

          children: [
            AppBar(),
            // Positioned.fill(child: Image.asset(ImageSrc.CREATE_WALLET_BG, fit: BoxFit.fill)),

            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: Get.height*.1),
                  Text("Import from seed".tr,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.w700, color: textColor))
                      .paddingOnly(bottom: screenHeight),
                  Text("Review our latest Terms of Use".tr,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700))
                      .paddingOnly(bottom: screenHeight),
                  Text("Terms of Use".tr,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.w700, color: textColor))
                      .paddingOnly(bottom: screenHeight/2),
                  Text("Last Update: Feb/2023".tr,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700))
                      .paddingOnly(bottom: screenHeight*2),
                  Container(
                    width: Get.width,
                    height: Get.height * .4,
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(screenHeight)),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: termsOfUse(),
                    ),
                  ).paddingOnly(bottom: screenHeight*2),
                  // if (showAgree)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: agree,
                        onChanged: (bool? onChanged) {
                          agree = onChanged!;
                          setState(() {});
                        },
                        fillColor: WidgetStateProperty.all<Color>(Colors.grey),
                        checkColor: Colors.black,
                      ),
                      Expanded(
                          child: Text(
                        "I agree to the Terms of Use ,which apply to my "
                                "use of VRC Network and all of its features"
                            .tr,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontWeight: FontWeight.w400),
                      )),
                    ],
                  ).paddingOnly(bottom: screenHeight*2).onTap(() {
                    agree = !agree;
                    setState(() {});
                  }),
                  if (agree)
                    ExpandedButton(
                        label: "I AGREE".tr,
                        filled: true,
                        onPress: () {
                          if (widget.import == true) {
                            Get.to(() => const ImportWalletPage());
                            return;
                          }

                          Get.to(() => const CreatePasswordPage());
                        }).paddingOnly(bottom: screenHeight*2),

                ],
              ).paddingSymmetric(horizontal: screenHeight).animate().fadeIn(delay: 250.ms),
            ),
          ],
        ),
      ),
    );
  }

  Widget termsOfUse() {
    return Column(
      children: [
        Text(
          "agreementText1".tr,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w400),
        ),
        Text(
          "agreementText2".tr,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w400),
        ),
        Text(
          "agreementText3".tr,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w400),
        ),
      ],
    ).paddingAll(20);
  }
}
