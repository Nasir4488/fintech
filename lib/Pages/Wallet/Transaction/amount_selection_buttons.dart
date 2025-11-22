import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fin_tech/Provider/providers.dart';
import 'package:fin_tech/Provider/theme_provider.dart';
import 'package:fin_tech/Utils/extension.dart';
import 'package:fin_tech/Utils/utils.dart';
import 'package:web3dart/web3dart.dart';

class AmountSelectionButtons extends StatefulWidget {
  const AmountSelectionButtons({super.key});

  @override
  State<AmountSelectionButtons> createState() => _AmountSelectionButtonsState();
}

class _AmountSelectionButtonsState extends State<AmountSelectionButtons> {
  final List<int> values = <int>[
    25,
    50,
    75,
    100,
  ];

  int selectedValue = 1;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: values
          .map(
            (e) => Container(
              constraints: BoxConstraints(
                minWidth: Get.width * .15,
                maxWidth: Get.width * .15,
              ),
              decoration: BoxDecoration(
                color: selectedValue != e ? Colors.white : Colors.black,

                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: primaryColor),
              ),
              child: Center(
                child: Text(
                  "$e %",
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: selectedValue == e ? Colors.white: Colors.black,
                        fontWeight: FontWeight.w800,
                      ),
                ).paddingAll(10),
              ),
            ).onTap(() {
              if (selectedValue != e) {
                selectedValue = e;
                calculateAmount(e);
              } else {
                selectedValue = 1;
                walletProvider.amountCtrl.clear();
              }
              setState(() {});

            }),
          )
          .toList(),
    );
  }

  Future<void> calculateAmount(int percentage) async {
    if (walletProvider.evmWallet?.lastBalance == "0") {
      return;
    }
    if (percentage == 25) {
      final lastBalance = double.parse(walletProvider.evmWallet?.lastBalance ?? "0.0");
      walletProvider.amountCtrl.text = (lastBalance * 0.25).toString();
      return;
    } else if (percentage == 50) {
      final lastBalance = double.parse(walletProvider.evmWallet?.lastBalance ?? "0.0");
      walletProvider.amountCtrl.text = (lastBalance * 0.50).toString();
      return;
    } else if (percentage == 75) {
      final lastBalance = double.parse(walletProvider.evmWallet?.lastBalance ?? "0.0");
      walletProvider.amountCtrl.text = (lastBalance * 0.75).toString();
      return;
    }

    final gasPrice = await contractProvider.web3client.getGasPrice();

    final lastBalance = await contractProvider.web3client
        .getBalance(EthereumAddress.fromHex((walletProvider.evmWallet?.walletAddress ?? "")));

    final eth = lastBalance.getInWei - gasPrice.getInWei;

    if (eth < 1e-6.toBigInt()) {
      showToast("Insufficient gas price");
      return;
    }

    walletProvider.amountCtrl.text =
        (lastBalance.getInWei - gasPrice.getInWei).toEther().toString();
  }
}
