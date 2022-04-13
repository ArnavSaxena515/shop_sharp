import 'package:flutter/material.dart';
import 'package:shop_sharp/dummy_data.dart';
import 'product.dart';

class Products with ChangeNotifier {
  final List<Product> _items = DUMMY_PRODUCTS;

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return items.where((element) => element.checkFavorite()).toList();
  }

  void addProduct() {}
  Product findByID(String id) {
    return _items.firstWhere((element) => element.id == id);
  }
}
