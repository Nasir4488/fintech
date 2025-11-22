import 'package:flutter/material.dart';
import 'package:fin_tech/Pages/Wallet/ShowWallet/Widgets/show_private_key.dart';
import 'package:fin_tech/Provider/theme_provider.dart';
import 'package:fin_tech/assets.dart';
import '/GlobalWidgets/expended_button.dart';
import '/GlobalWidgets/input_field.dart';
import '/Pages/Wallet/ShowWallet/Widgets/info_to_show_private_key.dart';

import 'package:get/get.dart';
import '/Services/storage_services.dart';

class WalletDetail extends StatefulWidget {
  const WalletDetail({super.key});

  @override
  State<WalletDetail> createState() => _WalletDetailState();
}

class _WalletDetailState extends State<WalletDetail> {
  final passwordCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool showPrivateKeyInfo = false;
  bool showKey = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Show Private Key",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: linearGradient,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(30),
                  topLeft: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Save it somewhere safe and secret.",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                  ).paddingOnly(top: 10, bottom: 5),
                  Container(
                    decoration: BoxDecoration(
                        color: const Color(0xff670000), borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          ImageSrc.WARNING,
                          scale: 2,
                        ),
                        Expanded(
                          child: Text(
                            "Never disclose this key. "
                            "Anyone with your private key can "
                            "fully control your account, "
                            "including transferring away any of your funds.",
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                          ).paddingSymmetric(horizontal: 20, vertical: 20),
                        ),
                      ],
                    ).paddingSymmetric(horizontal: 20),
                  ),
                ],
              ).paddingSymmetric(horizontal: 10),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: Get.height * .22),
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!showPrivateKeyInfo)
                    Column(
                      children: [
                        Text(
                          "ENTER PASSWORD TO CONTINUE",
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: textColor,
                              ),
                        ).paddingOnly(top: 20, bottom: 10),
                        Form(
                          key: formKey,
                          child: AppFormField(
                            obscureText: true,
                            maxLine: 1,
                            controller: passwordCtrl,
                            hintText: "Password",
                            validator: (String? v) {
                              if (v!.isEmpty) {
                                return "Required";
                              } else if (AppStorage.box.read(AppStorage.WALLET_PASSWORD) !=
                                  passwordCtrl.text) {
                                return "Wrong Password";
                              }

                              return null;
                            },
                          ),
                        ).paddingOnly(bottom: 20),
                        ExpandedButton(
                          filled: true,
                          label: "Next",
                          onPress: () {
                            if (!formKey.currentState!.validate()) return;
                            FocusManager.instance.primaryFocus?.unfocus();

                            passwordCtrl.clear();
                            showPrivateKeyInfo = true;
                            setState(() {});
                          },
                        ).paddingOnly(bottom: 10),
                        ExpandedButton(
                          label: "Cancel",
                          onPress: Get.back,
                        ),
                      ],
                    ),

                  if (showPrivateKeyInfo && !showKey)
                    InfoShowPrivateKey(
                      onConfirm: () {
                        showKey = true;
                        setState(() {});
                      },
                    ),

                  if (showKey)

                  const ShowPrivateKey(),
                ],
              ).paddingSymmetric(horizontal: 10),
            ),
          )
        ],
      ).paddingAll(20),
    );
  }
}
