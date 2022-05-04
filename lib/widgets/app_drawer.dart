//App drawer widget to be shared across all app screens where required

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '/screens/orders_screen.dart';
import '/screens/product_overview.dart';
import '/screens/user_products_screen.dart';
import '../screens/cart_screen.dart';
import 'drawer_button.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, //Does not pop the drawer if its not possible
          title: const Text("Welcome to Shop Sharp"),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            DrawerButton(
              buttonTitle: "Shop",
              //routeName: ProductOverview.routeName,
              leadingWidget: const Icon(Icons.store),
              onTap: () => Navigator.of(context)
                  .pushReplacementNamed(ProductOverview.routeName)
                  .then((value) => Navigator.of(context).pop()), // Replace the screen with shop section
            ),
            DrawerButton(
              buttonTitle: "Past Orders",
              //  routeName: OrdersScreen.routeName,
              leadingWidget: const Icon(Icons.payment),
              onTap: () => Navigator.of(context).pushNamed(OrdersScreen.routeName).then((value) => Navigator.of(context).pop()),

              // Navigator.of(context).push(CustomRoute(
              //   builder: (_) => const OrdersScreen(),
              // ))
              // Push the orders screen and pop drawer once app returns from the orders screen
            ),
            DrawerButton(
                buttonTitle: "Cart",
                // routeName: CartScreen.routeName,
                leadingWidget: const Icon(Icons.shopping_cart),
                onTap: () => Navigator.of(context).pushNamed(CartScreen.routeName).then(
                      (value) => Navigator.of(context).pop(),
                    )
                // Push the cart screen on the navigator stack and pop once the cart screen is dismissed,
                ),
            DrawerButton(
              buttonTitle: "User Added Products",
              //  routeName: UserProductScreen.routeName,
              leadingWidget: const Icon(Icons.sell),
              onTap: () => Navigator.of(context).pushNamed(UserProductScreen.routeName).then(
                    (value) => Navigator.of(context).pop(),
                  ),
            ),
            DrawerButton(
                buttonTitle: "Logout",
                leadingWidget: const Icon(Icons.logout_sharp),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacementNamed('/');
                  Provider.of<Auth>(context, listen: false).logout();
                }),
          ],
        ),
      ),
    );
  }
}
