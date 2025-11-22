// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fin_tech/GlobalWidgets/loading.dart';
import 'package:fin_tech/assets.dart';
import 'package:fin_tech/utils/extension.dart';
import '/Provider/theme_provider.dart';

Logger logger = Logger();

const String appName = "VRC NETWORK";
const String playStoreAddress =
    "https://play.google.com/store/apps/details?id=com.virtual.tech.v20_network";
const String appDeepLink = "https://v20network.page.link/tobR";
const String vrcUrl = "https://vrcscan.com/";
const String vrcCoin = "https://vrccoin.com/";
const String vrcNetworkTermsAndConditions = "https://v20.network/privacy-policy";
const String hackenReport =
    "https://wp.hacken.io/wp-content/uploads/2023/10/Virtual-Tech-PT-WEBAPI-Report-Remediation-1-1.pdf";

const String appStoreIOSAddress = "";

final showShimmer = Container(
  height: 15,
  width: 50,
  decoration: BoxDecoration(
    gradient: linearGradient,
    borderRadius: BorderRadius.circular(5),
  ),
).applyShimmer(baseColor: Colors.grey.withOpacity(.4));

class AppCurrency {
  static const String ETH = "ETH";
  static const String USD = "\$";
}

void showSnack(String msg, {bool isError = false}) {
  Get.snackbar(
    "",
    "",
    backgroundColor: isError ? Colors.redAccent : Colors.greenAccent,
    titleText: Text(
      isError ? "Error" : "Info",
      style: Theme.of(Get.context!).textTheme.titleMedium?.copyWith(
            color: Colors.black,
          ),
    ),
    messageText: Text(
      msg,
      style: Theme.of(Get.context!).textTheme.titleSmall?.copyWith(
            color: Colors.black,
          ),
    ),
    icon: Icon(
      isError ? Icons.cancel_outlined : Icons.info_outline,
      color: Colors.black,
      size: 30,
    ),
    margin: EdgeInsets.zero,
    snackStyle: SnackStyle.GROUNDED,
  );
}

void showToast(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      textColor: Colors.white,
      fontSize: 16.0);
}

String formatBalance(String? input, {int decimalPlaces = 6}) {
  if (input == null) return "";

  String numberStr = input.toString();
  int decimalIndex = numberStr.indexOf('.');
  if (decimalIndex == -1 || numberStr.length <= decimalIndex + decimalPlaces) {
    return numberStr;
  }
  return numberStr.substring(0, decimalIndex + decimalPlaces + 1);
}

String formatWalletAddress(String address) {
  if (address.length <= (7 + 7)) {
    return address;
  }
  return '${address.substring(0, 7)}...${address.substring(address.length - 7)}';
}

Future<void> launchWeb(String url) async {
  if (!await launchUrl(Uri.parse(url))) {
    showSnack('Could not launch $url', isError: true);
  }
}

mixin AppUtils {
  void showProgress() async {
    await 0.delay();
    Get.dialog(
        Center(
          child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(Get.context!).cardColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(blurRadius: 10, spreadRadius: 1, color: primaryColor.withOpacity(.5)),
                  ]),
              child: Image.asset(
                scale: 30,
                ImageSrc.LOADER,
              ).paddingAll(5)),
        ),
        // },
        barrierDismissible: false);
  }

  void stopProgress() {
    if (Get.isDialogOpen!) Get.back();
  }

  Widget showTextShimmer({double? width, double? height, Color? baseColor}) {
    return Container(
      height: height ?? 20,
      width: width ?? 100,
      decoration: BoxDecoration(
        gradient: linearGradient,
        borderRadius: BorderRadius.circular(5),
      ),
    ).applyShimmer(baseColor: baseColor ?? Colors.black.withOpacity(.4));
  }
}

class DualCircularProgressIndicator extends StatefulWidget {
  const DualCircularProgressIndicator({super.key});

  @override
  State<StatefulWidget> createState() => _DualCircularProgressIndicatorState();
}

class _DualCircularProgressIndicatorState extends State<DualCircularProgressIndicator> {
  // late AnimationController controllerOuter;
  // late AnimationController controllerInner;

  @override
  void initState() {
    super.initState();
    // controllerOuter = AnimationController(
    //   vsync: this,
    //   duration: const Duration(seconds: 2),
    // )..repeat();
    // controllerInner = AnimationController(
    //   vsync: this,
    //   duration: const Duration(seconds: 2),
    // )..repeat();
  }

  @override
  void dispose() {
    // controllerOuter.dispose();
    // controllerInner.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: Get.height * .1, width: Get.height * .1, child: const DataLoading());
    //   Stack(
    //   alignment: Alignment.center,
    //   children: <Widget>[
    //     AnimatedBuilder(
    //       animation: controllerInner,
    //       builder: (context, child) {
    //         return Transform.rotate(
    //           angle: -(controllerInner.value * 2.0 * math.pi),
    //           child: SizedBox(
    //             width: 50,
    //             height: 50,
    //             child: CircularProgressIndicator(
    //               strokeWidth: 3,
    //               valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
    //             ),
    //           ),
    //         );
    //       },
    //     ),
    //     AnimatedBuilder(
    //       animation: controllerOuter,
    //       builder: (context, child) {
    //         return Transform.rotate(
    //           angle: controllerOuter.value * 2.0 * math.pi,
    //           child: const SizedBox(
    //             width: 35,
    //             height: 35,
    //             child: CircularProgressIndicator(
    //               strokeWidth: 3,
    //               valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
    //             ),
    //           ),
    //         );
    //       },
    //     ),
    //   ],
    // );
  }
}
