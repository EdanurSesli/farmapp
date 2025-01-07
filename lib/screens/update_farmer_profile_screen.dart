import 'package:farmapp/models/UpdateFarmerProfile.dart';
import 'package:flutter/material.dart';
import 'package:farmapp/services/AuthService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateFarmerProfileScreen extends StatefulWidget {
  const UpdateFarmerProfileScreen({super.key});

  @override
  State<UpdateFarmerProfileScreen> createState() =>
      _UpdateFarmerProfileScreenState();
}

class _UpdateFarmerProfileScreenState extends State<UpdateFarmerProfileScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _adressController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserDataFromSharedPreferences();
  }

  Future<void> _loadUserDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _firstNameController.text = prefs.getString('firstName') ?? '';
      _lastNameController.text = prefs.getString('lastName') ?? '';
      _userNameController.text = prefs.getString('userName') ?? '';
      _emailController.text = prefs.getString('email') ?? '';
      _adressController.text = prefs.getString('adress') ?? '';
    });
  }

  Future<void> _updateFarmerProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final request = UpdateFarmerProfile(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        userName: _userNameController.text,
        email: _emailController.text,
        adress: _adressController.text,
      );

      try {
        final success = await AuthService().updateFarmerProfile(request);

        setState(() {
          _isLoading = false;
        });

        if (success) {
          SharedPreferences prefs = await SharedPreferences.getInstance();

          await prefs.setString('firstName', _firstNameController.text);
          await prefs.setString('lastName', _lastNameController.text);
          await prefs.setString('userName', _userNameController.text);
          await prefs.setString('email', _emailController.text);
          await prefs.setString('adress', _adressController.text);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Farmer profili başarıyla güncellendi.')),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Farmer profili güncelleme başarısız.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bir hata oluştu. Lütfen tekrar deneyin.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _userNameController.dispose();
    _emailController.dispose();
    _adressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hesap Bilgilerinizi Güncelleyin',
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 114, 154, 104),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'Ad'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Adınızı giriniz.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Soyad'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Soyadınızı giriniz.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _userNameController,
                decoration: const InputDecoration(labelText: 'Kullanıcı Adı'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kullanıcı adınızı giriniz.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'E-Posta'),
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Geçerli bir e-posta adresi giriniz.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _adressController,
                decoration: const InputDecoration(labelText: 'Adres'),
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _updateFarmerProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 114, 154, 104),
                      ),
                      child: const Text(
                        'Güncelle',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
