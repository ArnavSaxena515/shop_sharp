import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shop_sharp/utilities/url_links.dart';
import 'package:http/http.dart' as http;
import 'package:shop_sharp/models/http_exception.dart';

part 'product.g.dart';

@JsonSerializable()
class Product with ChangeNotifier {
  final String id, description, title, imageUrl;
  final double price;
  bool isFavorite;

  Product({
    required this.title,
    required this.id,
    this.description = '',
    required this.imageUrl,
    required this.price,
    this.isFavorite = false,
  });

  // for JSON Serializable to generate encode and decode methods for this class to obtain a json string that can easily be encoded into a JSON object
  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);

  Product copyWith({
    String? title,
    String? id,
    String? description,
    String? imageUrl,
    double? price,
    bool? isFavorite,
  }) {
    return Product(
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      id: id ?? this.id,
      isFavorite: isFavorite ?? this.isFavorite,
      description: description ?? this.description,
      price: price ?? this.price,
    );
  }

  Future<void> toggleFavorite(String? token, String? userID) async {
    isFavorite = !isFavorite;
    notifyListeners();

    final url = Uri.parse(databaseURL + "userFavorites/$userID/$id.json?auth=$token");

    try {
      final response = isFavorite
          ? await http.put(url,
              body: json.encode({
                'isFavorite': isFavorite,
              }))
          : await http.delete(url);

      if (response.statusCode >= 400) {
        isFavorite = !isFavorite;
        throw HttpException(message: "Request could not be completed\nError ${response.statusCode}");
      }
    } catch (error) {
      rethrow;
    }

    // notifyListeners();
  }

  bool checkFavorite() {
    return isFavorite;
  }

  void printDetails() {
    //method to print details of a product for debugging purposes
    print("title: $title, id: $id, description: $description, price: $price\nimage url: $imageUrl");
  }
}
