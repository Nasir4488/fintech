import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:fin_tech/Pages/landing_page.dart';
import 'package:fin_tech/Utils/extension.dart';
import 'package:fin_tech/assets.dart';
import '/GlobalWidgets/expended_button.dart';
import '/GlobalWidgets/input_field.dart';
import '/Provider/providers.dart';
import '/Provider/theme_provider.dart';
import '/Services/storage_services.dart';
import '/Utils/utils.dart';
import '/splash_page.dart';

class GetAppPasswordPage extends StatefulWidget {
  final bool formRoot;

  const GetAppPasswordPage({this.formRoot = false, super.key});

  @override
  State<GetAppPasswordPage> createState() => _GetAppPasswordPageState();
}

class _GetAppPasswordPageState extends State<GetAppPasswordPage> with WidgetsBindingObserver {
  final LocalAuthentication auth = LocalAuthentication();

  @override
  void initState() {
    getDeviceAuth();
    if (widget.formRoot) {
      logger.e(widget.formRoot);
    }
    super.initState();
  }

  Future<void> getDeviceAuth() async {
    enableFingerId = AppStorage.box.read(AppStorage.ENABLE_BIO) ?? false;
    if (!enableFingerId) return;

    Future.delayed(
      Duration.zero,
      () {
        setState(() {});
      },
    );

    try {
      await auth.stopAuthentication();

      final res = await auth.authenticate(
        localizedReason: 'authenticate'.tr,
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
      if (res) {
        Get.back(result: res);
        if (widget.formRoot) Get.offAll(() => const LandingPage());

        authProviders.saveLastLoginDateTime();
      }
    } on PlatformException catch (e) {
      logger.e(e);
    }
  }

  Future<void> eraseWallet() async {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Confirm Erase Wallet'.tr),
          content: Column(
            children: <Widget>[
              Text('Are you sure you want to erase your wallet?'.tr),
              const SizedBox(height: 10),
              Text(
                'This action is not recoverable. You will permanently lose all wallet data.'.tr,
                style: const TextStyle(
                  color: CupertinoColors.systemRed,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'You can recover your wallets if you have Private Keys'.tr,
                style: const TextStyle(
                  color: CupertinoColors.systemRed,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'.tr),
            ),
            CupertinoDialogAction(
              onPressed: () async {
                await authProviders.removeDataFromLocal().then((value) {
                  if (value) {
                    Get.offAll(const SplashPage());
                  }
                });
              },
              isDestructiveAction: true,
              child: Text('Erase Wallet'.tr),
            ),
          ],
        );
      },
    );
  }

  final passwordCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool enableFingerId = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Positioned.fill(child: Image.asset(ImageSrc.CREATE_WALLET_BG, fit: BoxFit.fill)),
          PopScope(
            canPop: false,
            child: Form(
              key: formKey,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(ImageSrc.DRAGON, scale: 2.5).paddingOnly(top: Get.height * .1),
                  Text(
                    "welcome".tr,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                  ).paddingOnly(bottom: Get.height * .07),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Enter Your Password".tr,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.w400),
                    ).paddingOnly(bottom: 5),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: AppFormField(
                          suffix: enableFingerId
                              ? const Icon(Icons.fingerprint_rounded, size: 20).onTap(() {
                                  getDeviceAuth();
                                })
                              : null,
                          hintText: "Password".tr,
                          controller: passwordCtrl,
                          maxLine: 1,
                          obscureText: true,
                          validator: (String? v) {
                            if (v!.isEmpty) {
                              return "Required".tr;
                            } else if (v != AppStorage.box.read(AppStorage.WALLET_PASSWORD)) {
                              return "Wrong Password".tr;
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ).paddingOnly(bottom: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Unlock with Finger Print".tr,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w400,
                            ),
                      ),
                      Transform.scale(
                        scale: .7,
                        child: Switch(
                          inactiveTrackColor: Colors.grey.withOpacity(.5),
                          inactiveThumbColor: primaryColor,
                          activeTrackColor: Colors.grey.withOpacity(.5),
                          activeColor: primaryColor,
                          value: enableFingerId,
                          onChanged: (bool value) async {
                            final list = await auth.getAvailableBiometrics();
                            if (list.isEmpty) {
                              showSnack("Not Available".tr, isError: true);
                              return;
                            }
                            final res = await auth.authenticate(
                              localizedReason: 'Please Authenticate'.tr,
                              options: const AuthenticationOptions(
                                biometricOnly: true,
                              ),
                            );
                            if (res) {
                              await AppStorage.box.write(AppStorage.ENABLE_BIO, value);
                              enableFingerId = value;
                              setState(() {});
                            }
                          },
                        ),
                      ),
                    ],
                  ).paddingOnly(bottom: 20),
                  ExpandedButton(
                    filled: true,
                    onPress: () {
                      if (!formKey.currentState!.validate()) return;
                      authProviders.saveLastLoginDateTime();
                      Get.back(result: true);
                    },
                    label: "UNLOCK".tr,
                  ),
                  const Expanded(child: SizedBox()),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "resetPasswordInfo".tr,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(fontWeight: FontWeight.w400),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ).paddingOnly(bottom: 10),
                  TextButton(
                      onPressed: () {
                        eraseWallet();
                      },
                      child: Text(
                        "Reset Your Wallet".tr,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: textColor,
                            decoration: TextDecoration.underline,
                            decorationColor: textColor,
                            decorationThickness: 2),
                      )),
                ],
              ).paddingSymmetric(horizontal: 20),
            ),
          ),
        ],
      ),
    );
  }
}

class EnableFingerButton extends StatelessWidget {
  final VoidCallback? onTap;

  const EnableFingerButton(this.onTap, {super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: onTap,
        icon: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(10)),
            child: Icon(Icons.fingerprint_rounded,
                color: themeProvider.isDarkMode ? Colors.white : Colors.black, size: 30)));
  }
}
