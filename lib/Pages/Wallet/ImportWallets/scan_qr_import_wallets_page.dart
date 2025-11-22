import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:fin_tech/Provider/providers.dart';
import 'package:fin_tech/Provider/theme_provider.dart';
import 'package:fin_tech/Utils/utils.dart';

class ScanQrImportWalletPage extends StatefulWidget {
  const ScanQrImportWalletPage({super.key});

  @override
  State<StatefulWidget> createState() => _ScanQrImportWalletPageState();
}

class _ScanQrImportWalletPageState extends State<ScanQrImportWalletPage>
    with WidgetsBindingObserver {
  final MobileScannerController controller = MobileScannerController();
  StreamSubscription<Object?>? _subscription;

  @override
  void initState() {
    super.initState();
  }

  @override
  Future<void> dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_subscription?.cancel());
    _subscription = null;
    super.dispose();
    await controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Scan Qr Code",
          style: Theme
              .of(context)
              .textTheme
              .titleMedium
              ?.copyWith(
            color: textColor,
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          SizedBox(
            height: MediaQuery
                .of(context)
                .size
                .height,
            width: MediaQuery
                .of(context)
                .size
                .width,
            child: MobileScanner(
              fit: BoxFit.contain,
              onDetect: (scan) {
                final List<Barcode> barcodes = scan.barcodes;
                String? qrContent;
                for (final barcode in barcodes) {
                  qrContent = barcode.rawValue;
                  if (qrContent != null) {
                    if (qrContent.contains("ethereum:") == true) {
                      qrContent = qrContent.replaceFirst(RegExp(r'^.*?:'), '');
                    }
                    if (walletProvider.validatePrivateKey(qrContent)) {
                      Get.back(result: qrContent);
                    } else if (walletProvider.validatePublicAddress(qrContent)) {
                      Get.back(result: qrContent);
                    } else {
                      Get.back();
                      showSnack("Invalid Data", isError: true);
                    }
                    controller.stop();
                  }
                }
              },
              controller: controller,
              errorBuilder: (context, error, child) {
                return ScannerErrorWidget(error: error);
              },
            ),
          ),
          Positioned(
            bottom: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                        // color: Colors.teal,
                        color: Theme
                            .of(context)
                            .cardColor,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.grey.withOpacity(.5),
                                child: IconButton(
                                    onPressed: () async {
                                      controller.toggleTorch();

                                      setState(() {});
                                    },
                                    icon: const Icon(Icons.flash_on)),
                              ).paddingAll(20),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ScannerErrorWidget extends StatelessWidget {
  const ScannerErrorWidget({super.key, required this.error});

  final MobileScannerException error;

  @override
  Widget build(BuildContext context) {
    String errorMessage;

    switch (error.errorCode) {
      case MobileScannerErrorCode.controllerUninitialized:
        errorMessage = 'Controller not ready.';
      case MobileScannerErrorCode.permissionDenied:
        errorMessage = 'Permission denied';
      case MobileScannerErrorCode.unsupported:
        errorMessage = 'Scanning is unsupported on this device';
      default:
        errorMessage = 'Generic Error';
        break;
    }

    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Icon(Icons.error, color: Colors.white),
            ),
            Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              error.errorDetails?.message ?? '',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
