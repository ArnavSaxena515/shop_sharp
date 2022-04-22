import 'package:flutter/material.dart';

import '/dummy_data.dart';
import 'product.dart';

class Products with ChangeNotifier {
  final List<Product> _items = DUMMY_PRODUCTS;

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return items.where((item) => item.checkFavorite()).toList();
  }

  Product findByID(String id) {
    return _items.firstWhere((element) => element.id == id, orElse: () => Product(price: 0, description: '', title: '', imageUrl: '', id: ''));
  }

  //method to add new product to the store or to update an existing one
  void updateProducts(Product product) {
    //int index = 0;
    //if element already exists in the items list, find its index
    int index = _items.indexWhere((element) => element.id == product.id);

    //if item exists already (match by ID), delete it so that it can be replaced with updated details
    _items.removeWhere((element) => product.id == element.id);
    // if index == -1, add a new product to the list. otherwise this product already exists in the list, so just update it at the right index
    index == -1 ? _items.add(product) : _items.insert(index, product);
    notifyListeners();
  }

  void deleteProduct(String productID) {
    //function to delete product from the list of items, matched by product ID
    _items.removeWhere((item) => item.id == productID);
    notifyListeners();
  }
}
