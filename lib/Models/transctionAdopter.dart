import 'package:fin_tech/Models/transcation.dart';
import 'package:hive/hive.dart';

class TransactionAdapter extends TypeAdapter<UserTransaction> {
  @override
  final typeId = 0;


  @override
  UserTransaction read(BinaryReader reader) {
    return UserTransaction(
      category: reader.readString(),
      amount: reader.readDouble(),
      date: DateTime.parse(reader.readString()),
    );
  }

  @override
  void write(BinaryWriter writer, UserTransaction obj) {
    writer.writeString(obj.category);
    writer.writeDouble(obj.amount);
    writer.writeString(obj.date.toIso8601String());
  }
}