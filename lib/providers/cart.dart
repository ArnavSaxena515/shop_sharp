import 'package:flutter/material.dart';
import 'package:shop_sharp/models/cart_item.dart';

class Cart with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get cartCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  void decreaseQuantity(String productID) {
    if (_items.containsKey(productID)) {
      _items.update(
          productID,
          (existingCartItem) => CartItem(
              productID: productID,
              price: existingCartItem.price,
              title: existingCartItem.title,
              quantity: existingCartItem.quantity - 1,
              cartItemID: DateTime.now().toString()));
    }
    notifyListeners();
  }

  void addItem({required String productID, required double price, required String title}) {
    if (_items.containsKey(productID)) {
      _items.update(
          productID,
          (existingCartItem) => CartItem(
              productID: productID,
              price: existingCartItem.price,
              title: existingCartItem.title,
              quantity: existingCartItem.quantity + 1,
              cartItemID: DateTime.now().toString()));
    } else {
      _items.putIfAbsent(
          productID,
          () => CartItem(
                productID: productID,
                title: title,
                cartItemID: DateTime.now().toString(),
                price: price,
                quantity: 1,
              ));
    }

    notifyListeners();
  }

  void removeItem({required String id}) {
    _items.removeWhere((key, itemDetails) => itemDetails.cartItemID == id);
    notifyListeners();
  }
}
