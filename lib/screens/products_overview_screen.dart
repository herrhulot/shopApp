import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/products.dart';
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
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    // You can't use 'context' in initState. Unless you use 'listen: false'. Then you dont need a workaround.
    //Provider.of<Products>(context).fetchAndSetProducts();

    // Workaround #1 - will be fast but order is different. Kind of an hack:
    /*  Future.delayed(Duration.zero).then((value) {
      Provider.of<Products>(context).fetchAndSetProducts();
    }); */
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // Workaround #2
    if (_isInit) {
      _isLoading = true;
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;

    super.didChangeDependencies();
  }

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
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showFavoritesOnly),
    );
  }
}
