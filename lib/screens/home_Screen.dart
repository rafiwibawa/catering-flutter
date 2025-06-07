import 'package:flutter/material.dart';
import 'package:rest_api_login/models/product.dart';
import 'package:rest_api_login/widgets/product_item.dart';
import 'package:rest_api_login/services/api_service.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';
import 'package:rest_api_login/providers/cart_provider.dart';
import 'package:rest_api_login/screens/cart_Screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background biru
          Container(
            height: 400, // Sesuaikan tinggi sesuai kebutuhan
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(180),
                bottomRight: Radius.circular(180),
              ),
            ),
          ),

          // Ikon keranjang di kanan atas
          Positioned(
            top: 40,
            right: 20,
            child: Consumer<CartProvider>(
              builder: (context, cart, child) {
                return badges.Badge(
                  position: badges.BadgePosition.topEnd(top: -8, end: -5),
                  showBadge: cart.totalQuantity > 0,
                  badgeContent: Text(
                    '${cart.totalQuantity}',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.shopping_cart),
                    color: const Color.fromARGB(255, 0, 0, 0),
                    iconSize: 28,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CartScreen()),
                      );
                    },
                  ),
                );
              },
            ),
          ),

          // Konten utama
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Menu Makanan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Pilih menu favoritmu!',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: FutureBuilder<List<Product>>(
                        future: ApiService.fetchProducts(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text(
                                    'Terjadi kesalahan: ${snapshot.error}'));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return Center(child: Text('Tidak ada data produk'));
                          } else {
                            final products = snapshot.data!;
                            return GridView.builder(
                              itemCount: products.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 3 / 4,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemBuilder: (ctx, i) =>
                                  ProductItem(product: products[i]),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
