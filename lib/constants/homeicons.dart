import 'package:flutter/cupertino.dart';

class HomeModel{
  final String icon;
  final String name;
  HomeModel({required this.icon,required this.name});
}

List<HomeModel> mainMenu=[
  HomeModel(icon: "assets/icons/mobile-banking.png", name: "Account"),
  HomeModel(icon: "assets/icons/messenger.png", name: "Chat"),
  HomeModel(icon: "assets/icons/analytics.png", name: "analytics"),
  HomeModel(icon: "assets/icons/group-people.png", name: "Community"),
  HomeModel(icon: "assets/icons/presentation.png", name: "Finalcial Assest"),
  HomeModel(icon: "assets/icons/peer-to-peer.png", name: "Loan"),
  HomeModel(icon: "assets/icons/gaming.png", name: "Quiz Game"),

];


