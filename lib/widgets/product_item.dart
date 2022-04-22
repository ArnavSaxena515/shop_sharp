import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/screens/product_detail_screen.dart';
import '../providers/cart.dart';
import '../providers/product.dart';

//Widget to display a product's detail in the product overview screen's grid.
class ProductItem extends StatelessWidget {
  const ProductItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Product product = Provider.of<Product>(context, listen: false); //using consumer instead to only rebuild what actually can change
    final Cart cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, ProductDetail.routeName, arguments: product.id);
            //On tapping the image the user is taken to a screen where the details of the selected
            //product are displayed
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: Text(
            product.title,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          leading: Consumer<Product>(
            //Consumer widget to access the Product provider which contains the details of the product user selected
            builder: (BuildContext context, value, Widget? child) => IconButton(
              icon: Icon(
                value.checkFavorite() ? Icons.favorite : Icons.favorite_border,
                color: Colors.deepOrange,
                //color: Colors.white,
              ),
              onPressed: () {
                value.toggleFavorite();
              },
            ),
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.add_shopping_cart_rounded,
              color: Theme.of(context).colorScheme.secondary,
            ),
            onPressed: () {
              cart.addItem(productID: product.id, price: product.price, title: product.title);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  // ui element to give more useful information to the user
                  content: Text(
                    "Added ${product.title} to cart",
                  ),
                  duration: const Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      cart.decreaseQuantity(product.id);
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          "Removed ${product.title} from cart",
                        ),
                        duration: const Duration(seconds: 2),
                      ));
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
