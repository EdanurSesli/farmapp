import 'package:farmapp/models/product_add.dart';
import 'package:farmapp/services/ProductService.dart';
import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  final List<Product> _products = [];
  bool _isLoading = false; // isLoading durumu ekledik

  final ProductService _productService =
      ProductService(); // ProductService'ı ekledik

  ProductService get productService => _productService;

  // Tüm ürünleri almak için getter
  List<Product> get products => [..._products];

  // isLoading getter'ı
  bool get isLoading => _isLoading;

  // Ürünleri API'den al
  Future<void> loadProducts(String token) async {
    _isLoading = true; // Yükleniyor durumu başlat
    notifyListeners(); // Dinleyicilere bildirim gönder

    try {
      List<Product> products = await _productService.fetchProducts(token);
      _products.clear();
      _products.addAll(products);
      _isLoading = false; // Yükleme tamamlandığında isLoading false
      notifyListeners(); // Durum değiştiği için dinleyicilere bildirim gönder
    } catch (e) {
      print("Error loading products: $e");
      _isLoading = false; // Hata durumunda da isLoading false
      notifyListeners();
    }
  }

  // Ürün ekleme
  void addProduct(Product product) {
    _products.add(product);
    notifyListeners(); // Durumu güncelleyen dinleyicilere bildirim gönder
  }

  // Ürün silme
  void removeProduct(String id) {
    _products.removeWhere((product) => product.id == id);
    notifyListeners(); // Durumu güncelleyen dinleyicilere bildirim gönder
  }

  // Ürün güncelleme
  void updateProduct(String id, Product updatedProduct) {
    final index = _products.indexWhere((product) => product.id == id);
    if (index >= 0) {
      _products[index] = updatedProduct;
      notifyListeners(); // Durumu güncelleyen dinleyicilere bildirim gönder
    } else {
      throw Exception('Ürün bulunamadı.');
    }
  }
}
