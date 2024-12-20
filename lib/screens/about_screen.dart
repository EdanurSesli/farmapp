import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hakkımızda',
          style: TextStyle(
            fontFamily: 'Font',
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromRGBO(133, 8, 62, 1),
        elevation: 0,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SizedBox(height: 16),
            Text(
              'Farm2Market, çiftçilerin ürünlerini doğrudan müşterilere ulaştırmasını sağlayan bir platformdur. Amacımız, doğal ve taze ürünleri hızlı ve güvenilir bir şekilde müşterilerle buluşturmak.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Vizyonumuz:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Daha sürdürülebilir bir gelecek için yerel çiftçilerin desteklenmesini sağlamak ve müşterilere en kaliteli ürünleri sunmak.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Misyonumuz:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Çiftçiler için adil bir pazar sunmak.\n'
              'Müşterilere doğal ürünlere erişim sağlamak.\n'
              'Teknolojiyi kullanarak yerel üretimi desteklemek.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
