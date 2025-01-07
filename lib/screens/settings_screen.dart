import 'package:farmapp/screens/update_farmer_profile_screen.dart';
import 'package:farmapp/screens/change_password_screen.dart';
import 'package:farmapp/screens/privacy_policy_screen.dart';
import 'package:farmapp/screens/update_market_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ayarlar',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 114, 154, 104),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Hesap Bilgilerinizi Düzenleyin'),
            subtitle: const Text('Adınızı ve diğer bilgileri düzenleyin'),
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              String? userRole = prefs.getString('userRole');

              print('UserRole okundu: $userRole');

              if (userRole == 'Farmer') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UpdateFarmerProfileScreen()),
                );
              } else if (userRole == 'MarketReceiver') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UpdateMarketProfileScreen()),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Geçerli bir rol bulunamadı.')),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Şifrenizi Değiştirin'),
            subtitle: const Text('Şifrenizi düzenleyin'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ChangePasswordScreen()),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Gizlilik Politikası'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PrivacyPolicyScreen()),
              );
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}
