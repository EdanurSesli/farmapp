import 'package:farmapp/models/market_farmer_order.dart';
import 'package:farmapp/screens/customer_service_screen.dart';
import 'package:farmapp/screens/farmer_orders_page.dart';
import 'package:farmapp/screens/home_screen.dart';
import 'package:farmapp/screens/meet_ourteam_page.dart';
import 'package:farmapp/screens/market_receiver_orders_page.dart';
import 'package:farmapp/screens/product_list_page.dart';
import 'package:farmapp/screens/settings_screen.dart';
import 'package:farmapp/services/ProductService.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:farmapp/screens/productadd_screen.dart';
import 'package:farmapp/screens/favorites_screen.dart';
import 'package:farmapp/screens/categories_screen.dart';
import 'package:farmapp/screens/cart_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String userName;
  final String email;

  const ProfileScreen({super.key, required this.userName, required this.email});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 4;

  final List<Widget> _screens = [
    const HomeScreen(),
    const FavoritesScreen(),
    const CategoriesScreen(),
    const CartScreen(),
  ];

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });

      if (index < 4) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => _screens[index]!),
        );
      }
    }
  }

  Future<String?> getUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userRole'); // 'userRole' key ile rol alınır
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    String userName = widget.userName;
    String email = widget.email;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 114, 154, 104),
        title: const Text(
          "Hesabım",
          style: TextStyle(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Color.fromARGB(255, 114, 154, 104),
                  child: Text(
                    userName.isNotEmpty ? userName[0].toUpperCase() : 'A',
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        email.isNotEmpty ? email : 'Email not available',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 30, thickness: 1),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Ürün Ekle'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProductAddScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_bag_sharp),
              title: const Text('Ürünlerim'),
              onTap: () async {
                String? userRole = await getUserRole();
                if (userRole == 'Farmer') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProductListPage()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Bu sayfaya erişim izniniz yok. Çiftçiler kullanabilir.')),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text('Siparişlerim'),
              onTap: () async {
                String? userRole = await getUserRole();
                if (userRole == 'MarketReceiver') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MarketReceiverOrdersPage(
                          productService: ProductService()),
                    ),
                  );
                } else if (userRole == 'Farmer') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          FarmerOrdersPage(productService: ProductService()),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Rol tanımlı değil.')),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.support_agent),
              title: const Text('Farm2Market Müşteri Hizmetleri'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CustomerServiceScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text('Bizi Tanıyın!'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MeetOurTeamPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Çıkış Yap'),
              onTap: _logout,
            ),
          ],
        ),
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
