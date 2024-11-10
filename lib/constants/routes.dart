import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screen/auth_screens/login.dart';
import '../screen/auth_screens/signup_screen.dart';
import '../screen/bottomNavigationBar.dart';
import '../screen/home.dart';
import '../screen/searchScreen/search.dart';
class AllRoutes{
  static String homePage = "/home";
  static String loginScreen="/login";
  static String signUpScreen="/signup_screen";
  static String navigation="/bottomNavigationBar";
  static String searchScreen="/bottomNavigationBar";
}

List<GetPage> allPages = [
  GetPage(name: AllRoutes.homePage, page: () => const HomeScreen()),
  GetPage(name: AllRoutes.loginScreen, page: () => const Login_Screen()),
  GetPage(name: AllRoutes.signUpScreen, page: () =>const Signup_Screen()),
  GetPage(name: AllRoutes.navigation, page: () =>const Navigations()),
  GetPage(name: AllRoutes.searchScreen, page: () =>const SearchScreen()),
];