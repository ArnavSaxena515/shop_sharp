// Display the details of past orders

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_sharp/providers/orders.dart';

import '../widgets/order_display.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);
  static const routeName = '/orders-screen';

  @override
  Widget build(BuildContext context) {
    final List<OrderItem> orders = Provider.of<Orders>(context).orders;
    bool isOrdersEmpty = orders.isEmpty;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Orders"),
      ),
      body: isOrdersEmpty
          ? const Center(
              child: Text("You have no orders yet"),
            )
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (ctx, index) => OrderDisplay(
                orderItem: orders[index],
              ),
            ),
    );
  }
}
