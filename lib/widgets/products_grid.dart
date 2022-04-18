import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/providers/products_provider.dart';
import '/widgets/product_item.dart';

//widget to display all products in a grid layout
class ProductsGrid extends StatelessWidget {
  const ProductsGrid({Key? key, required this.showFavorites}) : super(key: key);
  final bool showFavorites;

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = showFavorites ? productsData.favoriteItems : productsData.items;

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 3 / 2, mainAxisSpacing: 10, crossAxisSpacing: 10),
      itemCount: products.length,
      itemBuilder: (productOverviewScreenContext, index) => ChangeNotifierProvider.value(
        //Grid items wrapped by a provider.value to provide them the product details from the items available.
        value: products[index],
        child: const ProductItem(),
      ),
    );
  }
}
