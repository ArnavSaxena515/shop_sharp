import 'cart_item.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order_item.g.dart';

@JsonSerializable()
class OrderItem {
//  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({required this.amount, required this.products, required this.dateTime});

  factory OrderItem.fromJson(Map<String, dynamic> json) => _$OrderItemFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemToJson(this);
}
