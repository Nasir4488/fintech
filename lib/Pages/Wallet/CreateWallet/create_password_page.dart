import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/GlobalWidgets/expended_button.dart';
import '/GlobalWidgets/input_field.dart';
import '/GlobalWidgets/progress_bar_widget.dart';
import '/Pages/Wallet/CreateWallet/secure_your_wallet.dart';
import '/Provider/theme_provider.dart';
import '/Services/storage_services.dart';
import '/Utils/extension.dart';
import '/assets.dart';

class CreatePasswordPage extends StatefulWidget {
  const CreatePasswordPage({super.key});

  @override
  State<CreatePasswordPage> createState() => _CreatePasswordPageState();
}

class _CreatePasswordPageState extends State<CreatePasswordPage> {
  final passwordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();
  bool agree = false;
  final formKey = GlobalKey<FormState>();

  bool showPassword = true;

  @override
  Widget build(BuildContext context) {
    final screenHeight = Get.height * .015;
    return Scaffold(
      body: Stack(
        children: [
          // Positioned.fill(
          //   child: Image.asset(
          //     // ImageSrc.CREATE_WALLET_BG,
          //     fit: BoxFit.fill,
          //   ),
          // ),
          Form(
            key: formKey,
            child: SizedBox(
              height: Get.height,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: screenHeight * 4),
                    const ProgressBarWidgetWalletCreating(1),
                    SizedBox(
                        height: screenHeight*15,
                        child: Image.asset(ImageSrc.DRAGON)).paddingOnly(bottom: screenHeight*2),
                    Text(
                      "CREATE PASSWORD".tr,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
                    ),
                    Text(
                      "This password will unlock your VRC Network wallet only on this device".tr,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.w500),
                    ).paddingOnly(bottom: screenHeight),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Enter new password".tr,
                            style: Theme.of(context).textTheme.titleSmall),
                        Image.asset(!showPassword ? ImageSrc.EYE : ImageSrc.EYE_OFF,
                                scale: 20, color: primaryColor)
                            .toGradientMask()
                            .onTap(() {
                          showPassword = !showPassword;
                          setState(() {});
                        })
                      ],
                    ).paddingOnly(top: screenHeight, bottom: screenHeight),
                    AppFormField(
                      obscureText: showPassword,
                      maxLine: 1,
                      controller: passwordCtrl,
                      validator: (String? v) {
                        if (v!.isEmpty) {
                          return "Required".tr;
                        } else if (passwordCtrl.text.length < 4) {
                          return "Too short".tr;
                        }
                
                        return null;
                      },
                      hintText: "Enter new password".tr,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Confirm password".tr, style: Theme.of(context).textTheme.titleSmall),
                      ],
                    ).paddingOnly(top: screenHeight * 2, bottom: screenHeight),
                    AppFormField(
                      maxLine: 1,
                      obscureText: showPassword,
                      controller: confirmPasswordCtrl,
                      validator: (String? v) {
                        if (v!.isEmpty) {
                          return "Required".tr;
                        } else if (passwordCtrl.text != confirmPasswordCtrl.text) {
                          return "Password Mismatch".tr;
                        }
                        return null;
                      },
                      hintText: "Confirm password".tr,
                    ).paddingOnly(bottom: screenHeight * 2),
                    Row(
                      children: [
                        Checkbox(
                          value: agree,
                          onChanged: (bool? onChanged) {
                            agree = onChanged!;
                            setState(() {});
                          },
                          fillColor: WidgetStateProperty.all<Color>(Colors.grey),
                          activeColor: Theme.of(context).cardColor,
                        ),
                        Expanded(
                            child: RichText(
                          text: TextSpan(
                            text:
                                'I understand that VRC Network cannot recover this password for me.'
                                    .tr,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        )),
                      ],
                    ).paddingOnly(bottom: screenHeight*2).onTap(() {
                      agree = !agree;
                      setState(() {});
                    }),
                    if (agree)
                      ExpandedButton(label: "CREATE PASSWORD".tr, filled: true).onTap(() {
                        validateFormAndHandleData();
                      })
                  ],
                ).paddingSymmetric(horizontal: screenHeight*2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void validateFormAndHandleData() async {
    if (!formKey.currentState!.validate()) return;
    await AppStorage.box.write(AppStorage.WALLET_PASSWORD, passwordCtrl.text);

    Get.to(() => const SecureYourWallet());
  }
}
