import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String? name;
  String? email;
  String? photoUrl;
  String? totalFee;
  String? pendingFee;
  String? id;

  UserModel({
    this.id,
    this.email,
    this.name,
    this.photoUrl,
    this.totalFee,
    this.pendingFee,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        name: json["name"],
        email: json["email"],
        photoUrl: json["photoUrl"],
        id: json["id"],
        totalFee: json["totalFee"]??"0.1",
        pendingFee: json["pendingFee"]??"0.1",
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "photoUrl": photoUrl,
        "id": id,
        "totalFee": totalFee??"0.1",
        "pendingFee": pendingFee??"0.1"
      };
}
