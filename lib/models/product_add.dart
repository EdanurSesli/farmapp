class Product {
  final int id;
  final String name;
  final String description;
  final int weightOrAmount;
  final String address;
  final String fullAddress;
  final int categoryId; // Kategori için int türünde ID
  final String quality;
  final double price;
  final List<String> images; // Görseller için liste
  final String unitType;
  final int quantity;
  final bool isActive;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.weightOrAmount,
    required this.address,
    required this.fullAddress,
    required this.categoryId, // Kategori ID'si
    required this.quality,
    required this.price,
    required this.images, // Görseller
    required this.unitType,
    required this.quantity,
    required this.isActive,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      weightOrAmount: json['weightOrAmount'],
      address: json['address'],
      fullAddress: json['fullAddress'],
      categoryId: json['categoryId'], // categoryId'yi alıyoruz
      quality: json['quality'],
      price: (json['price'] as num).toDouble(), // Double olarak parse ediyoruz
      images:
          List<String>.from(json['image'] ?? []), // Liste olarak ele alıyoruz
      unitType: json['unitType'],
      quantity: json['quantity'],
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'weightOrAmount': weightOrAmount,
      'address': address,
      'fullAddress': fullAddress,
      'categoryId': categoryId, // categoryId JSON'a ekleniyor
      'quality': quality,
      'price': price,
      'image': images, // Görseller JSON'a ekleniyor
      'unitType': unitType,
      'quantity': quantity,
      'isActive': isActive,
    };
  }
}
