
import 'dart:async';

import 'package:fin_tech/Pages/login_page.dart';
import 'package:fin_tech/Services/storage_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fin_tech/Provider/providers.dart';
import '/Pages/landing_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  double progress = 0.0;
  void startLoading() {
    Timer.periodic(const Duration(milliseconds: 300), (timer) {
      if (progress < 1.0) {
        setState(() {
          progress += 0.1; // Increase progress every 300ms
        });
      } else {
        timer.cancel();
      }
    });
  }
  @override
  void initState() {
    handelAuthenticationAndNavigation();
    contractProvider.setInitRPC();
    startLoading();
    super.initState();
  }

  void handelAuthenticationAndNavigation() async {
    Future.delayed(
      const Duration(seconds: 3),
      () async {
        if (AppStorage.box.hasData(AppStorage.USERDATA) == false) {
          Get.off(() => const LoginPage());
          return;
        }
        Get.off(() => const LandingPage());
        return;

        // if (AppStorage.box.hasData(AppStorage.WALLETS_DATA) == false) {
        //   return;
        // }
        //
        // if (AppStorage.box.hasData(AppStorage.WALLET_PASSWORD)) {
        //   bool? result = await Get.to(() => const GetAppPasswordPage());
        //   if (result == true) {
        //     return Get.offAll(() => const LandingPage());
        //   }
        // }
        // return Get.offAll(const LandingPage());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

     body : Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Image.asset("assets/on_chain.jpg", fit: BoxFit.cover),
          ),
          Positioned(
            bottom: 50,
            left: 30,
            right: 30,
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[300],
              color: Colors.blueAccent,
              minHeight: 6,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }
}
