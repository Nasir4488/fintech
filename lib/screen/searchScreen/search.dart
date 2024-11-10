import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../wedgits/appbar_wedgit.dart';
class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar:  PreferredSize(
        preferredSize: Size.fromHeight(140),
        child: Appbar_wegit(arrow: true,title: "Search",color: true,) ),
      body: ListView(
        children: [
          SizedBox(height: 20,),
          singleSearchItem(context),
          singleSearchItem(context),
          singleSearchItem(context),
          singleSearchItem(context),
          singleSearchItem(context),
        ],
      ),
    );
  }
}

Widget singleSearchItem(BuildContext context){
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Branch",style: Theme.of(context).textTheme.bodyMedium,),
              SizedBox(height: 10,),
              Text("Search For Branch",style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 12,fontWeight:FontWeight.w100),)
            ],
          ),
          Image.asset("assets/images/search_page_image1.png"),
        ],
      ),
    ),
  );
}
