import 'dart:convert';

List<BeneficiaryModel> beneficiaryModelFromJson(String str) =>
    List<BeneficiaryModel>.from(json.decode(str).map((x) => BeneficiaryModel.fromJson(x)));

String beneficiaryModelToJson(List<BeneficiaryModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BeneficiaryModel {
  String? name;
  String? address;

  BeneficiaryModel({
    this.name,
    this.address,
  });

  factory BeneficiaryModel.fromJson(Map<String, dynamic> json) => BeneficiaryModel(
        name: json["name"],
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "address": address,
      };
}
