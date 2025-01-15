import 'package:farmapp/services/ProductService.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:farmapp/screens/home_screen.dart';

import '../models/order.dart';

class OrderSummaryScreen extends StatelessWidget {
  final CreateOrderResponse order;

  const OrderSummaryScreen({Key? key, required this.order}) : super(key: key);

  Future<void> _launchPaymentUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);

      await Future.delayed(const Duration(seconds: 20));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Ödeme bağlantısı açılamıyor."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderDateFormatted =
        DateFormat('HH:mm').format(order.orderDate.toLocal());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Sipariş Özeti",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 114, 154, 104),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Sipariş Tarihi: $orderDateFormatted",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8.0),
              Text(
                "Genel Toplam: ${order.totalPrice.toStringAsFixed(2)}₺",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16.0),
              const Text(
                "Ürünler:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              if (order.items.isNotEmpty)
                ...order.items.map((item) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Ürün Adı: ${item.productName}"),
                          Text("Miktar: ${item.quantity}"),
                          Text(
                              "Birim Fiyat: ${item.price.toStringAsFixed(2)}₺"),
                          Text("Toplam: ${item.total.toStringAsFixed(2)}₺"),
                        ],
                      ),
                    ),
                  );
                }).toList()
              else
                const Text(
                  "Sepette ürün bulunmuyor.",
                  style: TextStyle(color: Colors.grey),
                ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  try {
                    final paymentUrl =
                        await ProductService().createCheckoutSession();

                    if (paymentUrl != null && paymentUrl.isNotEmpty) {
                      await _launchPaymentUrl(context, paymentUrl);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Ödeme oturumu oluşturulamadı."),
                        ),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Hata: $e")),
                    );
                  }
                },
                child: const Text(
                  "Ödemeye Geç",
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 114, 154, 104),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
