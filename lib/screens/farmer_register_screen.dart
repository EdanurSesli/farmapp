import 'package:flutter/material.dart';
import 'package:farmapp/services/AuthService.dart';
import 'package:farmapp/screens/login_screen.dart';
import 'package:farmapp/models/farmer_register.dart';

class FarmerRegisterScreen extends StatefulWidget {
  const FarmerRegisterScreen({super.key});

  @override
  _FarmerRegisterScreenState createState() => _FarmerRegisterScreenState();
}

class _FarmerRegisterScreenState extends State<FarmerRegisterScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

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
              const Text('Adınız',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                controller: firstNameController,
                decoration: _inputDecoration('Adınız'),
              ),
              const SizedBox(height: 10),
              const Text('Soyadınız',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                controller: lastNameController,
                decoration: _inputDecoration('Soyadınız'),
              ),
              const SizedBox(height: 10),
              const Text('Kullanıcı Adı',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                controller: usernameController,
                decoration: _inputDecoration('Kullanıcı Adı'),
              ),
              const SizedBox(height: 10),
              const Text('Email',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                controller: emailController,
                decoration: _inputDecoration('Email'),
              ),
              const SizedBox(height: 10),
              const Text('Adres',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                controller: addressController,
                decoration: _inputDecoration('Adres'),
              ),
              const SizedBox(height: 10),
              const Text('Şifre',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: _inputDecoration('Şifre'),
              ),
              const SizedBox(height: 10),
              const Text('Şifre Doğrulama',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: _inputDecoration('Şifre Doğrulama'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  String firstName = firstNameController.text;
                  String lastName = lastNameController.text;
                  String username = usernameController.text;
                  String email = emailController.text;
                  String address = addressController.text;
                  String password = passwordController.text;

                  FarmerRegister user = FarmerRegister(
                    firstName: firstName,
                    lastName: lastName,
                    userName: username,
                    email: email,
                    adress: address,
                    password: password,
                  );

                  final AuthService service = AuthService();
                  final response = await service.registerFarmer(user);

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
