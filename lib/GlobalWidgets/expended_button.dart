import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '/Provider/theme_provider.dart';

class ExpandedButton extends StatelessWidget {
  final String? label;
  final bool filled;
  final VoidCallback? onPress;
  final VoidCallback? onLongPress;
  final Widget? icon;
  final double? radius;

  const ExpandedButton({
    this.label,
    this.filled = false,
    this.onPress,
    this.icon,
    this.onLongPress,
    this.radius,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final height = Get.height * .015;
    return GestureDetector(
      onTap: onPress,
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
            gradient: filled ? linearGradient : null,
            color: filled ? primaryColor : null,
            borderRadius: BorderRadius.circular(radius ?? 100),
            border: gradientBoxBorder),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) icon!.paddingOnly(right: height),
            Text(
              label ?? "label",
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontWeight: FontWeight.w500, color: filled ? Colors.black : textColor),
            ).paddingSymmetric(vertical: height),
          ],
        ),
      ).animate().fade(delay: 500.ms),
    );
  }
}
