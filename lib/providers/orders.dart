import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_complete_guide/providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double total;
  final List<CartItem> cartItems;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.total,
    @required this.cartItems,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;
  final String userId;

  Orders(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.parse(
        'https://shopapp-98f68-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
    final res = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(res.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((ordId, ordItem) {
      loadedOrders.add(
        OrderItem(
          id: ordId,
          total: ordItem['total'],
          cartItems: (ordItem['cartItems'] as List<dynamic>)
              .map(
                (cItem) => CartItem(
                    id: cItem['id'],
                    title: cItem['title'],
                    quantity: cItem['quantity'],
                    price: cItem['price']),
              )
              .toList(),
          dateTime: DateTime.parse(ordItem['dateTime']),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartItems, double total) async {
    final url = Uri.parse(
        'https://shopapp-98f68-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
    final timestamp = DateTime.now();
    final res = await http.post(url,
        body: json.encode({
          'total': total,
          'dateTime': timestamp.toIso8601String(),
          'cartItems': cartItems
              .map((cItem) => {
                    'id': cItem.id,
                    'title': cItem.title,
                    'quantity': cItem.quantity,
                    'price': cItem.price
                  })
              .toList(),
        }));
    _orders.insert(
      0,
      OrderItem(
        id: jsonDecode(res.body)['name'],
        total: total,
        cartItems: cartItems,
        dateTime: timestamp,
      ),
    );
    notifyListeners();
  }
}
