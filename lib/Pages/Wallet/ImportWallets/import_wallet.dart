import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fin_tech/Pages/Wallet/ImportWallets/scan_qr_import_wallets_page.dart';
import 'package:fin_tech/Pages/Wallet/greeting_page.dart';
import 'package:fin_tech/Provider/providers.dart';
import 'package:fin_tech/Services/storage_services.dart';
import 'package:fin_tech/Utils/extension.dart';
import 'package:fin_tech/Utils/utils.dart';
import 'package:fin_tech/assets.dart';
import '/GlobalWidgets/expended_button.dart';
import '/GlobalWidgets/input_field.dart';
import '/Provider/theme_provider.dart';

class ImportWalletPage extends StatefulWidget {
  const ImportWalletPage({super.key});

  @override
  State<ImportWalletPage> createState() => _ImportWalletPageState();
}

class _ImportWalletPageState extends State<ImportWalletPage> with SingleTickerProviderStateMixin {
  final passwordCtrl = TextEditingController();
  final reEnterPasswordCtrl = TextEditingController();
  final secretPhraseCtrl = TextEditingController();
  bool obscureText = true;
  final formKey = GlobalKey<FormState>();
  bool showPrivateKey = true;
  bool showPassword = true;
  bool hideButton = false;
  bool isAgree = false;

  @override
  Widget build(BuildContext context) {
    final screenHeight=Get.height*.015;

    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(ImageSrc.DRAGON, height: Get.height * .18).paddingOnly(bottom: screenHeight),
              Text(
                "IMPORT SEEDS",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
              ).paddingOnly(bottom: screenHeight*2),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Secret Recovery Phrase", style: Theme.of(context).textTheme.titleSmall)
                      .paddingOnly(bottom: screenHeight/2),
                  AppFormField(
                    validator: (String? v) {
                      if (!walletProvider.validateMnemonic(secretPhraseCtrl.text)) {
                        return "Invalid mnemonic phrase";
                      }
                      return null;
                    },
                    controller: secretPhraseCtrl,
                    hintText: "Enter Recovery Phrase",
                    suffix: Image.asset(ImageSrc.QR_CODE, scale: 2.5).onTap(() async {
                      String? res = await Get.to(() => const ScanQrImportWalletPage());

                      if (!walletProvider.validateMnemonic(res ?? "")) {
                        showToast("Invalid Secrete Phrases");
                        return;
                      }

                      secretPhraseCtrl.text = res ?? "";
                    }),
                  ).paddingOnly(bottom: screenHeight),
                  Text("Enter new password", style: Theme.of(context).textTheme.titleSmall)
                      .paddingOnly(bottom: screenHeight/2),
                  AppFormField(
                    obscureText: showPassword,
                    maxLine: 1,
                    controller: passwordCtrl,
                    validator: (String? v) {
                      if (v!.isEmpty) return "Required";

                      return null;
                    },
                    hintText: "Enter new password",
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Enter Confirm password", style: Theme.of(context).textTheme.titleSmall),
                    ],
                  ).paddingOnly(top: screenHeight/2, bottom: screenHeight/2),
                  AppFormField(
                    maxLine: 1,
                    obscureText: showPassword,
                    controller: reEnterPasswordCtrl,
                    validator: (String? v) {
                      if (v!.isEmpty) {
                        return "Required";
                      } else if (passwordCtrl.text != reEnterPasswordCtrl.text) {
                        return "Password Mismatch";
                      }
                      return null;
                    },
                    hintText: "Confirm password",
                  ).paddingOnly(bottom: screenHeight),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "* ",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.red),
                      ),
                      Expanded(
                        child: Text(
                            "The VRC Network application does not store your secret phrase and "
                            "password online anywhere. This password will "
                            "only unlock your VRC Network wallet on this device.",
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontWeight: FontWeight.w400)),
                      ),
                    ],
                  ).paddingOnly(bottom: screenHeight),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Checkbox(
                          value: isAgree,
                          onChanged: (onChanged) {
                            isAgree = onChanged ?? false;
                            setState(() {});
                          }),
                      Expanded(
                        child: Text(
                          "I understand that VRC NETWORK can not recover the password for me ",
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(fontWeight: FontWeight.w400),
                        ),
                      )
                    ],
                  ),
                  hideButton
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              strokeWidth: 2,
                              color: primaryColor,
                            )
                          ],
                        )
                      : Row(
                          children: [
                            Expanded(
                              child: ExpandedButton(
                                filled: true,
                                onPress: () async {
                                  if (!isAgree) {
                                    showToast("Please Agree Before Continue");
                                    return;
                                  }

                                  setState(() {});
                                  _getStringAndGeneratePrivateKey().then((value) {});
                                },
                                label: "Import",
                              ).paddingAll(screenHeight*2),
                            ),
                          ],
                        ),
                ],
              ),
            ],
          ).paddingSymmetric(horizontal: screenHeight),
        ),
      ),
    );
  }

  Future<void> _getStringAndGeneratePrivateKey() async {
    if (!formKey.currentState!.validate()) return;
    hideButton = true;
    secretPhraseCtrl.text = secretPhraseCtrl.text.trimRight();
    String privateKey = await walletProvider.getPrivateKey(secretPhraseCtrl.text);
    await AppStorage.box.write(AppStorage.WALLET_PASSWORD, passwordCtrl.text);
    AppStorage.box.write(AppStorage.MASTER_SEEDS, secretPhraseCtrl.text);
    passwordCtrl.clear();
    reEnterPasswordCtrl.clear();
    secretPhraseCtrl.clear();
    await walletProvider.importWallet(privateKey).then((value) {
      if (value) {
        Get.offAll(() => const GreetingPage());
      }
    });
  }
}
