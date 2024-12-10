import 'dart:convert';
import 'package:farmapp/screens/update_product_page.dart';
import 'package:flutter/material.dart';
import 'package:farmapp/models/product_add.dart';
import 'package:farmapp/services/ProductService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({Key? key}) : super(key: key);

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = _fetchProducts();
  }

  // Ürünleri fetch etmek için metod
  Future<List<Product>> _fetchProducts() async {
    try {
      final productService = ProductService();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token != null) {
        return await productService.fetchProducts(token);
      } else {
        throw Exception("Token bulunamadı.");
      }
    } catch (error) {
      throw Exception("Ürünler alınırken hata oluştu: $error");
    }
  }

  // Ürünü silme işlemi
  Future<void> _deleteProduct(int id) async {
    try {
      final productService = ProductService();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token != null) {
        // Silme işlemine başlamadan önce loading gösterebiliriz
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const Center(child: CircularProgressIndicator());
          },
        );

        bool success = await productService.softDeleteProduct(token, id);
        Navigator.of(context).pop(); // Loading göstergesini kapat

        if (success) {
          setState(() {
            _productsFuture = _fetchProducts(); // Listeyi güncelle
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ürün başarıyla silindi.')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ürün silinirken hata oluştu.')),
          );
        }
      } else {
        throw Exception("Token bulunamadı.");
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ürünlerim',
          style: TextStyle(
            fontFamily: 'Font',
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromRGBO(133, 8, 62, 1),
        elevation: 0,
        automaticallyImplyLeading: true,
      ),
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Hata: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Henüz ürün eklenmedi."));
          } else {
            final products = snapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  elevation: 4,
                  child: ListTile(
                    leading: product.image.isNotEmpty
                        ? Image.memory(
                            base64Decode(product.image),
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.image, size: 50),
                    title: Text(product.name,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.description,
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Fiyat: ${product.price.toStringAsFixed(2)} ₺",
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Silme butonu
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            // Silme işlemi
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Silme Onayı'),
                                  content: const Text(
                                      'Bu ürünü silmek istediğinizden emin misiniz?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Hayır'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        _deleteProduct(product
                                            .id); // Burada int ID gönderiliyor
                                      },
                                      child: const Text('Evet'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        // Güncelleme butonu (kalem ikonu)
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () async {
                            // SharedPreferences'ten token'ı alıyoruz
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            String? token = prefs.getString(
                                'token'); // Token key'inizi doğru olarak kullanın

                            if (token != null) {
                              // Güncelleme sayfasına yönlendirme
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdateProductPage(
                                    product: product,
                                    token: token, // Token'ı burada geçiriyoruz
                                  ),
                                ),
                              );
                            } else {
                              // Token bulunamadığında hata mesajı gösterebilirsiniz
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        "Token bulunamadı. Lütfen giriş yapın.")),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    onTap: () {},
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
