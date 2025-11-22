import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/Pages/Wallet/Transaction/amount_selection_buttons.dart';
import '/Pages/get_app_password_page.dart';
import '/GlobalWidgets/expended_button.dart';
import '/Pages/Wallet/ImportWallets/scan_qr_import_wallets_page.dart';
import '/Provider/theme_provider.dart';
import '/GlobalWidgets/input_field.dart';
import '/Provider/providers.dart';
import '/Utils/extension.dart';
import '/Utils/utils.dart';
import '/assets.dart';

class SendFundsPage extends StatefulWidget {
  final String? address;

  const SendFundsPage({this.address, super.key});

  @override
  State<SendFundsPage> createState() => _SendFundsPageState();
}

class _SendFundsPageState extends State<SendFundsPage> {
  final TextEditingController publicAddressCrl = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    publicAddressCrl.clear();
    if (widget.address != null) {
      publicAddressCrl.text = widget.address ?? "";
    }
    super.initState();
  }

  @override
  void dispose() {
    publicAddressCrl.clear();
    super.dispose();
  }

  int choice = -1;

  @override
  Widget build(BuildContext context) {
    final screenHeight = Get.height * 0.015;
    return Scaffold(
      appBar: AppBar(
          title: Text(
        "SEND ${AppCurrency.ETH}",
        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: textColor),
      )),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Balance",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
              ).paddingOnly(top: Get.height * .04),
              Text(
                "${formatBalance(walletProvider.evmWallet?.lastBalance)} ${AppCurrency.ETH}",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
              ),
              Text(
                "Receiver Address",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w700,
                    ),
              ).paddingOnly(top: screenHeight * 2, bottom: screenHeight / 2),
              AppFormField(
                maxLine: 1,
                validator: (String? v) {
                  if (v!.isEmpty) return "Required".tr;

                  return null;
                },
                hintText: "Receiver Address".tr,
                controller: publicAddressCrl,
                suffix: Image.asset(
                  ImageSrc.QR_CODE,
                  scale: 3,
                  color: primaryColor,
                ).onTap(() async {
                  String? value = await Get.to(() => const ScanQrImportWalletPage());
                  if (walletProvider.validatePublicAddress(value)) {
                    publicAddressCrl.text = value ?? "";

                    return;
                  }
                  showSnack("Invalid Public/Wallet address".tr, isError: true);
                }),
              ).paddingOnly(bottom: screenHeight),
              Text(
                "Amount",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w700,
                    ),
              ).paddingOnly(bottom: screenHeight / 2),
              AppFormField(
                validator: (String? v) {
                  if (v!.isEmpty) {
                    return "Required".tr;
                  } else if (v == '0') {
                    return "Invalid Amount".tr;
                  } else if (double.parse(v) >
                      double.parse(walletProvider.evmWallet?.lastBalance ?? "0")) {
                    return "Insufficient Balance".tr;
                  } else if (double.parse(v) >
                      double.parse(walletProvider.evmWallet?.lastBalance ?? "0")) {
                    return "Insufficient Balance".tr;
                  }
                  return null;
                },
                controller: walletProvider.amountCtrl,
                hintText: "0.0",
                inputType: TextInputType.number,
              ).paddingOnly(bottom: screenHeight * 2),
              const AmountSelectionButtons().paddingOnly(bottom: screenHeight * 3),
              ExpandedButton(
                      filled: true,
                      onPress: () async {
                        bool res = walletProvider.validatePublicAddress(publicAddressCrl.text);
                        if (res != true) {
                          showSnack("Inlaid Address".tr, isError: true);
                          return;
                        }
                        bool? result = await Get.to(() => const GetAppPasswordPage());
                        if (result != true) return;
                        if (formKey.currentState!.validate()) {
                          Get.back();
                          walletProvider
                              .sendFunds(
                            receiverAddress: publicAddressCrl.text,
                          )
                              .then(
                            (value) {
                              walletProvider.getBalance();
                            },
                          );
                        }
                      },
                      label: "SEND ${AppCurrency.ETH}")
                  .paddingOnly(bottom: screenHeight),
              if (walletProvider.walletsList.length > 1)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Your Accounts ",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                  ).paddingOnly(bottom: screenHeight),
                ),
              if (walletProvider.walletsList.length > 1)
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: walletProvider.walletsList.length,
                  itemBuilder: (BuildContext context, int index) {
                    final data = walletProvider.walletsList[index];

                    if (data.isActive) return const SizedBox();
                    return Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(screenHeight)),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(data.color ?? 0000000),
                            ),
                            child: Image.asset(ImageSrc.GROOT_DP, scale: 4),
                          ).paddingOnly(right: screenHeight),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(data.accountTitle ?? "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(fontWeight: FontWeight.w400)),
                              Text(formatWalletAddress(data.walletAddress ?? ""),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(fontWeight: FontWeight.w400)),
                            ],
                          ),
                          const Expanded(child: SizedBox.shrink()),
                          Text(
                            formatBalance(data.lastBalance ?? ""),
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontWeight: FontWeight.w400, color: textColor)
                                .copyWith(color: index == choice ? Colors.black : null),
                          )
                        ],
                      ).paddingSymmetric(horizontal: screenHeight, vertical: screenHeight),
                    ).paddingOnly(bottom: screenHeight).onTap(
                      () {
                        publicAddressCrl.text = data.walletAddress ?? "";
                        choice = index;
                        setState(() {});
                      },
                    );
                  },
                ).paddingOnly(top: screenHeight).paddingOnly(bottom: screenHeight * 2),
            ],
          ).paddingOnly(
            top: screenHeight * 2,
            left: screenHeight,
            right: screenHeight,
          ),
        ).paddingSymmetric(
          horizontal: screenHeight,
        ),
      ),
    );
  }
}
