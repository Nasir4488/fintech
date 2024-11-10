import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../wedgits/appbar_wedgit.dart';
class MessageScreen extends StatefulWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar:  PreferredSize(
          preferredSize: Size.fromHeight(140),
          child: Appbar_wegit(arrow: true,title: "Messages",color: true,) ),
      body: ListView(
        children: [
          Message(context),
          Message(context),
          Message(context),
          Message(context),
          Message(context),
        ],
      ),
    );
  }
}


Widget Message(BuildContext context){
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

