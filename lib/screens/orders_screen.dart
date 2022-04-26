// Display the details of past orders

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_sharp/widgets/indicators.dart';

import '/providers/orders.dart';
import '../widgets/order_display.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);
  static const routeName = '/orders-screen';

  Future<void> fetchAndUpdate(BuildContext context) async {
    await Provider.of<Orders>(context, listen: false).fetchAndUpdateOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Your Orders"),
        ),
        body: FutureBuilder(
          future: fetchAndUpdate(context),
          builder: (ctx, dataSnapShot) {
            if (dataSnapShot.connectionState == ConnectionState.waiting) {
              return const LoadingIndicator(
                loadingMessage: "Fetching your past orders",
              );
            } else {
              if (dataSnapShot.error != null) {
                return const ErrorIndicator(errorMessage: "Something went wrong. Please try again");
              } else {
                return Consumer<Orders>(
                  builder: (_, orders, __) {
                    return ListView.builder(
                      itemCount: orders.orders.length,
                      itemBuilder: (ctx, index) => OrderDisplay(
                        orderItem: orders.orders[index],
                      ),
                    );
                  },
                );
              }
            }
          },
        ));
  }
}
