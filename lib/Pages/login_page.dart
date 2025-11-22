import 'package:fin_tech/GlobalWidgets/expended_button.dart';
import 'package:fin_tech/Pages/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Provider/providers.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ExpandedButton(
          label: "Login With Google",
          filled: true,
          onPress: () {
            authProviders.loginWithGoogle().then((r) {
              if (r) {
                Get.offAll(const LandingPage());
              }
            });
          },
        ).paddingSymmetric(horizontal: 20),
      ),
    );
  }
}
