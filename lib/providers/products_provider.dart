import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_sharp/models/http_exception.dart';

import '../utilities/url_links.dart';
import 'product.dart';

// const databaseURL = "https://shop-sharp-default-rtdb.asia-southeast1.firebasedatabase.app/";

class Products with ChangeNotifier {
  List<Product> _items = [];

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
  Future<void> addNewProduct(Product product) async {
    final url = Uri.parse(databaseURL + "products.json");
    //return the http.post response because the first "then" we call on the http request (that execute once http request yields a response)
    //will do the needful and add the product to the products list locally in products list with the product key from
    // firestore. This "first then" will also return a type future. So effectively,
    // http_request-->then-->Future. So effectively we are returning a future overall from this function.
    return http.post(url, body: json.encode(product.toJson())).then((response) {
      product = product.copyWith(id: jsonDecode(response.body)['name']); //todo maybe update this to datetime
      _items.add(product);
      //product.printDetails();

      notifyListeners();
    }).catchError((error) {
      throw error; // this error is thrown to the place where this fxn was called from
      // we could also send this error to an analytics server
    });
  }

  Future<void> fetchAndSetProducts() async {
    final fetchUrl = Uri.parse(databaseURL + "products.json");
    try {
      final response = await http.get(fetchUrl);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      // ignore: unnecessary_null_comparison
      if (extractedData == null || extractedData.isEmpty) {
        //if backend returns null or empty, return to prevent further function execution
        return;
      }
      extractedData.forEach((productID, productData) {
        loadedProducts.add(Product(
          title: productData['title'],
          description: productData['description'],
          id: productID,
          imageUrl: productData['imageUrl'],
          price: productData['price'],
          isFavorite: productData['isFavorite'],
        ));
      });
      _items = loadedProducts;

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  //TODO: each user will have their own list of products they have added to the store, so updates, additions and deletions should be done in that subset of user added produts rather than searching through all of the products.

  Future<void> deleteProduct(String productID) async {
    //function to delete product from the list of items, matched by product ID
    final url = Uri.parse(databaseURL + "products/$productID.json");
    final productIndex = _items.indexWhere((element) => element.id == productID);
    Product? existingProduct = _items[productIndex];
    _items.removeAt(productIndex);

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(productIndex, existingProduct);
      notifyListeners();
      throw HttpExtension(message: 'Could not delete product');
    }

    existingProduct = null;
    notifyListeners();
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);

    if (prodIndex >= 0) {
      final url = Uri.parse(databaseURL + "products/$id.json");
      try {
        final response = await http.patch(url, body: jsonEncode(newProduct.toJson()));
        if (response.statusCode >= 400) {
          throw HttpException("Request could not be completed\nError ${response.statusCode}");
        }
      } catch (error) {
        rethrow;
      }
      _items[prodIndex] = newProduct;

      notifyListeners();
    } else {
      //print("prod not found");
    }
  }
}
