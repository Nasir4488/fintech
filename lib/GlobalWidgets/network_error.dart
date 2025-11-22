import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fin_tech/Provider/theme_provider.dart';

class NetworkError extends StatelessWidget {
  const NetworkError({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Row(),
        Text("Network Error".tr,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: primaryColor)),
        Icon(Icons.cloud, color: primaryColor, size: 50),
      ],
    );
  }
}
