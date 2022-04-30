// Display the items in shop in a grid form

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../providers/products_provider.dart';
import '../widgets/indicators.dart';
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

  bool _isInit = false;
  bool _isLoading = false;
  bool _dataLoaded = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Future<void> didChangeDependencies() async {
    if (!_isInit) {
      // method to fetch items from the backend.
      //
      // Provider.of<Products>(context).fetchAndSetProducts().catchError((error) {
      //   return showDialog(
      //       context: context,
      //       builder: (_) => AlertDialog(
      //             title: const Text("Error Loading Products"),
      //             content: const Text("Products could not be loaded. Please try again later"),
      //             actions: [
      //               TextButton(
      //                   onPressed: () {
      //                     Navigator.of(context).pop();
      //                   },
      //                   child: const Text("Okay"))
      //             ],
      //           ));
      // });

      try {
        setState(() {
          _isLoading = true;
        });
        final authData = Provider.of<Auth>(context, listen: false);
        await Provider.of<Products>(context).fetchAndSetProducts(userID: authData.userId).then((value) => _dataLoaded = true);
      } catch (error) {
        print("\n\n\nERROR FROM OVERVIEW");
        print(error);
        _dataLoaded = false;
        //print(error);
        // ignore: prefer_void_to_null
        showDialog<Null>(
            context: context,
            builder: (_) => AlertDialog(
                  title: const Text("Error Loading Products"),
                  content: const Text("Products could not be loaded. Please try again later"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Okay"))
                  ],
                ));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }

    _isInit = true;
    super.didChangeDependencies();
  }

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
        body: _isLoading
            ? const LoadingIndicator()
            : _dataLoaded
                ? Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: ProductsGrid(
                      showFavorites: _showFavorites,
                    ),
                  )
                : const ErrorIndicator()
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
