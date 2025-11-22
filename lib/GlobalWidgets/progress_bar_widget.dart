import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/Provider/theme_provider.dart';

class ProgressBarWidgetWalletCreating extends StatelessWidget {
  final int page;
  final bool fill2;
  final bool fill3;

  const ProgressBarWidgetWalletCreating(this.page,
      {this.fill2 = false, this.fill3 = false, super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = Get.height * .015;

    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
              color: page > 1 ? primaryColor1 : null,
              shape: BoxShape.circle,
              border: Border.all(color: primaryColor1, width:1 )),
          child: Text(
            "1",
            style: Theme.of(context).textTheme.titleSmall,
          ).paddingAll(screenHeight/2),
        ),
        Expanded(child: Container(height: 1, color: page == 1 ? primaryColor1.withOpacity(.5) : primaryColor1)),
        Container(
          decoration: BoxDecoration(
              color: fill2 ? primaryColor : null,
              shape: BoxShape.circle,
              border: Border.all(color: (page == 1) ? primaryColor1.withOpacity(.5) : primaryColor1, width: 1,)),
          child: Text(
            "2",
            style: Theme.of(context).textTheme.titleSmall,
          ).paddingAll(5),
        ),
        Expanded(
            child: Container(
                height: 1,
                color: (page == 1 || (page != 3 && !fill2))
                    ? primaryColor1.withOpacity(.5)
                    : (fill2 ? primaryColor1 : primaryColor1.withOpacity(.5)))),
        Container(
          decoration: BoxDecoration(
              color: fill3 ? primaryColor1 : null,
              shape: BoxShape.circle,
              border: Border.all(
                  color: (page == 1 || page != 3) ? primaryColor1.withOpacity(.5) : primaryColor1, width: 1)),
          child: Text(
            "3",
            style: Theme.of(context).textTheme.titleSmall,
          ).paddingAll(5),
        ),
      ],
    ).paddingSymmetric(horizontal: screenHeight).paddingOnly(bottom: screenHeight);
  }
}
