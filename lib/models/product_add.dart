class Product {
  final int id;
  final String name;
  final String description;
  final int weightOrAmount;
  final String address;
  final String fullAddress;
  final String category;
  final String quality;
  final int quantity;
  final double price;
  final String image;
  final String unitType;
  final bool isActive;

  Product({
    required this.id,
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
    required this.isActive,
  });

  // JSON'dan veriyi almak için factory method
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? json['productID'],
      name: json['name'],
      description: json['description'],
      weightOrAmount: json['weightOrAmount'],
      address: json['address'],
      fullAddress: json['fullAddress'],
      category: json['category'],
      quality: json['quality'],
      quantity: json['quantity'],
      price: json['price'].toDouble(),
      image: json['image'],
      unitType: json['unitType'],
      isActive: json['isActive'],
    );
  }

  // JSON'a dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'weightOrAmount': weightOrAmount,
      'address': address,
      'fullAddress': fullAddress,
      'category': category,
      'quality': quality,
      'quantity': quantity,
      'price': price,
      'image': image,
      'unitType': unitType,
      'isActive': isActive,
    };
  }
}
