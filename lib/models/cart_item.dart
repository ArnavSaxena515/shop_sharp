import 'package:json_annotation/json_annotation.dart';

part 'cart_item.g.dart';

@JsonSerializable()
class CartItem {
  CartItem({
    required this.title,
    required this.cartItemID,
    required this.price,
    required this.productID,
    this.quantity = 0,
  });

  final String cartItemID, title, productID;
  final double price;
  int quantity;

  factory CartItem.fromJson(Map<String, dynamic> json) => _$CartItemFromJson(json);

  Map<String, dynamic> toJson() => _$CartItemToJson(this);
}
