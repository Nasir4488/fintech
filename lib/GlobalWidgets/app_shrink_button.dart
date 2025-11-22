import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fin_tech/Provider/theme_provider.dart';
import '/utils/extension.dart';

class ShrinkButton extends StatelessWidget {
  final void Function() onTap;
  final String label;

  const ShrinkButton({required this.onTap, this.label = '', super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
       gradient: linearGradient,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Colors.black,
            ),
      ).paddingSymmetric(horizontal: 15, vertical: 7.5),
    ).onTap(onTap);
  }
}
