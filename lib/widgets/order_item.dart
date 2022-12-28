import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/cart.dart' show Cart;
import 'package:flutter_complete_guide/providers/orders.dart' as ord;
import 'package:flutter_complete_guide/widgets/cart_item.dart';
import 'package:intl/intl.dart';

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  const OrderItem(this.order);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('Total: \$${widget.order.total.toStringAsFixed(2)}'),
            subtitle: Text(
              DateFormat('dd/MM/yyyy - hh:mm a').format(widget.order.dateTime),
            ),
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
            ),
          ),
          AnimatedContainer(
            curve: Curves.easeInOutCubic,
            duration: Duration(milliseconds: 300),
            height: _expanded
                ? min(widget.order.cartItems.length * 20.0 + 100, 180)
                : 0,
            child: ListView(
              children: widget.order.cartItems
                  .map(
                    (prod) => OrderedProductItem(
                      title: prod.title,
                      price: prod.price,
                      quantity: prod.quantity,
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderedProductItem extends StatelessWidget {
  const OrderedProductItem({
    Key key,
    this.title,
    this.price,
    this.quantity,
  }) : super(key: key);

  final String title;
  final double price;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    return Card(
      // shape: RoundedRectangleBorder(
      //   side: BorderSide(width: 0.),
      // ),
      margin: EdgeInsets.all(10),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text('Price: ${price}'),
                Text('Total Price: ${price * quantity}'),
              ],
            ),
            Text('${quantity} x')
          ],
        ),
      ),
    );
  }
}

// CartItem(
//                           id: prod.id,
//                           title: prod.title,
//                           quantity: prod.quantity,
//                           price: prod.price))
//                       .toList())