import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';
import '../../wedgits/appbar_wedgit.dart';
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryTextColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: Appbar_wegit(title: "Signup",arrow: true,),
      ),
      body: Stack(
        children: [

          Positioned(
              top: 50,
              bottom: 10,
              child: Container(
                height: Get.height-250,
                width: Get.width,
                decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(24),topRight: Radius.circular(24))
                ),
                child: ListView(
                  children: [
                    SizedBox(height: 100,),
                    setting(context),
                    setting(context),
                    setting(context),
                    setting(context),
                    setting(context),
                    setting(context),
                    setting(context),
                    setting(context),
                    setting(context),

                  ],
                ),
              )),
          Positioned(
            top: 50,
            child: Container(
              color: Colors.grey.shade100,
              width: Get.width,
              height: 50,
            ),
          ),

          Positioned(
            left: Get.width/2-50,
            child: Container(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    child: ClipOval(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset("assets/images/nasir.jpeg"),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

        ],
      ),

    );
  }
}
Widget setting(BuildContext context){
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
    height: 100,
    width: Get.width-80,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white
    ),
    child: Container(
      margin: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Added this line
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(16)
            ),
            child: Icon(Icons.account_balance_rounded,size: 26,color: Colors.white,),
          ),
          SizedBox(width: 20,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Branch",style: Theme.of(context).textTheme.bodyMedium,),
                SizedBox(height: 10,),
                Text("Search For Branch",style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 12,fontWeight:FontWeight.w100),)
              ],
            ),
          ),
          Text("10:10",style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 12,fontWeight:FontWeight.w100),)
        ],
      ),
    ),
  );
}


