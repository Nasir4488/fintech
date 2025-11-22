import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

class ThemeProvider extends ChangeNotifier {
  bool isDarkMode = false;
  Color cardDarkColor = const Color(0xff1A1C1D);
  Color cardLightColor = const Color(0xffE8E6EC);

  ///
  ThemeData getAppTheme(BuildContext context) {
    return ThemeData(
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
      primaryColor: primaryColor,
      primaryColorLight: primaryColor.withOpacity(.5),
      floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: primaryColor),
      scaffoldBackgroundColor: isDarkMode ? Colors.black : Colors.white,
      cardColor: isDarkMode ? cardDarkColor : cardLightColor,

      textTheme: TextTheme(
        titleSmall:
            GoogleFonts.poppins().copyWith(fontSize: MediaQuery.of(context).size.height * .015),
        titleMedium:
            GoogleFonts.poppins().copyWith(fontSize: MediaQuery.of(context).size.height * .0195),
        titleLarge:
            GoogleFonts.poppins().copyWith(fontSize: MediaQuery.of(context).size.height * .025),
      ),
      primarySwatch: primarySwatch,
      // listTileTheme: ListTileThemeData(iconColor: primaryColor),
      appBarTheme: AppBarTheme(
          titleTextStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
          backgroundColor: isDarkMode ? Colors.black : Colors.white),
      primaryTextTheme: Theme.of(context)
          .textTheme
          .copyWith(
              titleSmall: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontSize: 12, color: isDarkMode ? Colors.white : Colors.black),
              titleLarge: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontSize: 18, color: isDarkMode ? Colors.white : Colors.black))
          .apply(
            bodyColor: isDarkMode ? Colors.white : Colors.black,
            displayColor: Colors.white,
          ),
    );
  }

  MaterialColor primarySwatch = const MaterialColor(
    0xffcd9636,
    {
      50: Colors.white,
      100: Colors.white,
      200: Colors.white,
      300: Colors.white,
      400: Colors.white,
      500: Colors.white,
      600: Colors.white,
      700: Colors.white,
      800: Colors.white,
      900: Colors.white,
      1000: Colors.white,
    },
  );
}

LinearGradient linearGradient = LinearGradient(colors: [
  primaryColor,
  primaryColor,
]);

RadialGradient radialGradient =
    RadialGradient(colors: [primaryColor, primaryColor1], tileMode: TileMode.repeated);
GradientBoxBorder gradientBoxBorder = GradientBoxBorder(
  gradient: linearGradient,
);

Color primaryColor = const Color(0xFFB38728);
Color primaryColor1 = const Color(0xFFD8BF71);
Color textColor = Colors.black;
Color walletAddressBgColor = const Color(0xff9E833E);
Color appGreenColor = const Color(0xFF008926);
