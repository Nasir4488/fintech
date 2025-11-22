
import 'dart:convert';

///
///
///
/// RPC MODEL;
RPCModel rpcModelFromJson(String str) => RPCModel.fromJson(json.decode(str));

String rpcModelToJson(RPCModel data) => json.encode(data.toJson());

class RPCModel {
  String title;
  String rpc;

  RPCModel({
    required this.title,
    required this.rpc,
  });

  factory RPCModel.fromJson(Map<String, dynamic> json) => RPCModel(
    title: json["title"],
    rpc: json["rpc"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "rpc": rpc,
  };
}