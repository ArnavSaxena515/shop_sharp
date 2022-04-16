import 'package:flutter/material.dart';

// Widget to display the details of a particular item in the user's cart along with its quantity.
class CartItemDisplay extends StatelessWidget {
  const CartItemDisplay({Key? key, required this.id, required this.title, required this.price, required this.quantity}) : super(key: key);
  final String id, title;
  final double price;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            radius: 30,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: FittedBox(
                child: Text(
                  "\$$price",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          subtitle: Text("Total: \$${price * quantity}"),
          title: Text(title),
          trailing: Text("$quantity x"),
        ),
      ),
    );
  }
}
