//Widget to handle gestures on the cart display for cart screen

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart_item.dart';
import '../providers/cart.dart';
import '../screens/product_detail_screen.dart';
import 'cart_item_display.dart';

class CartItemGestureHandler extends StatelessWidget {
  const CartItemGestureHandler({
    Key? key,
    required this.cartItem,
  }) : super(key: key);

  final CartItem cartItem;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(ProductDetail.routeName, arguments: cartItem.productID),
      child: Consumer<Cart>(
        // Cart Consumer
        builder: (_, cart, child) => Dismissible(
          // widget that allows items to be dismissed from the UI
          confirmDismiss: (direction) {
            return showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                      title: const Text("Are you sure?"),
                      content: Text("Do you want to remove ${cartItem.title} from the cart?"),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            child: const Text("Yes")),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: const Text("No")),
                      ],
                    ));
          },
          onDismissed: (_) => cart.removeItem(id: cartItem.cartItemID),
          direction: DismissDirection.endToStart,
          // control swipe direction
          background: Container(
            color: Theme.of(context).errorColor,
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
            alignment: Alignment.centerRight,
          ),
          key: ValueKey(cartItem.cartItemID),
          //dismissible widget requires unique key to work, causes bugs otherwise
          child: child ??
              CartItemDisplay(title: cartItem.title, quantity: cartItem.quantity.toInt(), price: cartItem.price, id: cartItem.cartItemID, productID: cartItem.productID),
        ),
        child: CartItemDisplay(
          productID: cartItem.productID,
          title: cartItem.title,
          quantity: cartItem.quantity.toInt(),
          price: cartItem.price,
          id: cartItem.cartItemID,
        ),
      ),
    );
  }
}
