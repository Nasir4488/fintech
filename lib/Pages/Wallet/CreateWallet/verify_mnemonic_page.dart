import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:fin_tech/Services/storage_services.dart';
import '/GlobalWidgets/expended_button.dart';
import '/GlobalWidgets/progress_bar_widget.dart';
import '/Pages/Wallet/greeting_page.dart';
import '/Provider/providers.dart';
import '/Provider/theme_provider.dart';
import 'package:web3dart/web3dart.dart';

class VerifyMnemonicPage extends StatefulWidget {
  final List<String> mnemonicList;

  const VerifyMnemonicPage(this.mnemonicList, {super.key});

  @override
  State<VerifyMnemonicPage> createState() => _VerifyMnemonicPageState();
}

class _VerifyMnemonicPageState extends State<VerifyMnemonicPage> {
  Future<void> _setData() async {
    if (walletProvider.mnemonic == null) return;
    String privateKey = await walletProvider.getPrivateKey(walletProvider.mnemonic ?? "");

    EthereumAddress walletAddress = await walletProvider.getPublicKey(privateKey);

    walletProvider.saveWallets(
        walletAddress: walletAddress.hex, privateKey: privateKey, status: "Master Account");
    AppStorage.box.write(AppStorage.MASTER_SEEDS, walletProvider.mnemonic);
    phraseToShow = [];
    newList = [];
    Get.off(() => const GreetingPage());
  }

  final TextEditingController controller = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<PhraseModel> newList = <PhraseModel>[];

  List<String> phraseToShow = <String>[];
  bool? soundsGood;

  @override
  void initState() {
    phraseToShow = <String>[];
    for (var element in widget.mnemonicList) {
      newList.add(PhraseModel(element));
    }
    newList.shuffle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight=Get.height*.015;

    return Scaffold(
      bottomNavigationBar: soundsGood == true
          ? ExpandedButton(
              label: "Confirm".tr,
              filled: true,
              onPress: () {
                _setData();
              },
            ).paddingSymmetric(horizontal: screenHeight*2, vertical: screenHeight*2)
          : null,
      body: Stack(
        children: [
          // Positioned.fill(child: Image.asset(ImageSrc.CREATE_WALLET_BG, fit: BoxFit.fill)),
          Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                   SizedBox(height: screenHeight*4),
                  const ProgressBarWidgetWalletCreating(2, fill2: true)
                      .paddingSymmetric(horizontal: screenHeight*2),
                  Text(
                    "CONFIRM SECRETE RECOVERY PHRASE".tr,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: primaryColor,

                        ),
                  ).paddingOnly(bottom: screenHeight),
                  Text(
                    "Select each word in the order it was presented to you.".tr,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w400),
                  ).paddingOnly(bottom: screenHeight).paddingSymmetric(horizontal: Get.width * .2),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: List.generate(
                            6,
                            (index) => GestureDetector(
                              onTap: () {
                                addToList(index, newList[index].text);
                              },
                              child: Container(
                                width: Get.width*.4,
                                decoration: BoxDecoration(
                                    gradient: newList[index].isSelected ? linearGradient : null,
                                    borderRadius: BorderRadius.circular(
                                      50,
                                    ),
                                    border: gradientBoxBorder),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      newList[index].text.toLowerCase(),
                                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                          color: newList[index].isSelected ? Colors.black : null),
                                    ).paddingSymmetric(horizontal: screenHeight, vertical:screenHeight),
                                  ],
                                ),
                              ).paddingOnly(top: screenHeight),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: List.generate(
                            12,
                            (index) => index >= 6
                                ? GestureDetector(
                                    onTap: () {
                                      addToList(index, newList[index].text);
                                    },
                                    child: Container(
                                      width: Get.width*.4,

                                      decoration: BoxDecoration(
                                          gradient:
                                              newList[index].isSelected ? linearGradient : null,
                                          borderRadius: BorderRadius.circular(
                                            50,
                                          ),
                                          border: gradientBoxBorder),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            newList[index].text.toLowerCase(),
                                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                                color: newList[index].isSelected
                                                    ? Colors.black
                                                    : null),
                                          ).paddingSymmetric(horizontal: screenHeight, vertical: screenHeight),
                                        ],
                                      ),
                                    ).paddingOnly(top: screenHeight),
                                  )
                                : const SizedBox(),
                          ),
                        ),
                      ),
                    ],
                  ).paddingOnly(bottom: screenHeight*2),
                  // SizedBox(
                  //   height: 290,
                  //   child: Center(
                  //     child: Wrap(
                  //       direction: Axis.vertical,
                  //       children: List.generate(
                  //         newList.length,
                  //         (index) => GestureDetector(
                  //           onTap: () {
                  //             addToList(index, newList[index].text);
                  //           },
                  //           child: Container(
                  //             width: 140,
                  //             decoration: BoxDecoration(
                  //                 gradient: newList[index].isSelected ? linearGradient : null,
                  //                 borderRadius: BorderRadius.circular(
                  //                   50,
                  //                 ),
                  //                 border: gradientBoxBorder),
                  //             child: Row(
                  //               mainAxisAlignment: MainAxisAlignment.center,
                  //               mainAxisSize: MainAxisSize.min,
                  //               children: [
                  //                 Text(
                  //                   newList[index].text.toLowerCase(),
                  //                   style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  //                       color: newList[index].isSelected ? Colors.black : null),
                  //                 ).paddingSymmetric(horizontal: 7, vertical: 7),
                  //               ],
                  //             ),
                  //           )
                  //               .paddingSymmetric(horizontal: 10, vertical: 5)
                  //               .animate()
                  //               .fadeIn(duration: const Duration(seconds: 2)),
                  //         ),
                  //       ),
                  //     ).paddingOnly(bottom: 20),
                  //   ),
                  // ),
                  if (soundsGood != null && soundsGood == false)
                    Text(
                      "Wrong Pattern".tr,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: Colors.red, fontWeight: FontWeight.bold),
                    ).animate().fadeIn(duration: const Duration(seconds: 2)),
                  if (soundsGood != null && soundsGood == false)
                    Text(
                      "Please go back to confirm and write down securely".tr,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    )
                        .animate()
                        .fadeIn(duration: const Duration(seconds: 2))
                        .paddingOnly(bottom: screenHeight),

                  // Row(
                  //   children: [
                  //     Expanded(
                  //         child: Column(
                  //       children: List.generate(
                  //         phraseToShow.length,
                  //         (index) => Container(
                  //           width: 140,
                  //
                  //           decoration: BoxDecoration(
                  //               borderRadius: BorderRadius.circular(
                  //                 50,
                  //               ),
                  //               border: gradientBoxBorder),
                  //           child: Text(
                  //             "${index + 1} . ${phraseToShow[index].capitalizeFirst}",
                  //             style: Theme.of(context).textTheme.titleSmall,
                  //           ).paddingSymmetric(horizontal: 7, vertical: 7),
                  //         )
                  //             .paddingSymmetric(horizontal: 10, vertical: 5)
                  //             .animate()
                  //             .fadeIn(duration: const Duration(seconds: 2)),
                  //       ),
                  //     )),
                  //     Expanded(
                  //         child: Column(
                  //       children: List.generate(
                  //         12,
                  //         (index) => index >= 6
                  //             ? Container(
                  //           width: 140,
                  //
                  //                 decoration: BoxDecoration(
                  //                     borderRadius: BorderRadius.circular(
                  //                       50,
                  //                     ),
                  //                     border: gradientBoxBorder),
                  //                 child: Text(
                  //                   "${index + 1} . ${phraseToShow[index].capitalizeFirst}",
                  //                   style: Theme.of(context).textTheme.titleSmall,
                  //                 ).paddingSymmetric(horizontal: 7, vertical: 7),
                  //               )
                  //                 .paddingSymmetric(horizontal: 10, vertical: 5)
                  //                 .animate()
                  //                 .fadeIn(duration: const Duration(seconds: 2))
                  //             : const SizedBox(),
                  //       ),
                  //     )),
                  //   ],
                  // ),

                  SizedBox(
                    height: Get.height*.5,
                    width: Get.width,
                    child: Wrap(
                      direction: Axis.vertical,
                      children: List.generate(
                        phraseToShow.length,
                        (index) => Container(
                          width: Get.width * .35,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                50,
                              ),
                              border: gradientBoxBorder),
                          child: Text(
                            "${index + 1} . ${phraseToShow[index].capitalizeFirst}",
                            style: Theme.of(context).textTheme.titleSmall,
                          ).paddingSymmetric(horizontal: screenHeight, vertical: screenHeight),
                        )
                            .paddingSymmetric(horizontal: screenHeight, vertical: screenHeight/2)
                            .animate()
                            .fadeIn(duration: const Duration(seconds: 2)),
                      ),
                    ).paddingOnly(bottom: screenHeight*2),
                  ).paddingSymmetric(horizontal: screenHeight*4),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void addToList(index, String text) {
    if (newList.length != phraseToShow.length) {
      if (newList[index].isSelected == false) {
        newList[index].isSelected = true;

        phraseToShow.add(newList[index].text);
      } else {
        newList.firstWhereOrNull((element) => element.text == text)?.isSelected = false;

        phraseToShow.removeWhere((element) => element == text);
      }
    }
    if (phraseToShow.join("") == widget.mnemonicList.join("")) {
      soundsGood = true;
    } else {
      if (newList.length == phraseToShow.length) {
        soundsGood = false;
      }
    }

    setState(() {});
  }
}

class PhraseModel {
  String text;
  bool isSelected;

  PhraseModel(this.text, {this.isSelected = false});
}
