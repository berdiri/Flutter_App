import 'product_model.dart';

class CartModel {
  final int id;
  final String userId;
  final int productId;
  final int quantity;
  final ProductModel? product;

  CartModel({
    required this.id,
    required this.userId,
    required this.productId,
    required this.quantity,
    this.product,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'] as int,
      userId: json['user_id'] as String,
      productId: json['product_id'] as int,
      quantity: json['quantity'] as int,
      product: json['products'] != null
          ? ProductModel.fromJson(json['products'] as Map<String, dynamic>)
          : null,
    );
  }
}
