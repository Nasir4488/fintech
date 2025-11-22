import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fin_tech/Services/storage_services.dart';
import 'package:fin_tech/assets.dart';
import '/GlobalWidgets/expended_button.dart';
import '/GlobalWidgets/input_field.dart';
import '/Pages/Wallet/ImportWallets/scan_qr_import_wallets_page.dart';
import '/Provider/providers.dart';
import '/Provider/theme_provider.dart';
import '/Utils/extension.dart';
import '/Utils/utils.dart';

class ImportWalletWithPrivateKeyPage extends StatefulWidget {
  final String? privateKey;
  final bool hideQr;

  const ImportWalletWithPrivateKeyPage({this.privateKey, this.hideQr = false, super.key});

  @override
  State<ImportWalletWithPrivateKeyPage> createState() => _ImportWalletWithPrivateKeyPageState();
}

class _ImportWalletWithPrivateKeyPageState extends State<ImportWalletWithPrivateKeyPage>
    with SingleTickerProviderStateMixin {
  final privateKeyCtrl = TextEditingController();
  final secretPhraseCtrl = TextEditingController();

  late TabController tabController;

  bool obscureText = true;
  final formKey = GlobalKey<FormState>();
  bool showPrivateKey = true;
  bool hideButton = false;

  @override
  void initState() {
    tabController =
        TabController(length: AppStorage.box.hasData(AppStorage.MASTER_SEEDS) ? 1 : 2, vsync: this);
    if (widget.privateKey != null) {
      privateKeyCtrl.text = widget.privateKey ?? "";
    }
    super.initState();
  }

  Future<void> importViaMnemonicPhrases() async {
    if (privateKeyCtrl.text.isEmpty && secretPhraseCtrl.text.isEmpty) {
      showSnack("Please Enter Private Key/ Mnemonic Phrases");
      return;
    }

    /// Import Via Private Key
    if (privateKeyCtrl.text.isNotEmpty) {
      bool res =  walletProvider.validatePrivateKey(privateKeyCtrl.text);
      if (!res) {
        showSnack("Invalid Private Key", isError: true);
        return;
      }

      await walletProvider.importWallet(privateKeyCtrl.text).then((value) {
        if (!value) return;
        privateKeyCtrl.clear();
        Get.back();
      });
      return;
    }

    /// Import via Mnemonic

    bool hasMatch =
        RegExp(r'(^\s+|\s{2,}|\s+$)').hasMatch(secretPhraseCtrl.text.trimLeft().trimRight());

    if (hasMatch) {
      showSnack("Extra spaces not Allowed", isError: true);
      return;
    } else if (secretPhraseCtrl.text.split(" ").length != 12) {
      showSnack("Invalid Phrases", isError: true);
      return;
    }
    final privateKey = await walletProvider.getPrivateKey(secretPhraseCtrl.text);

    await AppStorage.box.write(AppStorage.MASTER_SEEDS, secretPhraseCtrl.text);
    await walletProvider.importWallet(privateKey).then((value) {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
          key: formKey,
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    // gradient: linearGradient,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "IMPORT ACCOUNT",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                      ).paddingOnly(top: 20, bottom: 10),
                      Text(
                        "Imported accounts are viewable in your wallet "
                        "but are not recoverable with your Secret Recover Phrase",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                      ).paddingOnly(bottom: 10)
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: Get.height * .2),
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "PRIVATE KEY",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
                    ).paddingOnly(top: 20,bottom: 10),
                    Row(
                      children: [
                        Expanded(
                          child: AppFormField(
                            obscureText: showPrivateKey,
                            maxLine: 1,
                            controller: privateKeyCtrl,
                            validator: (String? v) {
                              if (v!.isEmpty) return "Required".tr;

                              return null;
                            },
                            hintText: "Enter your Private Key".tr,
                          ),
                        ),
                        if (!widget.hideQr)
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: primaryColor),
                                borderRadius: BorderRadius.circular(10)),
                            child: Image.asset(
                              ImageSrc.QR_CODE
                             ,scale: 1.8,
                            ).paddingAll(5).onTap(
                              () async {
                                privateKeyCtrl.text = await Get.to(() => const ScanQrImportWalletPage());
                              },
                            ),
                          ).paddingOnly(left: 10)
                      ],
                    ).paddingSymmetric(horizontal: 20).paddingOnly(bottom: 30),



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
                        : ExpandedButton(
                        filled: true,
                        label: "Import Account",
                        icon: const Icon(Icons.file_download_outlined, color: Colors.black),
                        onPress: () {
                          hideButton = true;
                          setState(() {});
                          importViaMnemonicPhrases().then((value) {
                            hideButton = false;
                            setState(() {});
                          });
                        }).paddingAll(20),
                  ],
                ).paddingAll(20),
              ),
            ],
          )),
    );
  }
}
