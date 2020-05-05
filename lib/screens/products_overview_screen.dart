import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

import '../screens/cart_screen.dart';
import '../widgets/app_drawer.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';

enum FilterOptions {
  ShowFavorites,
  ShowAll,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showFavoritesOnly = false;

  @override
  Widget build(BuildContext context) {
    // Below was using the app-wide state approach.
    // final productsData = Provider.of<Products>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('MotorCycleShop-App'),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              // Below was using the app-wide state approach.
              setState(
                () {
                  if (selectedValue == FilterOptions.ShowFavorites) {
                    _showFavoritesOnly = true;
                  } else {
                    _showFavoritesOnly = false;
                  }
                },
              );
            },
            // icon: Icon(Icons.motorcycle),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only favorites'),
                value: FilterOptions.ShowFavorites,
              ),
              PopupMenuItem(
                child: Text('Show all'),
                value: FilterOptions.ShowAll,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: ProductsGrid(_showFavoritesOnly),
    );
  }
}
