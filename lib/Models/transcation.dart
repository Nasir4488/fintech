import 'package:hive/hive.dart';

@HiveType(typeId: 0)  // Add HiveType annotation
class UserTransaction extends HiveObject {  // Extend HiveObject
  @HiveField(0)
  final String category;


  @HiveField(1)
  final double amount;

  @HiveField(2)
  final DateTime date;

  UserTransaction({
    required this.category,
    required this.amount,
    required this.date,
  });



  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'amount': amount,
      'date': date.toIso8601String(),
    };
  }

  factory UserTransaction.fromMap(Map<String, dynamic> map) {
    return UserTransaction(
      category: map['category'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
    );
  }
}
