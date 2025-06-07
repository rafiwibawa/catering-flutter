import 'package:flutter/foundation.dart';
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  final List<_CartItem> _items = [];
  int _cartCount = 0; // simpan jumlah total item dari server

  List<_CartItem> get items => [..._items];
  int get totalQuantity => _cartCount;

  void updateCartCount(int count) {
    _cartCount = count;
    notifyListeners();
  }

  // kalau kamu masih ingin pakai addToCart untuk local update juga, bisa pisah method
  void addToLocalCart(Product product, int qty) {
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
