class Product {
  final String name;
  final String description;
  final int weightOrAmount; // weightOrAmount int olmalı
  final String address;
  final String fullAddress;
  final String category;
  final String quality;
  final int quantity; // API'den gelen quantity eklenmeli
  final double price;
  final String image;
  final String unitType;
  bool isActive;

  Product({
    required this.name,
    required this.description,
    required this.weightOrAmount,
    required this.address,
    required this.fullAddress,
    required this.category,
    required this.quality,
    required this.quantity,
    required this.price,
    required this.image,
    required this.unitType,
    this.isActive = true,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      weightOrAmount: json['weightOrAmount'] ?? 0,
      address: json['address'] ?? '',
      fullAddress: json['fullAddress'] ?? '',
      category: json['category'] ?? '',
      quality: json['quality'] ?? '',
      quantity: json['quantity'] ?? 0,
      price: (json['price'] as num).toDouble(),
      image: json['image'] ?? '',
      unitType: json['unitType'] ?? '',
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'weightOrAmount': weightOrAmount,
      'address': address,
      'fullAddress': fullAddress,
      'category': category,
      'quality': quality,
      'quantity': quantity, // Yeni alan
      'price': price,
      'image': image,
      'unitType': unitType,
      'isActive': isActive,
    };
  }
}
