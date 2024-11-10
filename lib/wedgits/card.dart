import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/cardModel.dart';
class CardBankMulti extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          height:250,
          width: Get.width*0.9,
          child: Stack(
            children: [
              Positioned(
                left: 33,
                top: 57,
                child: Container(
                  width: 310,
                  height: 185,
                  decoration: ShapeDecoration(
                    color: Color(0xFF5655B9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x113629B7),
                        blurRadius: 30,
                        offset: Offset(0, 4),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 20,
                top: 35,
                child: Container(
                  width: Get.width*.8,
                  height: 200,
                  decoration: ShapeDecoration(
                    color: Color(0xFFFF4267),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x113629B7),
                        blurRadius: 30,
                        offset: Offset(0, 4),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: 327,
                  height: 204,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 327,
                          height: 204,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 253.84,
                                top: 161.87,
                                child: Container(
                                  width: 46.56,
                                  height: 15.52,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: 3.88,
                                        top: 0,
                                        child: Container(
                                          width: 42.68,
                                          height: 15.52,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage("https://via.placeholder.com/43x16"),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 22.44,
                        top: 32.42,
                        child: SizedBox(
                          width: 148.54,
                          height: 39.91,
                          child: Text(
                            '${dumy[0].name}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 24.44,
                        top: 92.82,
                        child: SizedBox(
                          width: 142.99,
                          height: 17.74,
                          child: Text(
                            '${dumy[0].type}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              height: 0.08,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 22.35,
                        top: 121.96,
                        child: Container(
                          width: 296.60,
                          height: 26.61,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: SizedBox(
                                  width: 208.77,
                                  height: 26.61,
                                  child: Text(
                                    '${dumy[0].cardNumber}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      height: 0.09,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 202.26,
                                top: 0,
                                child: SizedBox(
                                  width: 50.34,
                                  height: 26.61,
                                  child: Text(
                                      '${dumy[0].csv}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      height: 0.09,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 58.25,
                                top: 11.09,
                                child: Container(
                                  width: 81.75,
                                  height: 5.31,
                                  child: Stack(children: [

                                      ]),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 26.44,
                        top: 149.94,
                        child: SizedBox(
                          width: 109.74,
                          height: 31.04,
                          child: Text(
                            '\$${dumy[0].balance}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              height: 0.07,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}