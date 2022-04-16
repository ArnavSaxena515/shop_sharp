import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_sharp/providers/products_provider.dart';
import '../providers/cart.dart';
import '../providers/product.dart';
import '../widgets/badge.dart';
import 'cart_screen.dart';

class ProductDetail extends StatelessWidget {
  static const routeName = "/product-detail";

  const ProductDetail({Key? key}) : super(key: key);

//TODO finish this
  @override
  Widget build(BuildContext context) {
    String itemID = ModalRoute.of(context)!.settings.arguments as String;
    Product product = Provider.of<Products>(context).items.firstWhere((element) => element.id == itemID);
    int quantity = 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Shop Sharp"),
        actions: [
          Consumer<Cart>(
            builder: (BuildContext context, cart, Widget? child) {
              return Badge(
                value: cart.cartCount.toString(),
                //cart.cartCount.toString(),
                child: child ?? const Icon(Icons.shopping_cart),
                color: Theme.of(context).colorScheme.secondary,
              );
            },
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            child: Card(
              child: Column(
                children: [
                  Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    margin: const EdgeInsets.all(15),
                    child: ListTile(
                      title: Text(
                        product.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      subtitle: Container(
                        margin: const EdgeInsets.all(10),
                        child: Text(
                          "This is the product detail screen for ${product.description}",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      trailing: Text("\$${product.price.toString()}"),
                    ),
                  ),
                  QuantitySetter(
                    itemID: itemID,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QuantitySetter extends StatelessWidget {
  const QuantitySetter({
    Key? key,
    required this.itemID,
  }) : super(key: key);
  final String itemID;

  @override
  Widget build(BuildContext context) {
    int quantity = 0;
    Product product = Provider.of<Products>(context).items.firstWhere((element) => element.id == itemID);
    return Consumer<Cart>(
      builder: (_, cart, child) {
        if (cart.items.containsKey(itemID)) {
          quantity = cart.items[itemID]!.quantity;
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
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
