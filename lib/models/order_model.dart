class OrderModel {
  final int? id;
  final String userId;
  final double totalPrice;
  final String address;
  final String paymentMethod;
  final String? createdAt;

  OrderModel({
    this.id,
    required this.userId,
    required this.totalPrice,
    required this.address,
    required this.paymentMethod,
    this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as int?,
      userId: json['user_id'] as String,
      totalPrice: (json['total_price'] as num).toDouble(),
      address: json['address'] as String,
      paymentMethod: json['payment_method'] as String,
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'total_price': totalPrice,
      'address': address,
      'payment_method': paymentMethod,
    };
  }
}
