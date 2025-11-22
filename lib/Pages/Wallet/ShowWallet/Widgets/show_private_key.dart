import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:fin_tech/GlobalWidgets/input_field.dart';
import 'package:fin_tech/GlobalWidgets/toggle_switch.dart';
import 'package:fin_tech/Services/storage_services.dart';
import 'package:fin_tech/assets.dart';
import '/GlobalWidgets/expended_button.dart';
import '/Provider/providers.dart';
import '/Provider/theme_provider.dart';

class ShowPrivateKey extends StatefulWidget {
  const ShowPrivateKey({super.key});

  @override
  State<ShowPrivateKey> createState() => _ShowPrivateKeyState();
}

class _ShowPrivateKeyState extends State<ShowPrivateKey> with SingleTickerProviderStateMixin {
  late TabController tabCtrl;

  final privateKey = walletProvider.evmWallet?.privateKey;
  final secretePhrases = AppStorage.box.read(AppStorage.MASTER_SEEDS);

  @override
  void initState() {
    authProviders.preventScreenshotOn();

    tabCtrl = TabController(length: 2, vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    authProviders.preventScreenshotOff();
    super.dispose();
  }

  String? showValue = walletProvider.evmWallet?.privateKey;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ToggleSwitch(
          values: const ["Private Key", "Secrete Phrases"],
          onChange: (onChange) {
            if (onChange == 'Private Key') {
              showValue = walletProvider.evmWallet?.privateKey ?? "";
            } else {
              showValue = AppStorage.box.read(AppStorage.MASTER_SEEDS);
            }
            setState(() {});
          },
        ).paddingOnly(top: 20, bottom: 10),
        AppFormField(
          readOnly: true,
          controller: TextEditingController(text: showValue),
        ).paddingOnly(bottom: 20),
        Container(
          height: Get.height * .2,
          decoration: BoxDecoration(
            border: Border.all(color: primaryColor),
            borderRadius: BorderRadius.circular(10),
          ),
          child: QrImageView(
            data: showValue ?? "",
            backgroundColor: textColor,
          ).paddingAll(10),
        ),
        Row(
          children: [
            Expanded(
              child: ExpandedButton(
                onPress: () {
                },
                label: "Done",
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ExpandedButton(
                onPress: () {
                  walletProvider.copyToClipBoard(showValue ?? "");
                },
                filled: true,
                label: "Copy to Clipboard",
                icon: Image.asset(
                  ImageSrc.COPY,
                  scale: 2,
                ),
              ),
            ),
          ],
        ).paddingOnly(bottom: 20, top: 20),
      ],
    );
  }
}

class RadioModel {
  String title;
  String value;

  RadioModel(this.title, this.value);
}
