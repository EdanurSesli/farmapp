import 'package:farmapp/models/order.dart';

class MarketReceiverOrder {
  final int orderId;
  final DateTime orderDate;
  final double totalPrice;
  final List<OrderItem> items;

  MarketReceiverOrder({
    required this.orderId,
    required this.orderDate,
    required this.totalPrice,
    required this.items,
  });

  factory MarketReceiverOrder.fromJson(Map<String, dynamic> json) {
    var itemsList = json['items'] as List? ?? [];
    List<OrderItem> items =
        itemsList.map((i) => OrderItem.fromJson(i)).toList();

    return MarketReceiverOrder(
      orderId: json['orderId'] ?? 0,
      orderDate: json['orderDate'] != null
          ? DateTime.parse(json['orderDate'])
          : DateTime.now(),
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
      items: items,
    );
  }
}

class FarmerOrder {
  final int orderId;
  final DateTime orderDate;
  final String marketReceiverName;
  final List<OrderItem> products;

  FarmerOrder({
    required this.orderId,
    required this.orderDate,
    required this.marketReceiverName,
    required this.products,
  });

  factory FarmerOrder.fromJson(Map<String, dynamic> json) {
    var productList = json['products'] as List? ?? [];
    List<OrderItem> products =
        productList.map((i) => OrderItem.fromJson(i)).toList();

    return FarmerOrder(
      orderId: json['orderId'] ?? 0,
      orderDate: json['orderDate'] != null
          ? DateTime.parse(json['orderDate'])
          : DateTime.now(),
      marketReceiverName: json['marketReceiverName'] ?? "",
      products: products,
    );
  }
}
