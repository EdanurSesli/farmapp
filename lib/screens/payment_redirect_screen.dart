import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentRedirectScreen extends StatelessWidget {
  final String paymentUrl;

  const PaymentRedirectScreen({Key? key, required this.paymentUrl})
      : super(key: key);

  Future<void> _launchPaymentUrl(BuildContext context) async {
    if (await canLaunchUrl(Uri.parse(paymentUrl))) {
      await launchUrl(
        Uri.parse(paymentUrl),
        mode: LaunchMode.externalApplication,
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Ödeme Sayfası",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 114, 154, 104),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _launchPaymentUrl(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 114, 154, 104),
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
          ),
          child: const Text(
            "Ödeme Sayfasına Git",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
