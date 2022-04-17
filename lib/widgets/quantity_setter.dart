// Widget to control the quantity of an item in the ItemDetails screen while placing orders

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/product.dart';
import '../providers/products_provider.dart';

class QuantitySetter extends StatelessWidget {
  const QuantitySetter({
    Key? key,
    required this.itemID,
  }) : super(key: key);
  final String itemID;

  @override
  Widget build(BuildContext context) {
    int quantity = 0;
    Product product = Provider.of<Products>(context).items.firstWhere((element) {
      return element.id == itemID;
    });

    return Consumer<Cart>(
      builder: (_, cart, child) {
        if (cart.items.containsKey(itemID)) {
          quantity = cart.items[itemID]!.quantity;
        }
        return Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Selected Quantity"),
                  IconButton(
                      onPressed: () {
                        cart.decreaseQuantity(itemID);
                      },
                      icon: Icon(
                        Icons.remove_circle,
                        color: Theme.of(context).primaryColor,
                      )),
                  Text("${quantity.toString()}x"),
                  IconButton(
                      onPressed: () {
                        cart.addItem(productID: itemID, price: product.price, title: product.title);
                      },
                      icon: Icon(Icons.add_circle, color: Theme.of(context).primaryColor)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Item Total: \$${(quantity * product.price).toStringAsFixed(2)}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
