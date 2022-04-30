import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_sharp/providers/auth.dart';
import 'package:shop_sharp/screens/auth_screen.dart';
import 'package:shop_sharp/screens/edit_products_screen.dart';
import 'package:shop_sharp/screens/splash_screen.dart';
import 'package:shop_sharp/widgets/indicators.dart';

import '/providers/cart.dart';
import '/providers/orders.dart';
import '/screens/cart_screen.dart';
import '/screens/orders_screen.dart';
import '/screens/product_detail_screen.dart';
import '/screens/user_products_screen.dart';
import '/screens/product_overview.dart';
import './providers/products_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //MultiProvider to set up multiple providers across the app (Products and Cart), set up at the top of the widget tree to be accessible across the app.
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (ctx) => Products(),
          update: (context, auth, previousProducts) {
            return Products()
              ..authTokenSetter = auth.token
              ..itemsSetter = previousProducts!.items;
          },
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (ctx) => Orders(),
          update: (context, auth, previousOrders) {
            return Orders()
              ..authTokenSetter = auth.token
              ..ordersSetter = previousOrders!.orders
              ..userIdSetter = auth.userId;
          },
        ),
      ],
      child: Consumer<Auth>(
          builder: (context, auth, _) => MaterialApp(
                theme: ThemeData(
                  primaryColor: Colors.purple,
                  fontFamily: 'Lato',
                  colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple).copyWith(
                    secondary: Colors.deepOrange,
                  ),
                ),
                home: auth.isAuthenticated // if user is authenticated in the auth auto login method, this will be true and user taken to productsOverview screen
                    ? const ProductOverview()
                    : FutureBuilder(
                        future: auth.autoLogin(), // the future will depend on the result provided by the automatic login method;
                        builder: (_, authSnapshot) => authSnapshot.connectionState == ConnectionState.waiting // if state is waiting, sho loading screen
                            ? const AppSplashScreen()
                            : const AuthScreen()), //if autologin returns false, load this screen
                routes: {
                  //all the app screens declared in the routes table
                  ProductDetail.routeName: (ctx) => const ProductDetail(),
                  CartScreen.routeName: (ctx) => const CartScreen(),
                  ProductOverview.routeName: (ctx) => const ProductOverview(),
                  OrdersScreen.routeName: (ctx) => const OrdersScreen(),
                  UserProductScreen.routeName: (ctx) => const UserProductScreen(),
                  EditProductScreen.routeName: (ctx) => const EditProductScreen(),
                  AuthScreen.routeName: (ctx) => const AuthScreen(),
                },
              )),
    );
  }
}
