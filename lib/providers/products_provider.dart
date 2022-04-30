import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_sharp/models/http_exception.dart';

import '../utilities/url_links.dart';
import 'product.dart';

// const databaseURL = "https://shop-sharp-default-rtdb.asia-southeast1.firebasedatabase.app/";

class Products with ChangeNotifier {
  List<Product> _items = [];
  List<Product> _userAddedItems = [];
  String? authToken;

  set authTokenSetter(String? value) => authToken = value;

  set itemsSetter(List<Product> value) => _items = value;

  List<Product> get items {
    return [..._items];
  }

  List<Product> get userAddedProducts {
    return [..._userAddedItems];
  }

  List<Product> get favoriteItems {
    return items.where((item) => item.checkFavorite()).toList();
  }

  Product findByID(String id) {
    return _items.firstWhere((element) => element.id == id, orElse: () => Product(price: 0, description: '', title: '', imageUrl: '', id: ''));
  }

  //method to add new product to the store or to update an existing one
  Future<void> addNewProduct(Product product, String? userId) async {
    final url = Uri.parse(databaseURL + "products.json?auth=$authToken");
    //return the http.post response because the first "then" we call on the http request (that execute once http request yields a response)
    //will do the needful and add the product to the products list locally in products list with the product key from
    // firestore. This "first then" will also return a type future. So effectively,
    // http_request-->then-->Future. So effectively we are returning a future overall from this function.
    final productJson = product.toJson();
    productJson["sellerId"] = userId;
    return http.post(url, body: json.encode(productJson)).then((response) {
      product = product.copyWith(id: jsonDecode(response.body)['name']); //todo maybe update this to datetime
      _items.add(product);
      //product.printDetails();

      notifyListeners();
    }).catchError((error) {
      throw error; // this error is thrown to the place where this fxn was called from
      // we could also send this error to an analytics server
    });
  }

  Future<void> fetchAndSetProducts({String? userID = "", bool filterByUser = false}) async {
    final fetchUrl = Uri.parse("${databaseURL}products.json?auth=$authToken");
    final fetchUserAddedProductsUrl = Uri.parse('${databaseURL}products.json?auth=$authToken&orderBy="sellerId"&equalTo="$userID"');
    try {
      final fetchAllProductsResponse = await http.get(fetchUrl);
      print(fetchAllProductsResponse.body);
      final fetchAllProductsResponseData = json.decode(fetchAllProductsResponse.body) as Map<String, dynamic>;
      print("FETCH ALL RESPONSE:");
      print(fetchAllProductsResponseData);
      if (fetchAllProductsResponse.statusCode >= 400) {
        throw HttpException(message: fetchAllProductsResponse.body);
      }

      final List<Product> loadedProducts = [];
      // ignore: unnecessary_null_comparison
      if (fetchAllProductsResponseData == null || fetchAllProductsResponseData.isEmpty) {
        //if backend returns null or empty, return to prevent further function execution
        return;
      }
      List<String?> favoritesId = [];
      if (userID!.isNotEmpty) {
        final favoritesData = await http.get(Uri.parse(databaseURL + "userFavorites/$userID.json?auth=$authToken"));
        print("FAVOURITES STUFF");
        print(favoritesData.body);
        print("FAV DATA DECODED");

        try {
          final favDataDecoded = json.decode(favoritesData.body) as Map<String, dynamic>;
          print(favDataDecoded);
          if (favDataDecoded != null && favDataDecoded.isNotEmpty) {
            print("ALL GOOD HERE, LESSGO");
            favDataDecoded.forEach((key, value) {
              favoritesId.add(key);
            });
          }
        } catch (error) {
          print(error);
          print("favs prolly empty");
          favoritesId = [];
        }
      }

      fetchAllProductsResponseData.forEach((productID, productData) {
        loadedProducts.add(Product(
            title: productData['title'],
            description: productData['description'],
            id: productID,
            imageUrl: productData['imageUrl'],
            price: productData['price'],
            isFavorite: favoritesId.contains(productID)

            // isFavorite: productData['isFavorite'],
            ));
      });

      _items = loadedProducts;
    } catch (error) {
      print("ERROR THROWN: SOMETHING WENT WRONG HERE 1");
      rethrow;
    }
    if (filterByUser && userID.isNotEmpty) {
      try {
        final fetchUserAddedProductsResponse = await http.get(fetchUserAddedProductsUrl);
        final fetchUserAddedProductsData = json.decode(fetchUserAddedProductsResponse.body) as Map<String, dynamic>;
        // print("FETCH ADDED PRODUCTS RESPONSE DATA:");
        // print(fetchUserAddedProductsData);
        if (fetchUserAddedProductsResponse.statusCode >= 400) {
          throw HttpException(message: fetchUserAddedProductsResponse.body);
        }
        // ignore: unnecessary_null_comparison
        if (fetchUserAddedProductsResponse == null || fetchUserAddedProductsData.isEmpty) {
          //if backend returns null or empty, return to prevent further function execution
          return;
        }
        List<Product> loadedProducts = [];
        fetchUserAddedProductsData.forEach((productID, productData) {
          loadedProducts.add(Product(
            title: productData['title'],
            description: productData['description'],
            id: productID,
            imageUrl: productData['imageUrl'],
            price: productData['price'],

            // isFavorite: productData['isFavorite'],
          ));
        });
        _userAddedItems = loadedProducts;
      } catch (error) {
        rethrow;
      }
    }

    notifyListeners();
  }

//TODO: each user will have their own list of products they have added to the store, so updates, additions and deletions should be done in that subset of user added produts rather than searching through all of the products.

  Future<void> deleteProduct(String productID) async {
    //function to delete product from the list of items, matched by product ID
    final url = Uri.parse(databaseURL + "products/$productID.json?auth=$authToken");
    final productIndex = _items.indexWhere((element) => element.id == productID);
    Product? existingProduct = _items[productIndex];
    _items.removeAt(productIndex);

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(productIndex, existingProduct);
      notifyListeners();
      throw HttpException(message: 'Could not delete product');
    }

    existingProduct = null;
    notifyListeners();
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);

    if (prodIndex >= 0) {
      final url = Uri.parse(databaseURL + "products/$id.json?auth=$authToken");
      try {
        final response = await http.patch(url, body: jsonEncode(newProduct.toJson()));
        if (response.statusCode >= 400) {
          throw HttpException(message: "Request could not be completed\nError ${response.statusCode}");
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
