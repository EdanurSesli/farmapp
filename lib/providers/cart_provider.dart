import 'package:farmapp/models/cart_item.dart';
import 'package:farmapp/screens/order_summary_screen.dart';
import 'package:farmapp/services/ProductService.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider with ChangeNotifier {
  final ProductService _productService = ProductService();
  Cart? _cart;

  Cart? get cart => _cart;

  double get totalPrice => _cart?.totalPrice ?? 0.0;
  List<CartItem> get cartItems => _cart?.cartItems ?? [];

  Future<void> fetchCartItems() async {
    try {
      final cartData = await _productService.getCartItems();

      _cart = Cart(
        cartId: cartData.cartId,
        totalPrice: cartData.totalPrice,
        cartItems: cartData.cartItems,
      );
    } catch (error) {
      print("Sepet verisi alınamadı: $error");
      throw Exception("Sepet verileri getirilemedi.");
    }
  }

  Future<void> addToCart(int productId, int weightOrAmount) async {
    try {
      await _productService.addToCart(productId, weightOrAmount);

      await fetchCartItems();
    } catch (error) {
      print("Sepete ürün ekleme başarısız: $error");
      throw Exception("Ürün sepete eklenemedi.");
    }
  }

  Future<void> removeFromCart(int cartItemId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');

      if (token == null) {
        throw Exception("Geçerli bir token bulunamadı.");
      }

      await _productService.removeCartItem(cartItemId, token);

      cartItems.removeWhere((item) => item.cartItemId == cartItemId);

      notifyListeners();
    } catch (error) {
      print("Sepetten ürün çıkarma başarısız: $error");
      throw Exception("Ürün sepetten çıkarılamadı.");
    }
  }
}
