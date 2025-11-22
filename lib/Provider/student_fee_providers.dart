import 'package:fin_tech/Models/student_fee_model.dart';
import 'package:fin_tech/Provider/providers.dart';
import 'package:fin_tech/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Models/transfer_history_model.dart';

class StudentFeeProvider extends ChangeNotifier {
  Future<void> saveFeeRecord(StudentFee feeRecord) async {
    try {
      final feeRef = FirebaseFirestore.instance.collection('fee').doc(feeRecord.studentId);
      await feeRef.set(feeRecord.toJson());
      logger.i('Fee record saved successfully.');

      final user = FirebaseFirestore.instance.collection('users').doc(feeRecord.studentId);

      double? paidFee = double.tryParse(feeRecord.pendingeFee ?? "");
      double? totalFee = double.tryParse(feeRecord.totalFee ?? "");

      if (paidFee == null || totalFee == null) return;

      String balanceFee = (totalFee - paidFee).toString();
      logger.i(balanceFee);
      user.update({'pendingFee': balanceFee});
      authProviders.getUser();
      authProviders.fetchUserData();
    } catch (e) {
      logger.i('Error saving fee record: $e');
    }
  }

  void saveTransactionHistory(TransferHistoryModel model, String hash) async {
    try {
      final feeRef =
          FirebaseFirestore.instance.collection('transactions').doc();
      await feeRef.set(model.toJson());
      logger.i('trans record saved successfully.');
    } catch (e) {
      logger.i('Error saving trans record: $e');
    }
  }

  String feeAddress="0xBc4eCcAaA4F90FE0376a9A77Ead41020fd56c487";

  // void getFeeAddress() async {
  //   final feeRef = FirebaseFirestore.instance.collection('fee').doc('feeAddress');
  //   final data = await feeRef.get();
  //   feeAddress = data['address'];
  //   notifyListeners();
  // }
}
