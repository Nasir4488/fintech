import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/GlobalWidgets/expended_button.dart';
import '/Provider/theme_provider.dart';

class InfoShowPrivateKey extends StatelessWidget {
  final VoidCallback? onCancel;
  final VoidCallback? onConfirm;

  const InfoShowPrivateKey({this.onCancel, this.onConfirm, super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: primaryColor),
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "keep your Private Key safe",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: textColor,
                          ),
                    ),
                  ],
                ).paddingOnly(bottom: 20),
                RichText(
                    text: TextSpan(
                        text: "Your Private Key provides ",
                        style: Theme.of(context).textTheme.titleSmall,
                        children: <TextSpan>[
                      TextSpan(
                          text: "full access to your account and funds.",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w800))
                    ])).paddingOnly(bottom: 20),
                Text(
                  "Do not share this with anyone",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ).paddingOnly(bottom: 5),
                Text(
                  "VRC Network Support will not request this",
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(),
                ).paddingOnly(bottom: 5),
                Text(
                  "but phishers might",
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(color: textColor),
                ).paddingOnly(bottom: 20),
                ExpandedButton(
                  icon: const Icon(Icons.lock_rounded, color: Colors.black),
                  filled: true,
                  label: "Hold To Revel Key",
                  onLongPress: onConfirm,
                ).paddingAll(20),
              ],
            ).paddingAll(10),
          ).paddingOnly(top: 20),
        ],
      ),
    );
  }
}
