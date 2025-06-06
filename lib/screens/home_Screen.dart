import 'package:flutter/material.dart';
import 'package:rest_api_login/models/product.dart';
import 'package:rest_api_login/widgets/product_item.dart';
import 'package:rest_api_login/services/api_service.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background biru
          Container(
            height: MediaQuery.of(context).size.height * 0.65,
            width: MediaQuery.of(context).size.width * 0.85,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(360),
                bottomRight: Radius.circular(360),
              ),
              color: const Color.fromRGBO(33, 150, 243, 1),
            ),
          ),

          // Ikon keranjang di kanan atas
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              color: const Color.fromARGB(255, 0, 0, 0),
              iconSize: 28,
              onPressed: () {
                // Aksi ke halaman keranjang
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
