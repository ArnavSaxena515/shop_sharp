// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartItem _$CartItemFromJson(Map<String, dynamic> json) => CartItem(
      title: json['title'] as String,
      cartItemID: json['cartItemID'] as String,
      price: (json['price'] as num).toDouble(),
      productID: json['productID'] as String,
      quantity: json['quantity'] as int? ?? 0,
    );

Map<String, dynamic> _$CartItemToJson(CartItem instance) => <String, dynamic>{
      'cartItemID': instance.cartItemID,
      'title': instance.title,
      'productID': instance.productID,
      'price': instance.price,
      'quantity': instance.quantity,
    };
