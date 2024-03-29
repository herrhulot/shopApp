import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity, // kwäntətē //
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    var totalItems = 0;
    _items.forEach((key, value) {
      totalItems += value.quantity;
    });
    return totalItems;
  }
  // return _items.length;
  // return _items == null ? 0 : _items.length;

  double get totalAmount {
    var total = 0.0;
    _items.forEach(
      (key, value) {
        total += value.price * value.quantity * 9.84;
      },
    );
    total = total.round().toDouble();
    return total;
  }

  void addItem({
    String productId,
    double price,
    String title,
  }) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem({String productId}) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].quantity > 1) {
      _items.update(
          productId,
          (existingCartItem) => CartItem(
                id: existingCartItem.id,
                title: existingCartItem.title,
                price: existingCartItem.price,
                quantity: existingCartItem.quantity - 1,
              ));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}

// final Map<String, CartItem> luderItems = {
//   'kuk': CartItem(id: null, title: null, quantity: null, price: null),
//   'röv': CartItem(id: null, title: null, quantity: null, price: null),
//   'fitta': CartItem(id: null, title: null, quantity: null, price: null),
// };
