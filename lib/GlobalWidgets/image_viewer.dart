import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fin_tech/Provider/theme_provider.dart';

class ViewFullImagePage extends StatelessWidget {
  final String? image;

  const ViewFullImagePage(this.image, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "VCR NETWORK",
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: textColor,
              ),
        ),

      ),
      backgroundColor: Colors.black12,
      body: Center(
        child: Container(
          height: Get.height * .5,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: MemoryImage(base64Decode(image??"")),
            ),
          ),
        ),
      ),
    );
  }
}
