import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:fin_tech/Provider/WalletProviders/wallet_provider.dart';
import 'package:fin_tech/Utils/extension.dart';

import 'show_all_wallets.dart';

class AccountsAndActions extends StatelessWidget {
  const AccountsAndActions({super.key});

  @override
  Widget build(BuildContext context) {
    final  screenHeight=Get.height*.015;
    return Consumer<WalletProvider>(
      builder: (BuildContext context, value, Widget? child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value.evmWallet?.accountTitle?.toUpperCase() ?? "Ethereum",
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
            ).paddingOnly(right: screenHeight),
             Icon(Icons.arrow_drop_down, color: Colors.black,size: screenHeight*2,)
          ],
        ).paddingOnly(top: screenHeight*2).onTap(
          () {
            showAccountDetailBottomSheet().then((value){

            });
          },
        );
      },
    );
  }
}
