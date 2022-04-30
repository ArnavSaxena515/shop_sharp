// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      title: json['title'] as String,
      id: json['id'] as String,
      description: json['description'] as String? ?? '',
      imageUrl: json['imageUrl'] as String,
      price: (json['price'] as num).toDouble(),
      // isFavorite: json['isFavorite'] as bool? ?? false,
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'title': instance.title,
      'imageUrl': instance.imageUrl,
      'price': instance.price,
      // 'isFavorite': instance.isFavorite,
    };
