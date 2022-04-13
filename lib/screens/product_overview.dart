import 'package:flutter/material.dart';
import 'package:shop_sharp/dummy_data.dart';

import '../widgets/products_grid.dart';

enum FilterOptions { favorites, all }

class ProductOverview extends StatefulWidget {
  const ProductOverview({
    Key? key,
  }) : super(key: key);

  @override
  State<ProductOverview> createState() => _ProductOverviewState();
}

class _ProductOverviewState extends State<ProductOverview> {
  // final List<Product> loadedProducts;
  bool _showFavorites = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Shop Sharp"),
          actions: [
            PopupMenuButton(
                onSelected: (FilterOptions selectedValue) {
                  setState(() {
                    if (selectedValue == FilterOptions.favorites) {
                      _showFavorites = true;
                    } else if (selectedValue == FilterOptions.all) {
                      _showFavorites = false;
                    }
                  });
                },
                icon: const Icon(Icons.more_vert),
                itemBuilder: (_) => [
                      const PopupMenuItem(
                        child: Text(
                          "Only Favorites",
                        ),
                        value: FilterOptions.favorites,
                      ),
                      const PopupMenuItem(
                        child: Text(
                          "Show All",
                        ),
                        value: FilterOptions.all,
                      ),
                    ])
          ],
        ),
        body: ProductsGrid(
          showFavorites: _showFavorites,
        )
        //body: ListViewBuilder(),
        );
  }
}

class ListViewBuilder extends StatefulWidget {
  const ListViewBuilder({
    Key? key,
  }) : super(key: key);

  @override
  State<ListViewBuilder> createState() => _ListViewBuilderState();
}

class _ListViewBuilderState extends State<ListViewBuilder> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: DUMMY_PRODUCTS.length,
      itemBuilder: (productOverviewScreenContext, index) => Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: Image.network(
              DUMMY_PRODUCTS[index].imageUrl,
              fit: BoxFit.cover,
              width: 100,
              height: 100,
            ),
            title: Text(DUMMY_PRODUCTS[index].title),
            subtitle: Text("SUBTITLE"),
            trailing: Column(
              //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(
                    DUMMY_PRODUCTS[index].checkFavorite() ? Icons.favorite : Icons.favorite_border,
                    //color: Colors.white,
                  ),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
