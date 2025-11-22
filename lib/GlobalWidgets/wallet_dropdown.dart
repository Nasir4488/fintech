import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fin_tech/Plugins/Dropdown/dropdown_textfield.dart';
import 'package:fin_tech/Provider/providers.dart';

class WalletDropDown extends StatefulWidget {
  final VoidCallback? onChange;

  const WalletDropDown({this.onChange, super.key});

  @override
  State<WalletDropDown> createState() => _WalletDropDownState();
}

class _WalletDropDownState extends State<WalletDropDown> {
  @override
  Widget build(BuildContext context) {
    return DropDownTextField(
      dropDownList: walletProvider.walletsList
          .map(
            (e) => DropDownValueModel(
              name: e.accountTitle ?? "",
              value: e,
            ),
          )
          .toList(),
      onChanged: (v) async {
        await walletProvider.changeAccount(v.value.privateKey).then(
          (_) {
            if (widget.onChange != null) widget.onChange!();
          },
        );
      },
      initialValue: DropDownValueModel(
        name: walletProvider.evmWallet?.accountTitle ?? "",
        value: walletProvider.evmWallet,
      ).name,
      textStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
      clearIconProperty: IconProperty(icon: Icons.arrow_drop_down, color: Colors.black),
      // clearOption: false,
      textFieldDecoration: InputDecoration(
        focusedBorder: border,
        enabledBorder: border,
      ),
    ).paddingSymmetric(horizontal: Get.width * .2);
  }

  final border = InputBorder.none;
}
