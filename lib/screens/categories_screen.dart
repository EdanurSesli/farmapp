import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Durum çubuğu rengini AppBar ile uyumlu hale getir
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color.fromRGBO(133, 8, 62, 1), // AppBar rengiyle aynı
        statusBarIconBrightness: Brightness.light, // İkonları beyaz yap
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kategoriler',
          style: TextStyle(
            fontFamily: 'Font',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(133, 8, 62, 1), // Arka plan rengi
        elevation: 0, // Gölgeyi kaldır
        automaticallyImplyLeading: false, // Geri tuşu eklenmeyecek
      ),
      body: SafeArea(
        child: GridView.builder(
          padding: const EdgeInsets.all(16.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return CategoryTile(title: categories[index]);
          },
        ),
      ),
    );
  }
}

const List<String> categories = [
  'Sebze',
  'Meyve',
  'Hayvansal Ürünler',
  'Ev Yapımı Ürünler',
  'Tahıllar ve Baklagiller',
];

class CategoryTile extends StatelessWidget {
  final String title;

  const CategoryTile({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromRGBO(133, 8, 62, 1),
      elevation: 3,
      child: InkWell(
        onTap: () {},
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
