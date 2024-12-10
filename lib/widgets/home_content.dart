import 'dart:convert'; // Base64 çözümü için gerekli
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/product_provider.dart';
import 'package:farmapp/screens/product_detail_screen.dart';
import 'package:farmapp/models/product_add.dart'; // Product modelini dahil et

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  bool _isLoading = false;
  List<Product> _allProducts = []; // Tüm ürünler burada tutulacak

  @override
  void initState() {
    super.initState();
    loadProducts(); // Token gerekmiyor, tüm ürünler getirilecek
  }

  // Ürünleri al ve listele
  Future<void> loadProducts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Token gerekmediği için direkt olarak getAllProducts çağırıyoruz
      List<Product> products = await context
          .read<ProductProvider>()
          .productService
          .getAllProducts(); // Tüm ürünleri al

      setState(() {
        _allProducts = products; // Ürünleri listeye ekle
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Error loading products: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  color: Color.fromARGB(255, 114, 154, 104),
                  width: 2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: const BorderSide(
                  color: Color.fromARGB(255, 114, 154, 104),
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: const BorderSide(
                  color: Color.fromARGB(255, 114, 154, 104),
                  width: 2,
                ),
              ),
            ),
          ),
        ),

        // Ürünler Listesi
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _allProducts.isEmpty
                  ? const Center(child: Text('Ürün bulunamadı.'))
                  : GridView.builder(
                      padding: const EdgeInsets.all(8.0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: _allProducts.length,
                      itemBuilder: (context, index) {
                        final product = _allProducts[index];
                        return GestureDetector(
                          onTap: () {
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
                                Expanded(
                                  flex: 2,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(10.0),
                                    ),
                                    child: product.image.isNotEmpty
                                        ? Image.memory(
                                            base64Decode(
                                                product.image),
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: double.infinity,
                                          )
                                        : Container(
                                            color: Colors.grey[200],
                                            child: const Center(
                                              child: Icon(
                                                Icons.image_not_supported,
                                                size: 50,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        // Ürün Adı
                                        Text(
                                          product.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        // Ürün Fiyatı
                                        Text(
                                          '${product.price.toStringAsFixed(2)} ₺',
                                          style: const TextStyle(
                                            color: Colors.green,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                        // Ürün Birimi (Adet veya Kg)
                                        Text(
                                          '${product.weightOrAmount} ${product.unitType}',
                                          style: const TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
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
