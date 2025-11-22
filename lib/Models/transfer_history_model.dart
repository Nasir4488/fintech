import 'dart:convert';

TransferHistoryModel transferHistoryModelFromJson(String str) =>
    TransferHistoryModel.fromJson(json.decode(str));

String transferHistoryModelToJson(TransferHistoryModel data) => json.encode(data.toJson());

class TransferHistoryModel {
  final String? transactionHash;
  final String? senderAddress;
  final String? receiverAddress;
  final String? studentId;
  final String? amount;
  final String? timestamp;
  final bool? status;

  TransferHistoryModel({
    this.transactionHash,
    this.senderAddress,
    this.receiverAddress,
    this.amount,
    this.timestamp,
    this.studentId,
    this.status,
  });

  factory TransferHistoryModel.fromJson(Map<String, dynamic> json) => TransferHistoryModel(
        transactionHash: json['transactionHash'],
        senderAddress: json['senderAddress'],
        receiverAddress: json['receiverAddress'],
        amount: json['amount'],
        timestamp: json['timestamp'],
        status: json['status'],
        studentId: json['studentId'],
      );

  Map<String, dynamic> toJson() => {
        'transactionHash': transactionHash,
        'senderAddress': senderAddress,
        'receiverAddress': receiverAddress,
        'amount': amount,
        'timestamp': timestamp,
        'status': status,
        'studentId': studentId,
      };
}
