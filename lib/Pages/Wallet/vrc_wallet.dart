import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/Pages/Wallet/IntroPage/wallet_intro_page.dart';
import '/Pages/Wallet/WalletSetupPages/wallet_setup_page.dart';
import '/Pages/Wallet/ShowWallet/wallet_page.dart';
import '/Provider/WalletProviders/wallet_provider.dart';
import '/Services/storage_services.dart';


class WalletOptions extends StatelessWidget {
  const WalletOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletProvider>(
      builder: (BuildContext context, value, Widget? child) {

        if(!(AppStorage.box.read(AppStorage.WALLET_INTRO)??false)){
          return  const WalletIntroPage();
        }

        else if (AppStorage.box.hasData(AppStorage.WALLETS_DATA) == false) {
          return const WalletSetupPage();
        }
        return value.walletsList.isEmpty ? const WalletSetupPage() : const WalletPage();
      },
    );
  }
}
