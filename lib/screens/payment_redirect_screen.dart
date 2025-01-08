import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentRedirectScreen extends StatelessWidget {
  final String paymentUrl;

  const PaymentRedirectScreen({Key? key, required this.paymentUrl})
      : super(key: key);

  Future<void> _launchPaymentUrl(BuildContext context) async {
    try {
      final uri = Uri.parse(paymentUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Ödeme bağlantısı açılamıyor."),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Hata: $e"),
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Ödeme işlemini tamamlamak için aşağıdaki butona tıklayın.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _launchPaymentUrl(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 114, 154, 104),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                "Ödemeye Geç",
                style: TextStyle(fontSize: 18.0, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
