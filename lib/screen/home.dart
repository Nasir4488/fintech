import 'package:finetecha/screen/Payments/paymentBuCard.dart';
import 'package:finetecha/screen/Payments/paymentChoosing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/colors.dart';
import '../constants/homeicons.dart';
import '../wedgits/appbar_wedgit.dart';
import '../wedgits/card.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryTextColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(140),
        child: Appbar_wegit(title: "Hi Nasir",arrow: false,image: Image.asset("assets/images/person.png"),action: Icon(Icons.notifications_active,size: 22,color: whiteTextColor,),),
      ),
      body: SafeArea(
        child: Container(
          width: Get.width,
          height: Get.height,
          decoration: BoxDecoration(
            color: whiteTextColor,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(50),topRight: Radius.circular(50))
          ),
          child: ListView(
            children: [
              Column(
                children: [
                  Container(
                      alignment: Alignment.center,
                      // child: CardBankMulti()
                  ),
                  SizedBox(height: 20,),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    runSpacing: 20,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      for(var i in mainMenu)
                        Container(
                          width: MediaQuery.of(context).size.width/3-10,
                          child: Column(
                            children: [
                              InkWell(
                                onTap:(){
                                  if(i.name=="Account")
                                    {
                                      Get.to(()=>ChoosingPaymentMethod());
                                    }
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: Image.asset(i.icon,fit: BoxFit.fill,height: 70,),
                                ),
                              ),
                              SizedBox(height: 10,),
                              Text(i.name,style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.normal
                              ),)

                            ],
                          ),
                        )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
