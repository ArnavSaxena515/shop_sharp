import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_sharp/providers/products_provider.dart';
import 'package:shop_sharp/widgets/app_drawer.dart';
import 'package:shop_sharp/widgets/user_added_product_item.dart';

class UserProductScreen extends StatelessWidget {
  const UserProductScreen({Key? key}) : super(key: key);
  static const String routeName = '/user-products-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text("Your Products"), //todo display username
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.add_circle_sharp,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Consumer<Products>(
          builder: (_, products, child) {
            return ListView.builder(
                itemCount: products.items.length,
                itemBuilder: (ctx, index) => Column(
                      children: [
                        UserAddedProductItem(product: products.items[index]),
                        const Divider(),
                      ],
                    ));
          },
        ),
      ),
    );
  }
}
