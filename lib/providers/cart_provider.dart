import 'dart:convert';
import 'package:farmapp/services/ProductService.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item.dart';

class CartProvider with ChangeNotifier {
  final Map<int, CartItem> _cartItems = {};
  final ProductService _productService = ProductService();

  /// Sepetteki ürünlerin listesi
  List<CartItem> get cartItems => _cartItems.values.toList();

  /// Sepetteki toplam fiyat
  double get totalCartPrice {
    return _cartItems.values.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  /// Sepet öğelerini API'den yükle
  Future<void> fetchCartItems() async {
    final String token = await _getToken();
    if (token.isEmpty) {
      debugPrint("Hata: Geçerli bir token bulunamadı.");
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('https://farmtwomarket.com/api/Cart/GetCart'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        _cartItems.clear();

        for (var item in data) {
          _cartItems[item['cartItemId']] = CartItem(
            cartItemId: item['cartItemId'],
            productId: item['productId'],
            productName: item['productName'],
            quantity: item['weightOrAmount'],
            unitPrice: double.tryParse(item['unitPrice'].toString()) ?? 0.0,
            totalPrice: double.tryParse(item['totalPrice'].toString()) ?? 0.0,
            image1: item['image1'],
          );
        }

        notifyListeners();
      } else {
        debugPrint('API Hatası: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint("Hata: $e");
    }
  }

  /// Sepete ürün ekleme
  Future<void> addToCart(CartItem item) async {
    final String token = await _getToken();
    if (token.isEmpty) {
      debugPrint("Hata: Geçerli bir token bulunamadı.");
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('https://farmtwomarket.com/api/Cart/AddToCart'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'productId': item.productId,
          'weightOrAmount': item.quantity,
        }),
      );

      if (response.statusCode == 200) {
        await fetchCartItems();
      } else {
        debugPrint('API Hatası: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint('Hata: $e');
    }
  }

  /// Sepetten ürün çıkarma
  Future<void> removeFromCart(int cartItemId) async {
    final String token = await _getToken();
    if (token.isEmpty) {
      debugPrint("Hata: Geçerli bir token bulunamadı.");
      return;
    }

    try {
      final response = await http.delete(
        Uri.parse(
            'https://farmtwomarket.com/api/Cart/RemoveCartItem/$cartItemId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        _cartItems.remove(cartItemId);
        notifyListeners();
      } else {
        debugPrint('API Hatası: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint("Hata: $e");
    }
  }

  /// Kullanıcı Token'ını Al
  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  /// Sepet öğesini manuel olarak kaldır
  void removeItem(int itemId) {
    _cartItems.remove(itemId);
    notifyListeners();
  }
}
