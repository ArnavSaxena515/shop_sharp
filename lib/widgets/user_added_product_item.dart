//Display widget to display the user all the items that they have addded to the shop and are selling
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_sharp/providers/products_provider.dart';
import 'package:shop_sharp/screens/edit_products_screen.dart';

import '../providers/product.dart';

class UserAddedProductItem extends StatelessWidget {
  const UserAddedProductItem({Key? key, required this.product}) : super(key: key);
  final Product product;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(product.title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              //edit item
              //id passed as args to edit screen so that details are updated of the existing product item
              onPressed: () => Navigator.of(context).pushNamed(EditProductScreen.routeName, arguments: product.id),
              icon: const Icon(
                Icons.edit,
              ),
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              onPressed: () {
                Provider.of<Products>(context, listen: false).deleteProduct(product.id);
              },
              icon: const Icon(Icons.delete),
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
