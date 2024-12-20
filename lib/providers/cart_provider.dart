import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String name;
  final double price;
  final int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
  });

  double get totalPrice => price * quantity;
}

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _cartItems = {};

  List<CartItem> get cartItems => _cartItems.values.toList();

  double get totalCartPrice {
    return _cartItems.values.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  void addToCart(CartItem item) {
    if (_cartItems.containsKey(item.id)) {
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
      _cartItems[item.id] = item;
    }
    notifyListeners();
  }

  void removeFromCart(String id) {
    _cartItems.remove(id);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
