import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/orders.dart';

import '../providers/cart.dart';
import '../widgets/cart_item_gesture_handler.dart';

//Screen to display a user's cart with details of items they shopped and total costs
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
                    Chip(
                      backgroundColor: Theme.of(context).primaryColor,
                      label: Text(
                        "Total:\t\$${cart.totalAmount.toStringAsFixed(2)}",
                        style: const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    const Spacer(),
                    Visibility(
                      visible: cart.items.values.isNotEmpty,
                      child: AbsorbPointer(
                        absorbing: cart.items.values.isEmpty,
                        child: TextButton(
                          onPressed: () {
                            Provider.of<Orders>(context, listen: false).addOrder(cart.items.values.toList(), cart.totalAmount);
                            cart.clearCart();
                            showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                      backgroundColor: Theme.of(context).primaryColor,
                                      content: const Text(
                                        "Order Placed!\n Thank you for shopping with us",
                                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                      ),
                                      //todo show order summary or something
                                    )).then((value) => Navigator.of(context).pop());
                          },
                          child: const Text(
                            "ORDER NOW",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          // style: ButtonStyleStyle(color: Theme.of(context).primaryColor),
                        ),
                      ),
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
//todo: when quantity reduced to 0, remove item from ui
