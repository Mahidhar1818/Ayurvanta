class MedicineModel {
  final String id, name, brand, pack, emoji;
  final int price, originalPrice;
  final bool requiresPrescription;
  final String category;

  const MedicineModel({
    required this.id,
    required this.name,
    required this.brand,
    required this.pack,
    required this.emoji,
    required this.price,
    required this.originalPrice,
    required this.requiresPrescription,
    required this.category,
  });

  int get discount =>
      (((originalPrice - price) / originalPrice) * 100).round();
}

class OrderModel {
  final String id, orderNumber, date;
  final int totalAmount;
  final List<String> medicines;
  final OrderStatus status;

  const OrderModel({
    required this.id,
    required this.orderNumber,
    required this.date,
    required this.totalAmount,
    required this.medicines,
    required this.status,
  });
}

enum OrderStatus { placed, packed, shipped, delivered }
