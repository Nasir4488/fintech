import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fin_tech/Provider/theme_provider.dart';
import 'package:fin_tech/Utils/extension.dart';

class ToggleSwitch extends StatefulWidget {
  final ValueChanged<String> onChange;
  final List<String> values;

  const ToggleSwitch({required this.values, required this.onChange, super.key});

  @override
  State<ToggleSwitch> createState() => _ToggleSwitchState();
}

class _ToggleSwitchState extends State<ToggleSwitch> {
 late String selectedValue ;

  @override
  void initState() {
   selectedValue=widget.values.first;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight=Get.height*.015;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: primaryColor),
        borderRadius: BorderRadius.circular(100),
        color: Theme.of(context).cardColor,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: widget.values
            .map(
              (e) => Container(
                width: Get.width * .35,
                decoration: BoxDecoration(
                  gradient: e == selectedValue ? linearGradient : null,
                  color: e == selectedValue ? primaryColor : null,
                  borderRadius: BorderRadius.circular(screenHeight*100),
                ),
                child: Center(
                  child: Text(
                    e,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: selectedValue == e ? Colors.black : textColor),
                  ).paddingSymmetric(vertical: screenHeight),
                ),
              ).onTap(() {
                selectedValue = e;

                setState(() {});
                widget.onChange(e);
              }),
            )
            .toList(),
      ),
    );
  }
}
