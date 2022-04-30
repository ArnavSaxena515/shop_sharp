import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_sharp/screens/edit_products_screen.dart';
import 'package:shop_sharp/widgets/indicators.dart';

import '../providers/auth.dart';
import '/providers/products_provider.dart';
import '/widgets/app_drawer.dart';
import '/widgets/user_added_product_item.dart';

class UserProductScreen extends StatelessWidget {
  const UserProductScreen({Key? key}) : super(key: key);
  static const String routeName = '/user-products-screen';

  Future<void> _refreshProducts(BuildContext context, String? userId) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts(filterByUser: true, userID: userId);
  }

  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<Auth>(context);
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text("Your Products"), //todo display username
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed(EditProductScreen.routeName),
            icon: const Icon(
              Icons.add_circle_sharp,
            ),
          )
        ],
      ),
      body: FutureBuilder(
          future: _refreshProducts(context, authData.userId),
          builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting
              ? const LoadingIndicator()
              : RefreshIndicator(
                  onRefresh: () {
                    return _refreshProducts(context, authData.userId);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Consumer<Products>(
                      builder: (_, products, child) {
                        return ListView.builder(
                            itemCount: products.userAddedProducts.length,
                            itemBuilder: (ctx, index) {
                              return Column(
                                children: [
                                  UserAddedProductItem(product: products.userAddedProducts[index]),
                                  const Divider(),
                                ],
                              );
                            });
                      },
                    ),
                  ),
                )),
    );
  }
}
