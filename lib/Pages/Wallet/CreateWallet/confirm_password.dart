import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fin_tech/Pages/Wallet/CreateWallet/show_recovery_phrase.dart';
import '/GlobalWidgets/expended_button.dart';
import '/GlobalWidgets/input_field.dart';
import '/GlobalWidgets/progress_bar_widget.dart';
import '/Provider/theme_provider.dart';
import '/Services/storage_services.dart';

class ConfirmPasswordPage extends StatefulWidget {
  const ConfirmPasswordPage({super.key});

  @override
  State<ConfirmPasswordPage> createState() => _ConfirmPasswordPageState();
}

class _ConfirmPasswordPageState extends State<ConfirmPasswordPage> {
  final passwordCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final screenHeight=Get.height*.015;

    return Scaffold(
      body: Stack(
        children: [
          // Positioned.fill(child: Image.asset(ImageSrc.CREATE_WALLET_BG, fit: BoxFit.fill)),
          Column(
            children: [
              const SizedBox(height: 40),
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const ProgressBarWidgetWalletCreating(2).paddingOnly(bottom: screenHeight*3),
                    Text(
                      "CONFIRM PASSWORD",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.w700, color: textColor),
                    ),
                    Text(
                      "Before continuing we need you to confirm your password",
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ).paddingOnly(bottom: screenHeight*4),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Confirm your  Password",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ).paddingOnly(bottom: screenHeight),
                    AppFormField(
                      obscureText: true,
                      maxLine: 1,
                      hintText: "Confirm Your Password",
                      controller: passwordCtrl,
                      validator: (String? v) {
                        if (v!.isEmpty) {
                          return "Required";
                        }
                        String? password = AppStorage.box.read(AppStorage.WALLET_PASSWORD);
                        if (password == null || password != passwordCtrl.text) {
                          return "Password Mismatch";
                        }

                        return null;
                      },
                    ).paddingOnly(bottom: screenHeight*3),
                  ],
                ).paddingSymmetric(horizontal: screenHeight*2),
              ),
            ],
          ),
          Positioned(
              left: 10,
              right: 10,
              bottom: 20,
              child: ExpandedButton(
                label: "CONFIRM",
                filled: true,
                onPress: () {
                  validateFormAndHandleData();
                },
              ).paddingSymmetric(horizontal: screenHeight*2))
        ],
      ),
    );
  }

  void validateFormAndHandleData() {
    if (!formKey.currentState!.validate()) return;
    Get.to(() => const ShowRecoveryPhrase());
    passwordCtrl.clear();
  }
}
