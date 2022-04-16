import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {
  const CartItem({Key? key, required this.id, required this.title, required this.price, required this.quantity}) : super(key: key);
  final String id, title;
  final double price;
  final double quantity;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ListTile(
          leading: CircleAvatar(
            child: Text("\$$price"),
          ),
          title: Text("Total: \$${price * quantity}"),
          trailing: Text("$quantity x"),
        ),
      ),
    );
  }
}
