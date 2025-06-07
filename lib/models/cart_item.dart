import 'package:rest_api_login/models/menu.dart';

class CartItem {
  final int id;
  final int quantity;
  final Menu menu;

  CartItem({
    required this.id,
    required this.quantity,
    required this.menu,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      quantity: json['quantity'],
      menu: Menu.fromJson(json['menu']),
    );
  }
}
