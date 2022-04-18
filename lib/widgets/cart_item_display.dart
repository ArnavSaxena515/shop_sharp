import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/product.dart';
import '../providers/products_provider.dart';

// Widget to display the details of a particular item in the user's cart along with its quantity.
class CartItemDisplay extends StatelessWidget {
  const CartItemDisplay({
    Key? key,
    required this.productID,
    required this.id,
    required this.title,
    required this.price,
    required this.quantity,
  }) : super(key: key);
  final String id, title, productID;
  final double price;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        child: ListTile(
          leading: Consumer<Products>(
            //Consumer to access Products provider across this widget
            builder: (_, products, child) {
              final Product product = products.findByID(productID);
              return CircleAvatar(
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(15),
                // ),
                // height: 100,
                // width: 100,
                radius: 30,
                backgroundImage: NetworkImage(
                  product.imageUrl,
                  //  fit: BoxFit.cover,
                ),
              );
            },
          ),
          subtitle: SizedBox(
            width: mediaQuery.size.width * 0.2,
            child: Text(
              "Total: \$${price * quantity}",
            ),
          ),
          title: SizedBox(
            child: Text(title),
            width: mediaQuery.size.width * 0.2,
          ),
          trailing: SizedBox(
            width: mediaQuery.size.width * 0.3,
            child: Consumer<Cart>(
              //Consumer to access Cart provider across this widget
              builder: (_, cart, child) => Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        cart.decreaseQuantity(productID);
                      },
                      icon: Icon(
                        Icons.remove_circle,
                        color: Theme.of(context).primaryColor,
                      )),
                  child ??
                      Text(
                        "$quantity x",
                      ),
                  IconButton(
                      onPressed: () {
                        cart.addItem(productID: productID, price: price, title: title);
                      },
                      icon: Icon(Icons.add_circle, color: Theme.of(context).primaryColor)),
                ],
              ),
              child: Text("$quantity x"),
            ),
          ),
        ),
      ),
    );
  }
}
