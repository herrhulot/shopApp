import 'package:flutter/foundation.dart';

// ChangeNotifer är en "mixin" eftersom "with" används.
// En "mixin" är en class som man kan blandas in i andra klasser som ger än tillgång till
// andra variabler och metoder. T.ex. att både hundar och människor kan sitta.
// Det finns också något som heter "extends". Den gör gör att class blir en subclass.
// T.ex. att hundar och människor är en underklass av Mammals (Tuttdjur) BOOBS!

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void toggleFavoriteStatus() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
