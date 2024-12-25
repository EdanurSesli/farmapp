import 'package:flutter/material.dart';
import 'package:farmapp/models/product_add.dart';
import 'package:farmapp/services/ProductService.dart';

class ProductProvider with ChangeNotifier {
  final List<Product> _products = [];
  final List<Product> _farmerProducts = [];
  final List<int> _favoriteProductIds = [];
  bool _isLoading = false;

  final ProductService _productService = ProductService();

  // Getters
  List<Product> get products => [..._products];
  List<Product> get farmerProducts => [..._farmerProducts];
  List<int> get favoriteProductIds => [..._favoriteProductIds];
  bool get isLoading => _isLoading;

  // Favori kontrolü
  bool isFavorite(int productId) {
    return _favoriteProductIds.contains(productId);
  }

  // Tüm ürünleri yükleme (fetchAllProducts metodu)
  Future<List<Product>> fetchAllProducts() async {
    _setLoading(true);
    try {
      final List<Product>? allProducts = await _productService.getAllProducts();
      if (allProducts != null) {
        _products.clear();
        _products.addAll(allProducts);
        notifyListeners();
      }
      return _products;
    } catch (e) {
      debugPrint('Tüm ürünler yüklenirken hata oluştu: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Çiftçiye ait ürünleri yükleme
  Future<void> loadFarmerProducts(String token) async {
    _setLoading(true);
    try {
      final List<Product>? farmerProducts =
          await _productService.fetchProducts(token);
      if (farmerProducts != null) {
        _farmerProducts.clear();
        _farmerProducts.addAll(farmerProducts);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Çiftçiye ait ürünler yüklenirken hata oluştu: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Ürün ekleme
  Future<void> addProduct(Product product) async {
    _setLoading(true);
    try {
      final bool success = await _productService.addProduct(product);
      if (success) {
        _farmerProducts.add(product);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Ürün eklenirken hata oluştu: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Ürün silme
  Future<void> removeProduct(String token, int id) async {
    _setLoading(true);
    try {
      final bool success = await _productService.softDeleteProduct(token, id);
      if (success) {
        _products.removeWhere((product) => product.id == id);
        _farmerProducts.removeWhere((product) => product.id == id);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Ürün silinirken hata oluştu: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Ürün güncelleme
  Future<void> updateProduct(Product updatedProduct, String token) async {
    _setLoading(true);
    try {
      final bool success =
          await _productService.updateProduct(updatedProduct, token);
      if (success) {
        _updateProductInLists(updatedProduct);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Ürün güncellenirken hata oluştu: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Favorileri yükleme
  Future<void> loadFavorites() async {
    try {
      final favorites = await _productService.getFavorites();
      _favoriteProductIds.clear();
      _favoriteProductIds.addAll(favorites.map((product) => product.id));
      notifyListeners();
    } catch (e) {
      debugPrint('Favoriler yüklenirken hata oluştu: $e');
    }
  }

  // Favori durumu değiştirme
  Future<void> toggleFavorite(int productId) async {
    try {
      if (isFavorite(productId)) {
        final success = await _productService.removeFavorite(productId);
        if (success) {
          _favoriteProductIds.remove(productId);
        }
      } else {
        final success = await _productService.addFavorite(productId);
        if (success) {
          _favoriteProductIds.add(productId);
        }
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Favori durumu değiştirilirken hata oluştu: $e');
    }
  }

  // Yardımcı metodlar
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _updateProductInLists(Product updatedProduct) {
    final int allIndex =
        _products.indexWhere((product) => product.id == updatedProduct.id);
    if (allIndex >= 0) {
      _products[allIndex] = updatedProduct;
    }

    final int farmerIndex = _farmerProducts
        .indexWhere((product) => product.id == updatedProduct.id);
    if (farmerIndex >= 0) {
      _farmerProducts[farmerIndex] = updatedProduct;
    }
  }
}
