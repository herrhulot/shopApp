import 'package:flutter/material.dart';

import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
    Product(
      id: 'p5',
      title: 'Big Foot',
      description: 'I\'m your friend!',
      price: 1000,
      imageUrl:
          'https://images-na.ssl-images-amazon.com/images/I/91SUFpRcoyL._AC_UL1500_.jpg',
    ),
    Product(
      id: 'p6',
      title: 'Wolf',
      description: 'I\'m wolf, love me!',
      price: 500,
      imageUrl:
          'https://cdn.pixabay.com/photo/2018/06/23/23/08/wolf-3493698_1280.jpg',
    ),
  ];

  // var _showFavoritesOnly = false;

  List<Product> get items {
    //   if (_showFavoritesOnly) {
    //     return _items.where((prodItem) => prodItem.isFavorite).toList();
    //   }
    return [..._items]; // ... betyder att det är en "spread"
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  // Below would be a good approach if we wanted [app-wide state]. Changing the settings in products_overview_screen
  // will change it in the whole app.
  // We want [widget-local state] so changing settings only changes state inside the products_overview_screen.

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  void addProduct(Product product) {
    final newProduct = Product(
        id: DateTime.now().toString(),
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl);
    _items.add(newProduct);
    // _items.insert(0, newProduct); At the start of the list

    notifyListeners();
  }
}
