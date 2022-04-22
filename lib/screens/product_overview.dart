// Display the items in shop in a grid form

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/screens/cart_screen.dart';
import '/widgets/app_drawer.dart';
import '../providers/cart.dart';
import '../widgets/badge.dart';
import '../widgets/products_grid.dart';

enum FilterOptions { favorites, all }

class ProductOverview extends StatefulWidget {
  const ProductOverview({
    Key? key,
  }) : super(key: key);
  static const routeName = '/product-overview';

  @override
  State<ProductOverview> createState() => _ProductOverviewState();
}

class _ProductOverviewState extends State<ProductOverview> {
  // final List<Product> loadedProducts;
  bool _showFavorites = false;

  @override
  Widget build(BuildContext context) {
    // final Cart cart = Provider.of<Cart>(context);
    return Scaffold(
        drawer: const AppDrawer(),
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
                    ]),
            Consumer<Cart>(
              builder: (BuildContext context, cart, Widget? child) {
                return Badge(
                  value: cart.cartCount.toString(),
                  //cart.cartCount.toString(),
                  child: child ?? const Icon(Icons.shopping_cart),
                  color: Theme.of(context).colorScheme.secondary,
                );
              },
              child: IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: ProductsGrid(
            showFavorites: _showFavorites,
          ),
        )
        //body: ListViewBuilder(),
        );
  }
}

// class ListViewBuilder extends StatefulWidget {
//   const ListViewBuilder({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   State<ListViewBuilder> createState() => _ListViewBuilderState();
// }
//
// class _ListViewBuilderState extends State<ListViewBuilder> {
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: DUMMY_PRODUCTS.length,
//       itemBuilder: (productOverviewScreenContext, index) => Card(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: ListTile(
//             leading: Image.network(
//               DUMMY_PRODUCTS[index].imageUrl,
//               fit: BoxFit.cover,
//               width: 100,
//               height: 100,
//             ),
//             title: Text(DUMMY_PRODUCTS[index].title),
//             subtitle: Text("SUBTITLE"),
//             trailing: Column(
//               //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 IconButton(
//                   icon: Icon(
//                     DUMMY_PRODUCTS[index].checkFavorite() ? Icons.favorite : Icons.favorite_border,
//                     //color: Colors.white,
//                   ),
//                   onPressed: () {},
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.shopping_cart),
//                   onPressed: () {},
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
