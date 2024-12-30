class CartItem {
  final int cartItemId;
  final int productId;
  final String productName;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final String? image1;

  CartItem(
      {required this.cartItemId,
      required this.productId,
      required this.productName,
      required this.quantity,
      required this.unitPrice,
      required this.totalPrice,
      this.image1});

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      cartItemId: json['cartItemId'],
      productId: json['productId'],
      productName: json['productName'],
      unitPrice: (json['unitPrice'] as num).toDouble(),
      quantity: json['quantity'],
      totalPrice: (json['totalPrice'] as num).toDouble(),
      image1: json['product']['image1'],
    );
  }
}
