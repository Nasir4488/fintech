import 'package:finetecha/screen/Payments/paymentBuCard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:walletconnect_dart/walletconnect_dart.dart';
// import 'package:url_launcher/url_launcher.dart';

class ChoosingPaymentMethod extends StatefulWidget {
  const ChoosingPaymentMethod({Key? key}) : super(key: key);

  @override
  State<ChoosingPaymentMethod> createState() => _ChoosingPaymentMethodState();
}

class _ChoosingPaymentMethodState extends State<ChoosingPaymentMethod> {
  String? _accountAddress; // Variable to store the account address

  // Initialize WalletConnect
  // var connector = WalletConnect(
  //   bridge: 'https://bridge.walletconnect.org',
  //   clientMeta: const PeerMeta(
  //     name: 'Flutter Demo',
  //     description: 'An app for connecting to MetaMask',
  //     url: 'https://walletconnect.org',
  //     icons: [
  //       'https://files.gitbook.com/v0/b/gitbook-legacy-files/o/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
  //     ],
  //   ),
  // );
  // Connect to MetaMask and retrieve the account address
  // Future<void> connectToMetaMask(BuildContext context) async {
  //   if (!connector.connected) {
  //     try {
  //       var session = await connector.createSession(onDisplayUri: (uri) async {
  //         await launchUrl(Uri.parse(uri), mode: LaunchMode.externalApplication);
  //       });
  //
  //       setState(() {
  //         _accountAddress = session.accounts[0];
  //       });
  //       print("Connected to MetaMask. Account: $_accountAddress");
  //     } catch (exp) {
  //       print("Connection failed: $exp");
  //     }
  //   } else {
  //     print("Already connected");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Get.to(Payment()),
              child: const Text("Pay Through Card"),
            ),
            ElevatedButton(
              onPressed: (){},
              // onPressed: () => connectToMetaMask(context),
              child: const Text("Connect to MetaMask"),
            ),
            if (_accountAddress != null) // Display account if connected
              Text("Connected Account: $_accountAddress"),
          ],
        ),
      ),
    );
  }
}
