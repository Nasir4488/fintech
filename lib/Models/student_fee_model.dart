import 'dart:convert';

StudentFee studentFeeFromJson(String str) => StudentFee.fromJson(json.decode(str));

String studentFeeToJson(StudentFee data) => json.encode(data.toJson());

class StudentFee {
  String? studentId;
  String? studentName;
  String? totalFee;
  String? pendingeFee;

  StudentFee({
    this.studentId,
    this.studentName,
    this.totalFee,
    this.pendingeFee,
  });

  factory StudentFee.fromJson(Map<String, dynamic> json) => StudentFee(
        studentId: json['studentId'],
        studentName: json['studentName'],
        totalFee: json['totalFee'],
        pendingeFee: json['paidFee'],
      );

  Map<String, dynamic> toJson() => {
        'studentId': studentId,
        'studentName': studentName,
        'totalFee': totalFee,
        'paidFee': pendingeFee,
      };
}
