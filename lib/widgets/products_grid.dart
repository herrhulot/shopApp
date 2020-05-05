import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool _showFavoritesOnly;

  ProductsGrid(this._showFavoritesOnly);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products =
        _showFavoritesOnly ? productsData.favoriteItems : productsData.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      // Here we use the "ChangeNotifierProvider.value()" method with "value:". Because here we're working with single items
      // of a list- or gridview. The values are already instanciated elsewere. If we use the method it can cause bugs and
      // performance issues.
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        // create: (apa) => products[i],
        child: ProductItem(
            // products[i].id,
            // products[i].title,
            // products[i].imageUrl,
            ),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 19,
        mainAxisSpacing: 20.0,
      ),
    );
  }
}
