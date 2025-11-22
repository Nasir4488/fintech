import 'package:fin_tech/GlobalWidgets/expended_button.dart';
import 'package:fin_tech/GlobalWidgets/input_field.dart';
import 'package:fin_tech/Provider/providers.dart';
import 'package:fin_tech/Provider/student_fee_providers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../Models/student_fee_model.dart';
import '../Utils/utils.dart';

void payFeeBottomSheet() {
  Get.bottomSheet(const PayFeeWidget(), backgroundColor: Colors.white);
}

class PayFeeWidget extends StatefulWidget {
  const PayFeeWidget({super.key});

  @override
  State<PayFeeWidget> createState() => _PayFeeWidgetState();
}

class _PayFeeWidgetState extends State<PayFeeWidget> {
  @override
  void initState() {
    super.initState();
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Please Enter Amount"),
        Consumer<StudentFeeProvider>(
          builder: (BuildContext context, value, Widget? child) {
            return Text("Fee Address: ${value.feeAddress}");
          },
        ),
        Form(
          key: formKey,
          child: AppFormField(
            hintText: "Enter amount",
            controller: walletProvider.amountCtrl,
            validator: (v) {
              final val = double.tryParse(v ?? "");
              if (v!.isEmpty == true || val == null) {
                "Please Enter valid amount";
              }

              return null;
            },
          ),
        ),
        ExpandedButton(
          label: "Submit",
          filled: true,
          onPress: () {
            if (formKey.currentState?.validate() != true) return;
            walletProvider
                .sendFunds(receiverAddress: studentFeeProvider.feeAddress)
                .then((v) {
              if (v) {
                final sf = StudentFee(
                  studentId: authProviders.getUser()?.id,
                  studentName: authProviders.getUser()?.name,
                  totalFee: authProviders.getUser()?.totalFee,
                  pendingeFee: walletProvider.amountCtrl.text,
                );
                studentFeeProvider.saveFeeRecord(sf);
              }
            });
          },
        ).paddingAll(20)
      ],
    ).paddingAll(20);
  }
}
