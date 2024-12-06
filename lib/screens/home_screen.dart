import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import 'favorites_screen.dart';
import 'categories_screen.dart';
import 'cart_screen.dart';
import 'login_screen.dart';
import '../widgets/product_card.dart';
import '../widgets/home_content.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getScreen(int index) {
    switch (index) {
      case 0:
        return const HomeContent();
      case 1:
        return const FavoritesScreen();
      case 2:
        return const CategoriesScreen();
      case 3:
        return const CartScreen();
      case 4:
        return const LoginScreen();
      default:
        return const HomeContent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 0
          ? AppBar(
              title: const Text(
                'Farm2Market',
                style: TextStyle(
                  fontFamily: 'Farm2MarketFont',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
              backgroundColor: const Color.fromRGBO(133, 8, 62, 1),
              elevation: 0,
              automaticallyImplyLeading: false,
            )
          : null,
      body: SafeArea(
        child: _getScreen(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoriler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Kategoriler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Sepetim',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Hesabım',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color.fromARGB(255, 114, 154, 104),
        unselectedItemColor: const Color.fromRGBO(133, 8, 62, 1),
        backgroundColor: Colors.white,
      ),
    );
  }
}
