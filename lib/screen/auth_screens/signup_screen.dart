import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../../constants/colors.dart';
import '../../constants/routes.dart';
import '../../constants/textformfield.dart';
import '../../wedgits/appbar_wedgit.dart';

class Signup_Screen extends StatefulWidget {
  const Signup_Screen({Key? key}) : super(key: key);

  @override
  State<Signup_Screen> createState() => _Signup_ScreenState();
}

class _Signup_ScreenState extends State<Signup_Screen> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isSecure=true;
  bool isChecked=true;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: primaryTextColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: Appbar_wegit(title: "Signup",arrow: true,),
      ),
      body: ListView(
        children: [
          Container(
            height: height,
            decoration: BoxDecoration(
              color: whiteTextColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(40),
                topLeft: Radius.circular(40),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(8),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Welcome Here",style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: primaryTextColor,fontWeight: FontWeight.bold),),
                          Text("SignUp to continue ",style: Theme.of(context).textTheme.bodySmall!.copyWith(color: blackTextColor,fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      alignment: Alignment.center,
                      height: 200,
                      width: MediaQuery.of(context).size.width*0.5,
                      child: Image.asset("assets/images/person.png"),
                    ),
                    SizedBox(height: 8,),
                    TextFormField(
                      controller: email,
                      cursorHeight: 25,
                      maxLines: 1,
                      validator: (value) {
                        if (value != null || value!.isEmpty) {
                          return "Please Enter Email";
                        }
                      },
                      decoration: buildInputDecoration("Email"),
                      style: Theme.of(context).textTheme.bodySmall,
                      onChanged: (value) {
                        setState(() {}); // Update the widget tree
                      },
                    ),
                    SizedBox(height: 8,),
                    TextFormField(
                      controller: email,
                      cursorHeight: 25,
                      maxLines: 1,
                      validator: (value) {
                        if (value != null || value!.isEmpty) {
                          return "Please Enter Email";
                        }
                      },
                      decoration: buildInputDecoration("Email"),
                      style: Theme.of(context).textTheme.bodySmall,
                      onChanged: (value) {
                        setState(() {}); // Update the widget tree
                      },
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      obscureText: isSecure,
                      controller: password,
                      cursorHeight: 25,
                      validator: (value) {
                        if (value != null || value!.isEmpty) {
                          return "Please Enter Password";
                        }
                      },
                      decoration:  InputDecoration(
                        contentPadding: EdgeInsets.all(8),
                        labelText: "kkk",
                        labelStyle: TextStyle(color: Colors.grey, fontSize: 14),
                        border: outlineInputBorder,
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                        suffixIcon: IconButton(
                          onPressed: (){
                            setState(() {
                              isSecure=!isSecure;
                              print(isSecure);
                            });
                          },
                          icon: isSecure?Icon(Icons.remove_red_eye):Icon(Icons.access_time),
                        )
                      ),
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(letterSpacing: 2),
                      onChanged: (value) {

                        setState(() {
                        }); // Update the widget tree
                      },
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Checkbox(value: isChecked, onChanged: (value){
                          isChecked=value!;
                          setState(() {

                          });
                        }),
                        Flexible(
                          child: Text(
                            'I have read and agree to the terms and conditions.',
                            style: TextStyle(fontSize: 14.0),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                          color: email.text.isNotEmpty || password.text.isNotEmpty
                              ? primaryTextColor
                              : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(16)),
                      width: width * .8,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                email.text.isNotEmpty || password.text.isNotEmpty
                                    ? primaryTextColor
                                    : Colors.grey.shade200)),
                        onPressed: () {
                          if (_formkey.currentState?.validate() ?? false) {
                            // Form is valid, submit the data
                          }
                        },
                        child: Text(
                          'Submit',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: whiteTextColor),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("already account",style: Theme.of(context).textTheme.bodySmall,),
                        SizedBox(width: 8),
                        TextButton(
                            onPressed: (){
                              Get.toNamed(AllRoutes.navigation);
                            },
                            child: Text("Login",style: Theme.of(context).textTheme.bodySmall!.copyWith(color: primaryTextColor),)
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
InputDecoration buildInputDecoration(String labelText, {Icon? suffixIcon, Function()? onPress}) {
  return InputDecoration(
    contentPadding: EdgeInsets.all(8),
    labelText: labelText,
    labelStyle: TextStyle(color: Colors.grey, fontSize: 14),
    border: outlineInputBorder,
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
    suffixIcon: suffixIcon != null
        ? IconButton(
      onPressed: onPress,
      icon: suffixIcon,
    )
        : null,
  );
}

