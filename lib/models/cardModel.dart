class CardModel{
  final String name;
  final String type;
  final double cardNumber;
  final int csv;
  final double balance;
  final String expDate;

  CardModel(
      {
        required this.name,
        required this.type,
        required this.cardNumber,
        required this.csv,
        required this.balance,
        required this.expDate
      });

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      name: json["name"],
      type: json["type"],
      cardNumber: double.parse(json["cardNumber"]),
      csv: int.parse(json["csv"]),
      balance: double.parse(json["balance"]),
      expDate: json["expDate"],
    );
  }

  Map<String, dynamic> toJson({required String id}) {
    return {
      "id":id,
      "name": this.name,
      "type": this.type,
      "cardNumber": this.cardNumber,
      "csv": this.csv,
      "balance": this.balance,
      "expDate": this.expDate,
    };
  }

//
}



List<CardModel> dumy=[
  CardModel(name: "Nasir", type: "Premium", cardNumber: 1030790088771, csv: 234, balance: 1233, expDate: "23/26")
];