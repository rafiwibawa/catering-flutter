import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static Future<List<Product>> fetchProducts() async {
    final response =
        await http.get(Uri.parse('http://localhost:7000/api/list-menu'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat produk');
    }
  }

  static Future<int> addToCart(int productId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token tidak ditemukan. Silakan login ulang.');
    }

    final response = await http.get(
      Uri.parse(
          'http://localhost:7000/api/menu/add-to-cart/$productId'), // ganti jika bukan emulator
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal menambahkan ke keranjang: ${response.body}');
    }

    final data = json.decode(response.body);
    return data['cart_count'] ?? 0;
  }
}
