import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:fin_tech/Models/beneficiary_model.dart';
import 'package:fin_tech/Services/storage_services.dart';
import 'package:fin_tech/Utils/utils.dart';

class FundTransferProvider extends ChangeNotifier {
  List<BeneficiaryModel> beneficiaryModel = <BeneficiaryModel>[];

  BeneficiaryModel? beneficiary;

  void getBeneficiary() async {
    beneficiaryModel = <BeneficiaryModel>[];
    final data = AppStorage.box.read(AppStorage.BENEFICIARY);
    if (data == null) return;

    beneficiaryModel = beneficiaryModelFromJson(data);
    await 0.delay();
    notifyListeners();
  }

  Future<void> saveBeneficiary(String name, String address) async {
    for (var value in beneficiaryModel) {
      if (value.address == address) {
        showToast("Duplicate Entry");

        return;
      }
    }

    final beneficiary = BeneficiaryModel(name: name, address: address);

    beneficiaryModel.add(beneficiary);

    final je = json.encode(beneficiaryModel);

    await AppStorage.box.write(AppStorage.BENEFICIARY, je);

    getBeneficiary();
  }

  Future<void> deleteAddress(index) async {
    beneficiaryModel.removeAt(index);
    final je = json.encode(beneficiaryModel);

    await AppStorage.box.write(AppStorage.BENEFICIARY, je);
    showToast("Deleted");
    getBeneficiary();
  }
}
