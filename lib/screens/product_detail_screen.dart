import 'dart:convert';
import 'package:farmapp/models/cart_item.dart';
import 'package:farmapp/models/product_add.dart';
import 'package:farmapp/providers/cart_provider.dart';
import 'package:farmapp/screens/home_screen.dart';
import 'package:farmapp/services/ProductService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;
  late double _totalPrice;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _calculateTotalPrice();
  }

  void _calculateTotalPrice() {
    setState(() {
      _totalPrice = widget.product.price * _quantity;
    });
  }

  void _onQuantityChanged(String value) {
    final int? quantity = int.tryParse(value);
    if (quantity != null && quantity > 0) {
      if (quantity <= widget.product.weightOrAmount) {
        setState(() {
          _quantity = quantity;
          _errorMessage = null;
          _calculateTotalPrice();
        });
      } else {
        setState(() {
          _errorMessage = "Miktar stoktan fazla olamaz!";
        });
      }
    } else {
      setState(() {
        _errorMessage = "Geçerli bir miktar giriniz!";
      });
    }
  }

  Future<void> _addToCart() async {
    try {
      // Use the product_service's addToCart method
      await ProductService().addToCart(widget.product.id, _quantity);

      // Başarı durumunda kullanıcıyı bilgilendir
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ürün sepete başarıyla eklendi.")),
      );

      // Kullanıcıyı anasayfaya yönlendir
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sepete ekleme sırasında hata oluştu: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    List<String?> productImages = [
      widget.product.image1,
      widget.product.image2,
      widget.product.image3,
    ];

    List<String> validImages = productImages
        .where((image) => image != null && image.isNotEmpty)
        .cast<String>()
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Ürün Detayı",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(133, 8, 62, 1),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ürün görselleri
            SizedBox(
              height: 300,
              child: validImages.isNotEmpty
                  ? PageView.builder(
                      itemCount: validImages.length,
                      itemBuilder: (context, index) {
                        return Image.memory(
                          base64Decode(validImages[index]),
                          fit: BoxFit.cover,
                          width: double.infinity,
                        );
                      },
                    )
                  : Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                    ),
            ),
            // Ürün bilgileri
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.product.name,
                        style: const TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${widget.product.price.toStringAsFixed(2)} ₺",
                        style: const TextStyle(
                          fontSize: 20.0,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    "Stok: ${widget.product.weightOrAmount} ${widget.product.unitType} | Kalite: ${widget.product.quality}",
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    "Gönderim: ${_formatAddress(widget.product.address)}",
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    widget.product.description,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
            // Miktar ve sepet butonu
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 100,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "Miktar giriniz",
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.green, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.green, width: 2),
                            ),
                          ),
                          onChanged: _onQuantityChanged,
                        ),
                      ),
                    ],
                  ),
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Toplam: ${_totalPrice.toStringAsFixed(2)} ₺",
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _quantity > 0 &&
                                _quantity <= widget.product.weightOrAmount
                            ? _addToCart
                            : null,
                        child: const Text("Sepete Ekle"),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatAddress(String address) {
    final parts = address.split(',');
    if (parts.length >= 2) {
      return "${parts[0]}, ${parts[1]}";
    }
    return address;
  }
}
