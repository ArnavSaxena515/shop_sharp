import 'package:flutter/material.dart';

import '/models/cart_item.dart';

//Cart Provider, manages all the data for the cart
class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  //getter for items

  int get cartCount {
    return _items.length;
  }
  //getter for number of items in the cart

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  } // get the total cost of all products combined

  void decreaseQuantity(String productID) {
    if (_items.containsKey(productID)) {
      _items.update(
          productID,
          (existingCartItem) => CartItem(
              productID: productID,
              price: existingCartItem.price,
              title: existingCartItem.title,
              quantity: existingCartItem.quantity > 1 ? existingCartItem.quantity - 1 : 0,
              cartItemID: DateTime.now().toString()));
    }
    if (_items[productID]!.quantity == 0) {
      _items.remove(productID);
    }
    notifyListeners();
  }
  //function to decrease the quantity of an item in the cart, identified by productID

  void addItem({required String productID, required double price, required String title}) {
    if (_items.containsKey(productID)) {
      //todo implement local storage to store the items in the cart so they can persist over sessions
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

//add an item to the cart
  void removeItem({required String id}) {
    _items.removeWhere((key, itemDetails) => itemDetails.cartItemID == id);
    notifyListeners();
  }

  //function to remove an item in the cart, identified by Cart Item ID

  void clearCart() {
    _items = {};
    notifyListeners();
  }
//delete all items in cart

}
