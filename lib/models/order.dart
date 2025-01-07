class CreateOrderResponse {
  final int orderId;
  final String marketReceiverId;
  final double totalPrice;
  final DateTime orderDate;
  final List<OrderItem> items;

  CreateOrderResponse({
    required this.orderId,
    required this.marketReceiverId,
    required this.totalPrice,
    required this.orderDate,
    required this.items,
  });

  factory CreateOrderResponse.fromJson(Map<String, dynamic> json) {
    var itemsList = json['items'] as List? ?? [];
    List<OrderItem> items =
        itemsList.map((i) => OrderItem.fromJson(i)).toList();

    return CreateOrderResponse(
      orderId: json['orderId'] ?? 0, // Default value if null
      marketReceiverId:
          json['marketReceiverId'] ?? "", // Default empty string if null
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ??
          0.0, // Default 0.0 if null
      orderDate: json['orderDate'] != null
          ? DateTime.parse(json['orderDate'])
          : DateTime.now(),
      items: items,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'marketReceiverId': marketReceiverId,
      'totalPrice': totalPrice,
      'orderDate': orderDate.toIso8601String(),
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class OrderItem {
  final int productId;
  final String productName;
  final int quantity;
  final double price;
  final double total;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.total,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId'] ?? 0,
      productName: json['productName'] ?? "",
      quantity: json['quantity'] ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'price': price,
      'total': total,
    };
  }
}
