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
    // productsData.favoriteItems.forEach((element) {
    //   element.printDetails();
    // });

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 3 / 2, mainAxisSpacing: 10, crossAxisSpacing: 10),
      itemCount: products.length,
      itemBuilder: (productOverviewScreenContext, index) {
        //products[index].printDetails();
        return ChangeNotifierProvider.value(key: UniqueKey(), value: products[index], child: const ProductItem());
      },
    );
  }
}
