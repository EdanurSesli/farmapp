import 'package:flutter/material.dart';

class ProductData {
  final String id;
  final String name;
  final String description;
  final String weightOrAmount;
  final String address;
  final String fullAddress;
  final String category;
  final String quality;
  final double price;
  bool isFavorite; // Favori durumu, her ürün için tutuluyor

  ProductData({
    required this.id,
    required this.name,
    required this.description,
    required this.weightOrAmount,
    required this.address,
    required this.fullAddress,
    required this.category,
    required this.quality,
    required this.price,
    this.isFavorite = false,
  });
}

class ProductProvider with ChangeNotifier {
  final List<ProductData> _products = [];
  final List<ProductData> _favoriteProducts = [];

  // Tüm ürünleri almak için getter
  List<ProductData> get products => [..._products];

  // Favori ürünleri almak için getter
  List<ProductData> get favoriteProducts => [..._favoriteProducts];

  // Favori durumu değiştirme (favori ekleme/çıkarma)
  void toggleFavorite(String productId) {
    final product = _products.firstWhere((prod) => prod.id == productId);

    // Favori durumu değiştirme
    product.isFavorite = !product.isFavorite;

    // Favori olduysa, favoriler listesine ekle
    if (product.isFavorite) {
      if (!_favoriteProducts.any((favProduct) => favProduct.id == product.id)) {
        _favoriteProducts.add(product);
      }
    } else {
      _favoriteProducts
          .removeWhere((favProduct) => favProduct.id == product.id);
    }

    notifyListeners(); // Durumu güncelleyen dinleyicilere bildirim gönder
  }

  // Ürün ekleme
  void addProduct(ProductData product) {
    _products.add(product);

    // Eğer ürün favoriyse, favori listesine ekle
    if (product.isFavorite &&
        !_favoriteProducts.any((favProduct) => favProduct.id == product.id)) {
      _favoriteProducts.add(product);
    }

    notifyListeners(); // Durumu güncelleyen dinleyicilere bildirim gönder
  }

  // Ürün silme
  void removeProduct(String id) {
    final product = _products.firstWhere((product) => product.id == id);
    if (product.isFavorite) {
      _favoriteProducts.removeWhere((favProduct) =>
          favProduct.id == product.id); // Favori ise favorilerden çıkar
    }
    _products.removeWhere((product) => product.id == id);
    notifyListeners(); // Durumu güncelleyen dinleyicilere bildirim gönder
  }

  // Ürün güncelleme
  void updateProduct(String id, ProductData updatedProduct) {
    final index = _products.indexWhere((product) => product.id == id);
    if (index >= 0) {
      _products[index] = updatedProduct;

      // Favori durumu değişmişse, favoriler listesini de güncelle
      if (updatedProduct.isFavorite) {
        if (!_favoriteProducts
            .any((favProduct) => favProduct.id == updatedProduct.id)) {
          _favoriteProducts.add(updatedProduct);
        }
      } else {
        _favoriteProducts
            .removeWhere((favProduct) => favProduct.id == updatedProduct.id);
      }

      notifyListeners(); // Durumu güncelleyen dinleyicilere bildirim gönder
    } else {
      throw Exception('Ürün bulunamadı.');
    }
  }
}
