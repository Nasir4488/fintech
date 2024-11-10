import 'package:finetecha/screen/auth_screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'constants/routes.dart';
import 'constants/text_theame.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = "pk_test_51PGgsdByPc4RSoJqEHqZoTcx1cKQKBX7pq11TN86lB7rNHAZhK218tKzUiiCEieHf1z2caXvFPHeWXipxRoq8Ltt006DHQuOSN";
  await Stripe.instance.applySettings();
  Stripe.urlScheme = 'flutterstripe';
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: allPages,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: TextTheme(
          bodyLarge: myTextStylelarge,
          bodyMedium: myTextStylemedium,
          bodySmall: myTextStylesmall,
        )
      ),
      home: const Signup_Screen(),
    );
  }
}
