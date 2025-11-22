import 'dart:convert';

List<VrcWalletModel> vrcWalletModelFromJson(String str) =>
    List<VrcWalletModel>.from(json.decode(str).map((x) => VrcWalletModel.fromJson(x)));

String vrcWalletModelToJson(List<VrcWalletModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VrcWalletModel {
  bool isActive;
  String? accountTitle;
  String? privateKey;
  String? walletAddress;
  int? color;
  String? lastBalance;
  String? status;
  List<WalletHistoryModel> history;

  VrcWalletModel(
      {this.accountTitle,
      this.privateKey,
       required this.status,
      this.isActive = false,
      this.walletAddress,
      this.color,
      this.lastBalance,
      this.history = const []});

  factory VrcWalletModel.fromJson(Map<String, dynamic> json) => VrcWalletModel(
      accountTitle: json["accountTitle"],
      privateKey: json["privateKey"],
      walletAddress: json["walletAddress"],
      // walletAddress: "0x69ef5f8a3390a4ec8079e81ad7cbf8c37326aff2",
      isActive: json["isActive"] ?? false,
      color: json["colorCode"],
      lastBalance: json["lastBalance"],
      status: json["status"],
      history: json["history"] != null
          ? List<WalletHistoryModel>.from(
              json["history"].map(
                (x) => WalletHistoryModel.fromJson(x),
              ),
            )
          : []);

  Map<String, dynamic> toJson() => {
        "accountTitle": accountTitle,
        "privateKey": privateKey,
        "status": status,
        "walletAddress": walletAddress,
        "isActive": isActive,
        "lastBalance": lastBalance,
        "colorCode": color,
        "history": List<dynamic>.from(history.map((x) => x.toJson())),
      };
}

class WalletHistoryModel {
  String hash;
  String title;
  String status;
  String amount;
  String? address;
  DateTime createAt;

  WalletHistoryModel({
    required this.hash,
    required this.title,
    required this.status,
    required this.amount,
    required this.address,
    required this.createAt,
  });

  factory WalletHistoryModel.fromJson(Map<String, dynamic> json) => WalletHistoryModel(
        hash: json["hash"],
        title: json["title"],
        status: json["Status"],
        address: json["PrivateKey"],
        amount: json["amount"],
        createAt: DateTime.parse(json["createAt"]),
      );

  Map<String, dynamic> toJson() => {
        "hash": hash,
        "title": title,
        "Status": status,
        "PrivateKey": address,
        "amount": amount,
        "createAt": createAt.toIso8601String(),
      };
}
