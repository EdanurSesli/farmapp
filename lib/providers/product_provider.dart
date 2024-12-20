import 'package:flutter/material.dart';
import 'package:farmapp/models/product_add.dart';
import 'package:farmapp/services/ProductService.dart';

class ProductProvider with ChangeNotifier {
  final List<Product> _products = [];
  final List<Product> _farmerProducts = [];
  bool _isLoading = false;

  final ProductService _productService = ProductService();

  List<Product> get products => [..._products];
  List<Product> get farmerProducts => [..._farmerProducts];
  bool get isLoading => _isLoading;
  ProductService get productService => _productService;

  Future<void> loadAllProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final List<Product>? allProducts = await _productService.getAllProducts();
      if (allProducts != null) {
        _products.clear();
        _products.addAll(allProducts);
      }
    } catch (e) {
      print('Tüm ürünler yüklenirken hata oluştu: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadFarmerProducts(String token) async {
    _isLoading = true;
    notifyListeners();

    try {
      final List<Product>? farmerProducts =
          await _productService.fetchProducts(token);
      if (farmerProducts != null) {
        _farmerProducts.clear();
        _farmerProducts.addAll(farmerProducts);
      }
    } catch (e) {
      print('Çiftçiye ait ürünler yüklenirken hata oluştu: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addProduct(Product product) async {
    _isLoading = true;
    notifyListeners();

    try {
      final bool success = await _productService.addProduct(product);
      if (success) {
        _farmerProducts.add(product);
      }
    } catch (e) {
      print('Ürün eklenirken hata oluştu: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> removeProduct(String token, int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      final bool success = await _productService.softDeleteProduct(token, id);
      if (success) {
        _products.removeWhere((product) => product.id == id);
        _farmerProducts.removeWhere((product) => product.id == id);
      }
    } catch (e) {
      print('Ürün silinirken hata oluştu: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProduct(Product updatedProduct, String token) async {
    _isLoading = true;
    notifyListeners();

    try {
      final bool success =
          await _productService.updateProduct(updatedProduct, token);
      if (success) {
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
    } catch (e) {
      print('Ürün güncellenirken hata oluştu: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
