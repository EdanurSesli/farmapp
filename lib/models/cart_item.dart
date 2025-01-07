class Cart {
  final int cartId;
  final double totalPrice;
  final List<CartItem> cartItems;

  Cart({
    required this.cartId,
    required this.totalPrice,
    required this.cartItems,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      cartId: json['cartId'],
      totalPrice: (json['totalPrice'] as num).toDouble(),
      cartItems: (json['cartItems'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cartId': cartId,
      'totalPrice': totalPrice,
      'cartItems': cartItems.map((item) => item.toJson()).toList(),
    };
  }
}

class CartItem {
  final int cartItemId;
  final int productId;
  final String productName;
  final double weightOrAmount;
  final double unitPrice;
  final double totalPrice;

  CartItem({
    required this.cartItemId,
    required this.productId,
    required this.productName,
    required this.weightOrAmount,
    required this.unitPrice,
    required this.totalPrice,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      cartItemId: json['cartItemId'],
      productId: json['productId'],
      productName: json['productName'],
      weightOrAmount: (json['weightOrAmount'] as num).toDouble(),
      unitPrice: (json['unitPrice'] as num).toDouble(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cartItemId': cartItemId,
      'productId': productId,
      'productName': productName,
      'weightOrAmount': weightOrAmount,
      'unitPrice': unitPrice,
      'totalPrice': totalPrice,
    };
  }
}
