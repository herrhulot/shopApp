import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get order {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    const url = 'https://shopapploandbehold.firebaseio.com/orders.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<OrderItem> loadedOrders = [];

      extractedData.forEach((orderId, orderData) {
        loadedOrders.add(OrderItem(
          id: 'slkjdsljskdsd',
          amount: 330.3,
          dateTime: DateTime.now(),
          products: [
            CartItem(
              id: 'someId',
              title: 'someTitle',
              quantity: 5,
              price: 39,
            )
          ], // TODO: Ev. omvandla till CartItems
        ));
      });
      _orders = loadedOrders;
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    const url = 'https://shopapploandbehold.firebaseio.com/orders.json';

    final cartProductsMaps = [];

    cartProducts.forEach((prod) {
      cartProductsMaps.add({
        'id': prod.id,
        'title': prod.title,
        'quantity': prod.quantity,
        'price': prod.price,
      });
    });

    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateTime': DateTime.now().toString(),
          'products': cartProductsMaps,
        }));

    final newOrder = OrderItem(
      id: json.decode(response.body)['name'],
      amount: total,
      dateTime: DateTime.now(),
      products: cartProducts,
    );

    _orders.insert(
      0,
      newOrder,
    );
    notifyListeners();
  }
  /* void addOrder(List<CartItem> cartProducts, double total) {
    _orders.insert(
      0,
      OrderItem(
        id: DateTime.now().toString(),
        amount: total,
        dateTime: DateTime.now(),
        products: cartProducts,
      ),
    );
    notifyListeners();
  } */
}
