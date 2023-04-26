class PulsaModel {
  PulsaModel({
    required this.id,
    required this.nominal,
    required this.price,
  });

  final int id;
  final int nominal;
  final int price;

  factory PulsaModel.fromJson(Map<String, dynamic> json) {
    return PulsaModel(
      id: json['id'],
      nominal: json['nominal'],
      price: json['price'],
    );
  }
}
