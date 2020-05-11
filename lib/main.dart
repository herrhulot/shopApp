import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/auth.dart';
import 'package:provider/provider.dart';

import './screens/cart_screen.dart';
import './screens/user_products_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/orders_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';

import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/auth.dart';

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
            create: (ctx) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            update: (ctx, auth, previousProducts) => Products(
                auth.token,
                auth.userId,
                previousProducts == null ? [] : previousProducts.items),
            create: (_) => Products('', '', []),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            update: (ctx, auth, previousOrders) => Orders(auth.token,
                previousOrders == null ? [] : previousOrders.orders),
            create: (_) => Orders('', []),
          )
        ],
        child: Consumer<Auth>(
            builder: (ctx, auth, _) => MaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: 'MyShop',
                    theme: ThemeData(
                      primarySwatch: Colors.blueGrey,
                      accentColor: Colors.deepOrange,
                      fontFamily: 'Lato',
                    ),
                    home: auth.isAuth ? ProductsOverviewScreen() : AuthScreen(),
                    routes: {
                      ProductDetailScreen.routeName: (lemur) =>
                          ProductDetailScreen(),
                      CartScreen.routeName: (utter) => CartScreen(),
                      OrdersScreen.routeName: (vessla) => OrdersScreen(),
                      UserProductsScreen.routeName: (groundhog) =>
                          UserProductsScreen(),
                      EditProductScreen.routeName: (hund) =>
                          EditProductScreen(),
                    })));
  }
}
