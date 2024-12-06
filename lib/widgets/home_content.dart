import 'package:farmapp/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart'; // ProductProvider'ı dahil et
import 'package:farmapp/widgets/category_card.dart'; // Kategori kartlarını eklemek için gerekli import

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    // ProductProvider'ı bağlama
    final productProvider = Provider.of<ProductProvider>(context);

    return Column(
      children: [
        // Arama Çubuğu
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Arama',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: const BorderSide(
                  color: Color.fromARGB(255, 114, 154, 104), // Yeşil renk
                  width: 2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: const BorderSide(
                  color: Color.fromARGB(255, 114, 154, 104), // Yeşil renk
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: const BorderSide(
                  color: Color.fromARGB(255, 114, 154, 104), // Yeşil renk
                  width: 2,
                ),
              ),
            ),
          ),
        ),

        // Kategoriler
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              CategoryCard(title: 'Sebze'),
              CategoryCard(title: 'Meyve'),
              CategoryCard(title: 'Hayvansal Ürünler'),
              CategoryCard(title: 'Ev Yapımı Ürünler'),
              CategoryCard(title: 'Tahıllar ve Baklagiller'),
            ],
          ),
        ),

        // Ürün Listeleme
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: productProvider.products.length,
            itemBuilder: (context, index) {
              final product = productProvider.products[index];
              return GestureDetector(
                onTap: () {
                  // Ürün detayları sayfasına git
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProductDetailScreen(product: product),
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
                      /*  Ürün Görseli
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(10.0),
                        ),
                        child: Image.asset(
                          product.image, // Ürünün görseli
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 120,
                        ),
                      ), */

                      // Ürün Bilgileri
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Ürün Adı
                            Text(
                              product.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            // Ürün Fiyatı
                            Text(
                              '${product.price.toStringAsFixed(2)} ₺',
                              style: const TextStyle(
                                color: Colors.green,
                                fontSize: 14.0,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            // Ürün Birimi (Adet veya Kg)
                            Text(
                              product.weightOrAmount,
                              style: const TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Favori Butonu Sağ Üstte
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: Icon(
                            product.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color:
                                product.isFavorite ? Colors.red : Colors.grey,
                          ),
                          onPressed: () {
                            // Favori durumunu değiştirme
                            productProvider.toggleFavorite(product.id);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
