import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_sharp/providers/products_provider.dart';
import '../providers/product.dart';

class ProductDetail extends StatelessWidget {
  static const routeName = "/product-detail";
  const ProductDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String itemID = ModalRoute.of(context)!.settings.arguments as String;
    Product product = Provider.of<Products>(context).items.firstWhere((element) => element.id == itemID);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: Text("This is the product detail screen for ${product.description}"),
    );
  }
}
