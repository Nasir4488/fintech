import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/colors.dart';
class Appbar_wegit extends StatelessWidget {
  final Image? image;
  final String? title;
  final bool? arrow;
  final Icon? action;
  final bool? color;
  const Appbar_wegit({Key? key, this.title, this.image,this.action,this.arrow,this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: image !=null?Container(child: image,):null,
      actions: [
        IconButton(
          onPressed: action != null ? () {} : null,
          icon: action ?? Container(), // Use a default icon if action is null
        ),
        SizedBox(width: 20,)
      ],
      automaticallyImplyLeading: false,
      toolbarHeight: 120,
      title: Container(
        padding: EdgeInsets.all(0),
        margin: EdgeInsets.all(0),
        child: Row(
          children: [
            SizedBox(width: 10,),
            arrow==true?Icon(Icons.arrow_back_ios,color: color==true?blackTextColor:whiteTextColor,size: 22,):Container(),
            SizedBox(width: 10,),
            Text(
              '$title',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w600,
                color: color==true?blackTextColor:whiteTextColor,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: color!=true?primaryTextColor:whiteTextColor,
    );
  }
}
