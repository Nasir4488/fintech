import 'dart:convert';

import 'package:finetecha/controllers/payment_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../constants/reusabletext.dart';
import '../../constants/textformfield.dart';
class Payment extends StatefulWidget {
  const Payment({Key? key}) : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  TextEditingController amountController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();

  final formkey = GlobalKey<FormState>();
  final formkey1 = GlobalKey<FormState>();
  final formkey2 = GlobalKey<FormState>();
  final formkey3 = GlobalKey<FormState>();
  final formkey4 = GlobalKey<FormState>();
  final formkey5 = GlobalKey<FormState>();
  final formkey6 = GlobalKey<FormState>();

  Future createPaymentIntent({required String name,
    required String address,
    required String pin,
    required String city,
    required String state,
    required String country,
    required String currency,
    required String amount}) async{

    final url = Uri.parse('https://api.stripe.com/v1/payment_intents');
    final secretKey="sk_test_51PGgsdByPc4RSoJq1qFWQosptbjEFDmDH09rRr79SoiGQW33Ig4UKlRMykeS6r2Gb72HVNx6W249MpG0ay2r9taD00SSfLVh4a";
    final body={
      'amount': amount,
      'currency': currency.toLowerCase(),
      'automatic_payment_methods[enabled]': 'true',
      'description': "Test Donation",
      'shipping[name]': name,
      'shipping[address][line1]': address,
      'shipping[address][postal_code]': pin,
      'shipping[address][city]': city,
      'shipping[address][state]': state,
      'shipping[address][country]': country
    };

    final response= await http.post(url,
        headers: {
          "Authorization": "Bearer $secretKey",
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body
    );

    print(body);

    if(response.statusCode==200){
      var json=jsonDecode(response.body);
      print(json);
      return json;
    }
    else{
      print("error in calling payment intent");
    }
  }

  List<String> currencyList = <String>[
    'USD',
    'INR',
    'EUR',
    'JPY',
    'GBP',
    'AED'
  ];
  String selectedCurrency = 'USD';

  bool hasDonated = false;

  Future<void> initPaymentSheet() async {
    try {
      // 1. create payment intent on the client side by calling stripe api
      final data = await createPaymentIntent(
        // convert string to double
          amount: (int.parse(amountController.text)*100).toString(),
          currency: selectedCurrency,
          name: nameController.text,
          address: addressController.text,
          pin: pincodeController.text,
          city: cityController.text,
          state: stateController.text,
          country: countryController.text);


      // 2. initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          // Set to true for custom flow
          customFlow: false,
          // Main params
          merchantDisplayName: 'Test Merchant',
          paymentIntentClientSecret: data['client_secret'],
          // Customer keys
          customerEphemeralKeySecret: data['ephemeralKey'],
          customerId: data['id'],

          style: ThemeMode.dark,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      rethrow;
    }
  }
  var paymentCOntroller=Get.put(PaymentController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Image(
                image: AssetImage("assets/image.jpg"),
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              hasDonated? Padding(padding: const EdgeInsets.all(8.0),
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Thanks for your ${amountController.text} $selectedCurrency donation",
                      style: TextStyle(
                          fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      "We appreciate your support",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent.shade400),
                        child: Text(
                          "Donate again",
                          style: TextStyle(
                              color: Colors.white,
                              // fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        onPressed: () {
                          setState(() {
                            hasDonated = false;
                            amountController.clear();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ) :

              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Support us with your donations",
                          style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: ReusableTextField(
                                  formkey: formkey,
                                  controller: amountController,
                                  isNumber: true,
                                  title: "Donation Amount",
                                  hint: "Any amount you like"),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              height: 50,
                              child: DropdownMenu<String>(
                                textStyle: TextStyle(  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,),
                                inputDecorationTheme: InputDecorationTheme(
                                  contentPadding: EdgeInsets.symmetric(
                                       horizontal: 10),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                initialSelection: currencyList.first,
                                onSelected: (String? value) {
                                  // This is called when the user selects an item.
                                  setState(() {
                                    selectedCurrency = value!;
                                  });
                                },
                                dropdownMenuEntries: currencyList
                                    .map<DropdownMenuEntry<String>>((String value) {
                                  return DropdownMenuEntry<String>(
                                      value: value, label: value);
                                }).toList(),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        ReusableTextField(
                          formkey: formkey1,
                          title: "Name",
                          hint: "Ex. John Doe",
                          controller: nameController,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ReusableTextField(
                          formkey: formkey2,
                          title: "Address Line",
                          hint: "Ex. 123 Main St",
                          controller: addressController,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                                flex: 5,
                                child: ReusableTextField(
                                  formkey: formkey3,
                                  title: "City",
                                  hint: "Ex. New Delhi",
                                  controller: cityController,
                                )),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                flex: 5,
                                child: ReusableTextField(
                                  formkey: formkey4,
                                  title: "State (Short code)",
                                  hint: "Ex. DL for Delhi",
                                  controller: stateController,
                                )),
                          ],
                        ),

                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                                flex: 5,
                                child: ReusableTextField(
                                  formkey: formkey5,
                                  title: "Country (Short Code)",
                                  hint: "Ex. IN for India",
                                  controller: countryController,
                                )),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                flex: 5,
                                child: ReusableTextField(
                                  formkey: formkey6,
                                  title: "Pincode",
                                  hint: "Ex. 123456",
                                  controller: pincodeController,
                                  isNumber: true,
                                )),
                          ],
                        ),
                        SizedBox(
                          height: 100,
                        ),
                        SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent.shade400),
                            child: Text(
                              "Proceed to Pay",
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            onPressed: () async {
                              if (formkey.currentState!.validate() &&
                                  formkey1.currentState!.validate() &&
                                  formkey2.currentState!.validate() &&
                                  formkey3.currentState!.validate() &&
                                  formkey4.currentState!.validate() &&
                                  formkey5.currentState!.validate() &&
                                  formkey6.currentState!.validate()) {
                                await initPaymentSheet();

                                try{
                                  await Stripe.instance.presentPaymentSheet();

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                      "Payment Done",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Colors.green,
                                  ));

                                  setState(() {
                                    hasDonated=true;
                                  });
                                  nameController.clear();
                                  addressController.clear();
                                  cityController.clear();
                                  stateController.clear();
                                  countryController.clear();
                                  pincodeController.clear();

                                }catch(e){
                                  print("payment sheet failed");
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                      "Payment Failed",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Colors.redAccent,
                                  ));
                                }

                              }
                            },
                          ),
                        )
                      ])),
            ],
          ),
        ),
      )
    );
  }
}
class StripeService {
  Map<String, dynamic>? paymentIntentData;


  Future<bool?> makePayment({
    required String amount,
    required String currency,
  }) async {
    try {
      debugPrint("Start Payment");
      paymentIntentData = await createPaymentIntent(amount, currency);

      debugPrint("After payment intent");
      if (paymentIntentData != null) {
        debugPrint(" payment intent is not null .........");
        await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
              customFlow: true,
              merchantDisplayName: 'Prospects',
              customerId: paymentIntentData!['customer'],
              paymentIntentClientSecret: paymentIntentData!['client_secret'],
              // applePay: const PaymentSheetApplePay(merchantCountryCode: '+92'),
              googlePay: const PaymentSheetGooglePay(merchantCountryCode: '+40', testEnv: true),
              style: ThemeMode.dark,
            ));
        debugPrint(" initPaymentSheet  .........");
        try {
          await Stripe.instance.presentPaymentSheet();
          return true;

        } on Exception catch (e) {
          if (e is StripeException) {
            debugPrint("Error from Stripe: ${e.error.localizedMessage}");
          } else {
            debugPrint("Unforcen Error: $e");
          }
        } catch (e) {
          debugPrint("Exception $e");
        }
      }
    } catch (e, s) {
      debugPrint("After payment intent Error: ${e.toString()}");
      debugPrint("After payment intent s Error: ${s.toString()}");
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculate(amount),
        'currency': currency,
        'payment_method_types[]': 'card',
      };
      debugPrint("Start Payment Intent http rwq post method");
      var response = await http.post(
          Uri.parse("https://api.stripe.com/v1/payment_intents"),
          body: body,
          headers: {
            "Authorization": "Bearer sk_test_51PGgsdByPc4RSoJq1qFWQosptbjEFDmDH09rRr79SoiGQW33Ig4UKlRMykeS6r2Gb72HVNx6W249MpG0ay2r9taD00SSfLVh4a",
            "Content-Type": 'application/x-www-form-urlencoded'
          });
      debugPrint("End Payment Intent http rwq post method");
      debugPrint(response.body.toString());
      return jsonDecode(response.body);
    } catch (e) {
      debugPrint('err charging user: ${e.toString()}');
    }
  }
  calculate(String amount) {
    final a = (double.parse(amount)) * 100;
    return a.toStringAsFixed(0);
  }
}