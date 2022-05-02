// Widget to display details of past orders placed

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/order_item.dart';
import '/models/cart_item.dart';

class OrderDisplay extends StatefulWidget {
  const OrderDisplay({Key? key, required this.orderItem}) : super(key: key);
  final OrderItem orderItem;

  @override
  State<OrderDisplay> createState() => _OrderDisplayState();
}

class _OrderDisplayState extends State<OrderDisplay> {
  bool expanded = false; // controls if the details of the order are displayed in detail or not

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => setState(() {
        expanded = !expanded; //if expanded, details displayed
      }),
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text("Amount Paid:\t\t\$${widget.orderItem.amount.toStringAsFixed(2)}"),
              subtitle: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(DateFormat('dd/MM/yyyy\t\thh:mm').format(widget.orderItem.dateTime)), //Date time format display
              ),
              trailing: Icon(
                // onPressed: () => setState(() {
                //   expanded = !expanded; //if expanded, details displayed
                // }),
                expanded ? Icons.expand_less : Icons.expand_more,
              ),
            ),
            AnimatedContainer(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
              height: expanded ? min(widget.orderItem.products.length * 20.0 + 10.0, 100.0) : 0,
              // minimum of 100 or the other calculated value to
              // restrict the height of the list of the order details
              constraints: BoxConstraints(
                minHeight: expanded ? min(widget.orderItem.products.length * 20.0 + 10.0, 100.0) : 0,
              ),
              duration: const Duration(milliseconds: 150),
              child: ListView.builder(
                  itemCount: widget.orderItem.products.length,
                  itemBuilder: (_, index) {
                    final CartItem cartItems = widget.orderItem.products[index];
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${cartItems.quantity}x  ${cartItems.title}",
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "\$${cartItems.price}",
                          style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),
                        ),
                      ],
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
