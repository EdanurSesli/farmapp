import 'package:farmapp/services/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:farmapp/screens/login_screen.dart';
import 'package:farmapp/models/market_register.dart';

class MarketRegisterScreen extends StatefulWidget {
  const MarketRegisterScreen({super.key});

  @override
  _MarketRegisterScreenState createState() => _MarketRegisterScreenState();
}

class _MarketRegisterScreenState extends State<MarketRegisterScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController marketNameController = TextEditingController();

  String? companyType;
  final List<String> companyTypes = [
    'Anonim Şirket (A.Ş.)',
    'Limited Şirket (Ltd. Şti.)',
    'Şahıs Şirketi',
    'Komandit Şirket',
    'Kooperatif'
  ];

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Colors.blue, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Colors.blue, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Colors.blue, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 12,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Market Adı',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              TextField(
                controller: marketNameController,
                decoration: _inputDecoration('Market Adı'),
              ),
              const SizedBox(height: 10),

              // Company Type
              const Text('Şirket Tipi',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              DropdownButtonFormField<String>(
                value: companyType,
                hint: const Text('Şirket Tipi Seçiniz'),
                items: companyTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    companyType = value;
                  });
                },
                decoration: _inputDecoration('Şirket Tipi'),
              ),
              const SizedBox(height: 10),

              // First Name
              const Text('Adınız',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              TextField(
                controller: firstNameController,
                decoration: _inputDecoration('Adınız'),
              ),
              const SizedBox(height: 10),

              // Last Name
              const Text('Soyadınız',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              TextField(
                controller: lastNameController,
                decoration: _inputDecoration('Soyadınız'),
              ),
              const SizedBox(height: 10),

              // Username
              const Text('Kullanıcı Adı',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              TextField(
                controller: userNameController,
                decoration: _inputDecoration('Kullanıcı Adı'),
              ),
              const SizedBox(height: 10),

              // Email
              const Text('Email',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              TextField(
                controller: emailController,
                decoration: _inputDecoration('Email'),
              ),
              const SizedBox(height: 10),

              // Address
              const Text('Adres',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              TextField(
                controller: addressController,
                decoration: _inputDecoration('Adres'),
              ),
              const SizedBox(height: 10),

              // Password
              const Text('Şifre',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: _inputDecoration('Şifre'),
              ),
              const SizedBox(height: 10),

              // Confirm Password
              const Text('Şifre Doğrulama',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: _inputDecoration('Şifre Doğrulama'),
              ),
              const SizedBox(height: 20),

              // Register Button
              ElevatedButton(
                onPressed: () async {
                  String firstName = firstNameController.text;
                  String lastName = lastNameController.text;
                  String userName = userNameController.text;
                  String email = emailController.text;
                  String address = addressController.text;
                  String password = passwordController.text;
                  String marketName = marketNameController.text;

                  if (companyType == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Lütfen şirket tipi seçiniz!')),
                    );
                    return;
                  }

                  MarketRegister user = MarketRegister(
                    firstName: firstName,
                    lastName: lastName,
                    userName: userName,
                    email: email,
                    adress: address,
                    password: password,
                    marketName: marketName,
                    companyType: companyType!,
                  );

                  final AuthService service = AuthService();
                  final response = await service.registerMarket(user);

                  if (response != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Kayıt başarılı!')),
                    );

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Kayıt başarısız!')),
                    );
                  }
                },
                child: const Text('Kayıt Ol'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: const Color.fromRGBO(133, 8, 62, 1),
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 10),

              // Google Register Button
              OutlinedButton(
                onPressed: () {},
                child: const Text('Google ile Kayıt Ol'),
                style: OutlinedButton.styleFrom(
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
