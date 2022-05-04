import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:shop_sharp/utilities/url_links.dart';
import '../models/cart_item.dart';
import 'package:http/http.dart' as http;

import '../models/order_item.dart';

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders => [..._orders];
  String? userId;
  String? authToken;

  set authTokenSetter(String? value) => authToken = value;

  set ordersSetter(List<OrderItem> value) => _orders = value;

  set userIdSetter(String? value) => userId = value;

  Future<void> fetchAndUpdateOrders() async {
    final url = Uri.parse(databaseURL + "orders/$userId.json?auth=$authToken");
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      // print("ORDERS EXTRACTED DATA");
      //print(extractedData);
      final List<OrderItem> loadedOrders = [];
      // ignore: unnecessary_null_comparison
      if (extractedData == null || extractedData.isEmpty) {
        return;
      }
      extractedData.forEach((orderID, orderData) {
        List<CartItem> cartItemsList = List.generate(orderData['products'].length, (index) => CartItem.fromJson(orderData['products'][index])
            //     CartItem(
            //   title: orderData['products'][index]["title"],
            //   cartItemID: orderData['products'][index]["cartItemID"],
            //   price: orderData['products'][index]["price"],
            //   quantity: orderData['products'][index]["quantity"],
            //   productID: orderData['products'][index]["productID"],
            // ),
            );
        loadedOrders.add(
          OrderItem(
            amount: orderData['amount'],
            products: cartItemsList,
            dateTime: DateTime.parse(orderData['dateTime']),
          ),
        );
      });
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (error) {
      rethrow;
    }
    notifyListeners();
  }

  Future<int> addOrder(List<CartItem> cartProducts, double total) async {
    try {
      final timeStamp = DateTime.now().toIso8601String();
      final url = Uri.parse(databaseURL + "orders/$userId.json?auth=$authToken");
      final response = await http.post(url,
          body: json.encode({
            "amount": total,
            "products": cartProducts,
            "dateTime": timeStamp,
          }));
      if (response.statusCode >= 400) {
        throw HttpException("Could not add order\nError: ${response.statusCode}");
      }

      _orders.insert(0, OrderItem(amount: total, products: cartProducts, dateTime: DateTime.parse(timeStamp)));
      return response.statusCode;
    } catch (error) {
      rethrow;
    } finally {
      notifyListeners();
    }
    // _orders.insert(0, OrderItem(amount: total, products: cartProducts, dateTime: DateTime.now()));
  }
}
