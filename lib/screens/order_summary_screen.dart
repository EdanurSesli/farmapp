import 'package:farmapp/screens/payment_redirect_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart'; // Tarih formatlama için

import '../models/order.dart';

class OrderSummaryScreen extends StatelessWidget {
  final CreateOrderResponse order; // Use the correct model

  const OrderSummaryScreen({Key? key, required this.order}) : super(key: key);

  Future<String?> createCheckoutSession() async {
    final url = Uri.parse(
        "https://farmtwomarket.com/api/Payment/CreateCheckoutSession");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception("Token bulunamadı. Giriş yapmanız gerekiyor.");
    }

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['paymentUrl'];
    } else {
      throw Exception("Ödeme oturumu oluşturulamadı: ${response.body}");
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
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 114, 154, 104),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
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
                ...order.items.map<Widget>((item) {
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
                    final paymentUrl = await createCheckoutSession();

                    if (paymentUrl != null && paymentUrl.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PaymentRedirectScreen(paymentUrl: paymentUrl),
                        ),
                      );
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
