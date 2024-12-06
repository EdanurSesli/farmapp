import 'package:flutter/material.dart';

class CartItem {
  final String id; // Benzersiz kimlik (isteğe bağlı)
  final String name;
  final double price;
  final int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
  });

  // Toplam fiyatı hesaplar
  double get totalPrice => price * quantity;
}

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _cartItems =
      {}; // Ürünleri benzersiz bir şekilde saklar

  // Sepetteki ürünlerin listesi
  List<CartItem> get cartItems => _cartItems.values.toList();

  // Toplam fiyat
  double get totalCartPrice {
    return _cartItems.values.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  // Sepete ürün ekleme
  void addToCart(CartItem item) {
    if (_cartItems.containsKey(item.id)) {
      // Eğer ürün zaten varsa miktarını artır
      _cartItems.update(
        item.id,
        (existingItem) => CartItem(
          id: existingItem.id,
          name: existingItem.name,
          price: existingItem.price,
          quantity: existingItem.quantity + item.quantity,
        ),
      );
    } else {
      // Yeni bir ürün ekleniyor
      _cartItems[item.id] = item;
    }
    notifyListeners();
  }

  // Ürünü sepetten kaldırma
  void removeFromCart(String id) {
    _cartItems.remove(id);
    notifyListeners();
  }

  // Sepeti tamamen temizleme
  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
