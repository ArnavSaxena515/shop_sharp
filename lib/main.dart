import 'package:flutter/material.dart';
import 'package:shop_sharp/providers/cart.dart';
import 'package:shop_sharp/providers/orders.dart';
import 'package:shop_sharp/screens/cart_screen.dart';
import 'package:shop_sharp/screens/orders_screen.dart';
import 'package:shop_sharp/screens/product_detail_screen.dart';
import '/screens/product_overview.dart';
import './providers/products_provider.dart';
import 'package:provider/provider.dart';

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
          create: (context) => Products(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Orders(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.purple,
          fontFamily: 'Lato',
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple).copyWith(
            secondary: Colors.deepOrange,
          ),
        ),
        home: const ProductOverview(),
        routes: {
          ProductDetail.routeName: (ctx) => const ProductDetail(),
          CartScreen.routeName: (ctx) => const CartScreen(),
          ProductOverview.routeName: (ctx) => const ProductOverview(),
          OrdersScreen.routeName: (ctx) => const OrdersScreen(),
        },
      ),
    );
  }
}
