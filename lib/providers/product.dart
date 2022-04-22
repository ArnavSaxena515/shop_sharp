import 'package:flutter/cupertino.dart';

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

  void toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  bool checkFavorite() {
    return isFavorite;
  }

  void printDetails() {
    //method to print details of a product for debugging purposes
    print("title: $title, id: $id, description: $description, price: $price\nimage url: $imageUrl");
  }
}
