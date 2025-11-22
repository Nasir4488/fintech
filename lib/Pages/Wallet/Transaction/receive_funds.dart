import 'dart:io';
import 'package:permission_handler/permission_handler.dart' ;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:fin_tech/GlobalWidgets/input_field.dart';
import 'package:fin_tech/Utils/utils.dart';
import 'package:fin_tech/assets.dart';
import '/GlobalWidgets/expended_button.dart';
import '/Provider/providers.dart';
import '/Provider/theme_provider.dart';

class ReceiveFundsPage extends StatefulWidget {
  const ReceiveFundsPage({super.key});

  @override
  State<ReceiveFundsPage> createState() => _ReceiveFundsPageState();
}

class _ReceiveFundsPageState extends State<ReceiveFundsPage> {
  // ss.ScreenshotController screenshotController = ss.ScreenshotController();

  Future<String?> createFolder(String cow) async {
    try {
      final dir = Directory('${(Platform.isAndroid
          ? await getExternalStorageDirectory() //FOR ANDROID
          : await getApplicationSupportDirectory() //FOR IOS
      )!
          .path}/$cow');
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
      if ((await dir.exists())) {
        return dir.path;
      } else {
        dir.create();
        return dir.path;
      }
    } on Exception catch (e) {
     logger.e(e);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight=Get.height*0.015;
    return Scaffold(
      bottomNavigationBar: ExpandedButton(
        filled: true,
        label: "SHARE".tr,
        onPress: () {
          Share.share(walletProvider.evmWallet?.walletAddress ?? "");
        },
      ).paddingAll(screenHeight*2),
      appBar: AppBar(
        title: Text(
          "Receive ${AppCurrency.ETH}",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: textColor,
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
      QrImageView(
            data: walletProvider.evmWallet?.walletAddress ?? "",
            version: QrVersions.auto,
            size: Get.width * .5,
            backgroundColor: textColor,
          ).paddingAll(screenHeight).paddingOnly(bottom: screenHeight),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "ADDRESS",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
            ),
          ),
          AppFormField(
            onTap: () {
              walletProvider.copyToClipBoard(walletProvider.evmWallet?.walletAddress ?? "");
            },
            readOnly: true,
            maxLine: 1,
            controller: TextEditingController(
              text: walletProvider.evmWallet?.walletAddress ?? "",
            ),
            suffix: Image.asset(ImageSrc.COPY, color: primaryColor1),
          ).paddingOnly(bottom: screenHeight),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "NETWORK",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
            ),
          ),
          AppFormField(
            readOnly: true,
            maxLine: 1,
            controller: TextEditingController(
              text: "VRC CHAIN",
            ),
          ),
        ],
      ).paddingSymmetric(horizontal: screenHeight),
    );
  }
}
