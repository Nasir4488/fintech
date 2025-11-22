import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/GlobalWidgets/expended_button.dart';
import '/Pages/Wallet/WalletSetupPages/wallet_setup_page.dart';
import '/Provider/theme_provider.dart';
import '/Services/storage_services.dart';
import '/Utils/extension.dart';
import '/assets.dart';

class WalletIntroPage extends StatefulWidget {
  const WalletIntroPage({super.key});

  @override
  State<WalletIntroPage> createState() => _WalletIntroPageState();
}

class _WalletIntroPageState extends State<WalletIntroPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = Get.height * .015;
    return Scaffold(
      bottomNavigationBar: ExpandedButton(
        label: "Started".tr,
        filled: true,
      ).paddingOnly(bottom: height, left: height * 2, right: height * 2).onTap(
        () {
          AppStorage.box.write(AppStorage.WALLET_INTRO, true);
          Get.to(() => const WalletSetupPage());
        },
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Positioned.fill(
            //   child: Image.asset(
            //     ImageSrc.CREATE_WALLET_BG,
            //     fit: BoxFit.fill,
            //   ),
            // ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: GestureDetector(
                    onHorizontalDragEnd: (a) {
                      if (pageIndex == 2) {}
                    },
                    child: PageView.builder(
                      controller: pageController,
                      itemCount: introList.length,
                      onPageChanged: (int i) {
                        pageIndex = i;
                        setState(() {});
                      },
                      itemBuilder: (BuildContext context, int index) {
                        final data = introList[index];
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              data.imagePath,
                              height: Get.height * .5,
                            ).paddingAll(height).paddingOnly(top: Get.height * .1),
                            const Expanded(child: SizedBox.shrink()),
                            Text(
                              data.title,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: textColor,
                                  ),
                            ).paddingOnly(bottom: height * 2),
                            Text(
                              data.description,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                            )
                                .paddingSymmetric(horizontal: Get.height * .01)
                                .paddingOnly(bottom: Get.height * .01),
                          ],
                        ).paddingSymmetric(horizontal: Get.height * .02);
                      },
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                      introList.length,
                      (index) => Container(
                            height: height,
                            width: height,
                            decoration: BoxDecoration(
                                gradient: pageIndex == index ? linearGradient : null,
                                border: Border.all(color: primaryColor),
                                color: pageIndex == index
                                    ? primaryColor
                                    : primaryColor.withOpacity(.2),
                                shape: BoxShape.circle),
                          ).paddingOnly(left: 5).paddingOnly(bottom: 20)),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  final PageController pageController = PageController();
  int pageIndex = 0;

  var introList = [
    IntroModel(
      "WELCOME".tr,
      " "
          .tr,
      ImageSrc.ARROW_UP,
    ),
    IntroModel(
      "MANAGE YOUR DIGITAL ASSETS".tr,
      "Store, spend, and send VRC coin.Like VRC coin & unique  Collectibles".tr,
      ImageSrc.ARROW_UP,
    ),
    IntroModel(
      "YOUR GATEWAY TO WEB3".tr,
      "Connect with VRC network to earn VRC coin to get financial freedom.".tr,
      ImageSrc.ARROW_UP,
    ),
  ];
}

class IntroModel {
  final String imagePath;
  final String description;
  final String title;

  IntroModel(this.title, this.description, this.imagePath);
}
