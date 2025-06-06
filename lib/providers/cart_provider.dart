import 'package:flutter/foundation.dart';
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  final List<_CartItem> _items = [];

  List<_CartItem> get items => [..._items];

  void addToCart(Product product, int qty) {
    final index = _items.indexWhere((i) => i.product.id == product.id);
    if (index >= 0) {
      _items[index].quantity += qty;
    } else {
      _items.add(_CartItem(product: product, quantity: qty));
    }
    notifyListeners();
  }
}

class _CartItem {
  Product product;
  int quantity;
  _CartItem({required this.product, required this.quantity});
}
