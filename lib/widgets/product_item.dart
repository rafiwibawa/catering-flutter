import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rest_api_login/models/product.dart';
import 'package:rest_api_login/providers/cart_provider.dart'; // Tambahkan ini jika pakai Provider
import 'package:rest_api_login/services/api_service.dart'; // Tambahkan ini jika pakai API

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar produk
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),

          // Nama produk
          Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              product.name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          // Harga produk
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Rp ${product.price}',
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),

          // Tombol Tambah ke Keranjang
          Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  backgroundColor: Colors.blue,
                ),
                onPressed: () async {
                  try {
                    // 👇 Pilih salah satu dari dua cara di bawah

                    // 1. Tambah ke Cart secara lokal
                    Provider.of<CartProvider>(context, listen: false)
                        .addToLocalCart(product, 1);

                    // 2. Atau, tambah ke Cart via API
                    final cartCount = await ApiService.addToCart(product.id);

                    Provider.of<CartProvider>(context, listen: false)
                        .updateCartCount(cartCount);

                    // Notifikasi
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('${product.name} ditambahkan ke keranjang'),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Gagal menambahkan: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: Text(
                  'Tambah',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
