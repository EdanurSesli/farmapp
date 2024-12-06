import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart'; // ProductProvider'ı dahil et

class ProductCard extends StatefulWidget {
  final String id;
  final String name;
  final double price;
  final String image;
  final String weightOrAmount; // Ağırlık veya adet bilgisini ekledik
  final bool isFavorite; // Favori durumu

  const ProductCard({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.weightOrAmount, // Ağırlık/Adet
    required this.isFavorite, // Favori durumu
    super.key,
  });

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late bool isFavorited;

  @override
  void initState() {
    super.initState();
    isFavorited =
        widget.isFavorite; // Favori durumu başlangıçta widget'dan alınacak
  }

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
            // Ürün görseli
            Center(
              child: Image.asset(
                widget.image,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            // Ürün adı ve fiyat
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Ürün adı ve fiyat bilgisi
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "${widget.price} ₺/${widget.weightOrAmount}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  // Favori butonu
                  IconButton(
                    icon: Icon(
                      isFavorited ? Icons.favorite : Icons.favorite_border,
                      color: isFavorited ? Colors.red : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        isFavorited = !isFavorited; // Favori durumunu güncelle
                      });

                      // ProductProvider'dan favori durumunu değiştir
                      Provider.of<ProductProvider>(context, listen: false)
                          .toggleFavorite(widget.id);
                    },
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
