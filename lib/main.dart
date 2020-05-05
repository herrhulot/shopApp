import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/cart_screen.dart';
import './screens/user_products_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/orders_screen.dart';
import './screens/edit_product_screen.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Here we use Products() with create method. Because here we "instanciate" class Products().
    // "instanciate" means we create a new object from the class Products().
    // If we use "value" here it can produce bugs and decrease performance.
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Orders(),
        )
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.blueGrey,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          home: ProductsOverviewScreen(),
          routes: {
            ProductDetailScreen.routeName: (lemur) => ProductDetailScreen(),
            CartScreen.routeName: (utter) => CartScreen(),
            OrdersScreen.routeName: (vessla) => OrdersScreen(),
            UserProductsScreen.routeName: (groundhog) => UserProductsScreen(),
            EditProductScreen.routeName: (hund) => EditProductScreen(),
          }),
    );
  }
}
