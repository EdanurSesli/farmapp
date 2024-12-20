class Product {
  int id;
  String name;
  String description;
  int weightOrAmount;
  String address;
  String fullAddress;
  int categoryId;
  String quality;
  int quantity;
  double price;
  String? image1;
  String? image2;
  String? image3;
  String unitType;
  bool isActive;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.weightOrAmount,
    required this.address,
    required this.fullAddress,
    required this.categoryId,
    required this.quality,
    required this.quantity,
    required this.price,
    this.image1,
    this.image2,
    this.image3,
    required this.unitType,
    required this.isActive,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'weightOrAmount': weightOrAmount,
      'address': address,
      'fullAddress': fullAddress,
      'categoryId': categoryId,
      'quality': quality,
      'quantity': quantity,
      'price': price,
      'image1': image1,
      'image2': image2,
      'image3': image3,
      'unitType': unitType,
      'isActive': isActive,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      weightOrAmount: json['weightOrAmount'],
      address: json['address'],
      fullAddress: json['fullAddress'],
      categoryId: json['categoryId'],
      quality: json['quality'],
      quantity: json['quantity'],
      price: json['price'].toDouble(),
      image1: json['image1'],
      image2: json['image2'],
      image3: json['image3'],
      unitType: json['unitType'],
      isActive: json['isActive'],
    );
  }
}
