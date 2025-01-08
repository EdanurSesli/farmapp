import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class StripeCheckoutPage extends StatelessWidget {
  final String paymentUrl;

  const StripeCheckoutPage({Key? key, required this.paymentUrl})
      : super(key: key);

  Future<void> _launchPaymentUrl(BuildContext context) async {
    final uri = Uri.parse(paymentUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ödeme bağlantısı açılamıyor.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Stripe Ödeme",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 114, 154, 104),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _launchPaymentUrl(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 114, 154, 104),
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            minimumSize: const Size(double.infinity, 50),
          ),
          child: const Text(
            "Stripe Ödeme Sayfasını Aç",
            style: TextStyle(fontSize: 18.0, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
