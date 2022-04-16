import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../widgets/cart_item_gesture_handler.dart';

//Sccreen to display a user's cart with details of items they shopped and total costs
class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);
  static const routeName = "/cart-screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart"),
      ),
      body: Consumer<Cart>(
        builder: (BuildContext context, cart, Widget? child) => Column(
          children: [
            Card(
              margin: const EdgeInsets.all(15),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(fontSize: 20),
                    ),
                    // const SizedBox(
                    //   width: 10,
                    // ),
                    const Spacer(),
                    Chip(
                      backgroundColor: Theme.of(context).primaryColor,
                      label: Text(
                        "\$ ${cart.totalAmount.toStringAsFixed(2)}",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "ORDER NOW",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      // style: ButtonStyleStyle(color: Theme.of(context).primaryColor),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (_, index) {
                  final cartItem = cart.items.values.toList()[index];
                  return CartItemGestureHandler(cartItem: cartItem);
                },
                itemCount: cart.cartCount,
              ),
            )
          ],
        ),
      ),
    );
  }
}
