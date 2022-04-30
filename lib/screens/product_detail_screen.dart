//Display the details of a tapped product on the screen

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/providers/products_provider.dart';
import '../providers/cart.dart';
import '../providers/product.dart';
import '../widgets/badge.dart';
import '../widgets/quantity_setter.dart';
import 'cart_screen.dart';

class ProductDetail extends StatelessWidget {
  static const routeName = "/product-detail";

  const ProductDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String itemID = ModalRoute.of(context)!.settings.arguments as String;
    Product product = Provider.of<Products>(context).items.firstWhere((element) => element.id == itemID);
    //product.printDetails();
    //print("Description: ${product.description}");
    //provider to get the product details of the nearest product in the widget tree
    final AppBar appBar = AppBar();
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
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
                  GestureDetector(
                    //If tapped, animation executed and the image takes over the screen for a zoomed view
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                        return ImageDisplay(
                          imageUrl: product.imageUrl,
                          productTitle: product.title,
                        );
                      }));
                    },
                    child: Hero(
                      tag: 'imageHero',
                      child: Image.network(
                        product.imageUrl,
                        fit: BoxFit.cover,
                        height: (mediaQuery.size.height - appBar.preferredSize.height - mediaQuery.padding.top) * 0.5,
                      ),
                    ),
                  ),
                  Container(
                    height: (mediaQuery.size.height - appBar.preferredSize.height - mediaQuery.padding.top) * 0.1,
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
                          product.description,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                      trailing: Text("\$${product.price.toString()}"),
                    ),
                  ),
                  SizedBox(
                    height: (mediaQuery.size.height - appBar.preferredSize.height - mediaQuery.padding.top) * 0.15,
                    child: QuantitySetter(
                      itemID: itemID,
                    ),
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

class ImageDisplay extends StatelessWidget {
  const ImageDisplay({Key? key, required this.imageUrl, required this.productTitle}) : super(key: key);
  final String imageUrl;
  final String productTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(productTitle),
      ),
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: Image.network(
              imageUrl,
            ),
          ),
        ),
      ),
    );
  }
}
