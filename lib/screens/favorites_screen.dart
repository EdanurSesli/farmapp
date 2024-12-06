import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:farmapp/providers/product_provider.dart';
import 'package:farmapp/screens/product_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Durum çubuğu rengini AppBar ile eşitle
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color.fromRGBO(133, 8, 62, 1), // AppBar rengiyle aynı
        statusBarIconBrightness: Brightness.light, // İkonları beyaz yap
      ),
    );

    final favoriteProducts =
        Provider.of<ProductProvider>(context).favoriteProducts;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favoriler',
          style: TextStyle(
            fontFamily: 'Font',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(133, 8, 62, 1),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: favoriteProducts.isEmpty
          ? const Center(child: Text('Favori ürün yok.'))
          : GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: favoriteProducts.length,
              itemBuilder: (context, index) {
                final product = favoriteProducts[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailScreen(
                          product: product,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                '${product.price.toStringAsFixed(2)} ₺',
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 14.0,
                                ),
                              ),
                              // Favori butonu
                              IconButton(
                                icon: Icon(
                                  product.isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: product.isFavorite
                                      ? Colors.red
                                      : Colors.grey,
                                ),
                                onPressed: () {
                                  // Favori durumu değiştirme
                                  Provider.of<ProductProvider>(context,
                                          listen: false)
                                      .toggleFavorite(product.id);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
