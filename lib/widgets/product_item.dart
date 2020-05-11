import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_detail_screen.dart';
import '../providers/product.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  // ProductItem(
  //   this.id,
  //   this.title,
  //   this.imageUrl,
  // );

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final scaffold = Scaffold.of(context);
    final authData = Provider.of<Auth>(context, listen: false);
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(ProductDetailScreen.routeName, arguments: product.id);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 10,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: GridTile(
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
            footer: GridTileBar(
              backgroundColor: Colors.black54,
              // Here we use a "Consumer<Product>()" with a "builder: (context, value, child) =>" because we only want to
              // rebuild the wrapped children. And not the whole widget tree. In this case the like button (❤️).
              // We also set "listen: false" in the surrounding "Provider.of<Product>()" further up the main build method.
              // This prevents the default behavior of rebuilding the whole widget tree when the data changes.
              // It also improves readability, showing where the widget trees depends on data changes.
              // If you want to have parts of the Consumer static (not rebuild when Consumer rebuilds), you can use the
              // "child" argument in the Consumer function. You then reference it in the "builder:" function using the
              // word "child:". If not using the child arguments a best practice is to name it "_" instead.
              leading: Consumer<Product>(
                builder: (context, value, child) => IconButton(
                  icon: product.isFavorite
                      ? Icon(Icons.favorite)
                      : Icon(Icons.favorite_border),
                  onPressed: () async {
                    try {
                      await product.toggleFavoriteStatus(
                        authData.token,
                        authData.userId,
                      );
                    } catch (error) {
                      scaffold.showSnackBar(SnackBar(
                        content: Text(error.toString()),
                      ));
                    }
                  },
                  color: Theme.of(context).accentColor,
                ),
              ),
              title: Text(
                product.title,
                textAlign: TextAlign.center,
              ),
              trailing: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  cart.addItem(
                      productId: product.id,
                      price: product.price,
                      title: product.title);

                  Scaffold.of(context).removeCurrentSnackBar();
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      action: SnackBarAction(
                          label: 'UNDO',
                          onPressed: () {
                            cart.removeSingleItem(product.id);
                          }),
                      duration: Duration(seconds: 2),
                      content: Row(
                        children: [
                          Icon(Icons.shopping_cart),
                          Text(
                            '  ${product.title} added to your cart!',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
