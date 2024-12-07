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
  List<Product> _allProducts = []; // Tüm ürünler
  String? token;

  @override
  void initState() {
    super.initState();
    loadTokenAndProducts();
  }

  // Token'ı SharedPreferences'ten alıp ürünleri yükle
  Future<void> loadTokenAndProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token'); // Token'ı SharedPreferences'ten alıyoruz

    if (token != null) {
      await loadProducts();
    } else {
      print("Token bulunamadı.");
    }
  }

  Future<void> loadProducts() async {
    setState(() {
      _isLoading = true;
    });

    if (token != null) {
      try {
        // ProductProvider'dan fetchProducts fonksiyonunu çağırıyoruz.
        List<Product> products = await context
            .read<ProductProvider>()
            .productService
            .fetchProducts(token!);

        setState(() {
          _allProducts = products; // Tüm ürünleri state'e kaydet
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        print("Error loading products: $e"); // Hata mesajını konsola yazdır
      }
    } else {
      print("Token bulunamadı.");
      setState(() {
        _isLoading = false;
      });
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

        // Ürün Listeleme
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
                        childAspectRatio: 0.7, // Kart yüksekliğini ayarlıyoruz
                      ),
                      itemCount: _allProducts.length,
                      itemBuilder: (context, index) {
                        final product = _allProducts[index];
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
                                // Ürün Görseli
                                Expanded(
                                  flex: 2,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(10.0),
                                    ),
                                    child: product.image.isNotEmpty
                                        ? Image.memory(
                                            base64Decode(
                                                product.image), // Base64 çözümü
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: double.infinity,
                                          )
                                        : Container(
                                            color: Colors.grey[
                                                200], // Boş alan için arka plan rengi
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

                                // Ürün Bilgileri
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
