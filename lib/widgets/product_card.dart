import 'dart:convert'; // Base64 çözümü için gerekli
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String id;
  final String name;
  final double price;
  final String? imageBase64; // Base64 kodu alınacak
  final String weightOrAmount; // Miktar bilgisi
  final String unitType; // Birim tipi (örneğin kg, adet)

  const ProductCard({
    required this.id,
    required this.name,
    required this.price,
    this.imageBase64, // Görsel opsiyonel olabilir
    required this.weightOrAmount,
    required this.unitType,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        height: 240,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ürün Görseli
            Center(
              child: imageBase64 != null && imageBase64!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.memory(
                        base64Decode(imageBase64!), // Base64 çözümü
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Icon(
                      Icons.image_not_supported, // Görsel yoksa varsayılan ikon
                      size: 120,
                      color: Colors.grey,
                    ),
            ),
            const SizedBox(height: 8),
            // Ürün Adı ve Fiyat
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${price.toStringAsFixed(2)} ₺",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "$weightOrAmount $unitType", // Örneğin: "50 kg"
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
