import 'package:flutter/material.dart';
import 'package:fin_tech/assets.dart';

class DataLoading extends StatelessWidget {
  const DataLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return  Center(
        child: Image.asset(
          scale: 10,
          ImageSrc.LOADER,
        ));

  }
}
