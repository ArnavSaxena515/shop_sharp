import 'package:flutter/material.dart';
import 'package:shop_sharp/screens/product_detail.dart';
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
    return ChangeNotifierProvider(
      create: (context) => Products(),
      child: MaterialApp(
        theme: ThemeData(fontFamily: 'Lato', colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple).copyWith(secondary: Colors.deepOrange)),
        home: ProductOverview(),
        routes: {
          ProductDetail.routeName: (ctx) => const ProductDetail(),
        },
      ),
    );
  }
}

// class Home extends StatelessWidget {
//   const Home({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Shop Sharp"),
//       ),
//       body: ProductOverview(
//         productsList: [],
//       ),
//     );
//   }
// }
