import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color.fromRGBO(133, 8, 62, 1),
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favoriler',
          style: TextStyle(
            fontFamily: 'Font',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(133, 8, 62, 1),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: Text(
          'Favori ürün yok.',
          style: TextStyle(fontSize: 18.0, color: Colors.grey),
        ),
      ),
    );
  }
}
