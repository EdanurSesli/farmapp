import 'package:farmapp/models/UpdateMarketProfile.dart';
import 'package:flutter/material.dart';
import 'package:farmapp/services/AuthService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateMarketProfileScreen extends StatefulWidget {
  const UpdateMarketProfileScreen({super.key});

  @override
  State<UpdateMarketProfileScreen> createState() =>
      _UpdateMarketProfileScreenState();
}

class _UpdateMarketProfileScreenState extends State<UpdateMarketProfileScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _adressController = TextEditingController();

  String? _selectedCompanyType;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final List<String> companyTypes = [
    'Anonim Şirket (A.Ş.)',
    'Limited Şirket (Ltd. Şti.)',
    'Şahıs Şirketi',
    'Komandit Şirket',
    'Kooperatif'
  ];

  @override
  void initState() {
    super.initState();
    _loadUserDataFromDatabase();
  }

  Future<void> _loadUserDataFromDatabase() async {
    final userData = await AuthService().getUserProfile();
    setState(() {
      _firstNameController.text = userData['firstName'] ?? '';
      _lastNameController.text = userData['lastName'] ?? '';
      _userNameController.text = userData['userName'] ?? '';
      _emailController.text = userData['email'] ?? '';
      _adressController.text = userData['adress'] ?? '';
      _selectedCompanyType = userData['companyType'] ?? '';
    });
  }

  Future<void> _updateMarketProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final request = UpdateMarketProfile(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        userName: _userNameController.text,
        email: _emailController.text,
        adress: _adressController.text,
        marketName: _firstNameController.text,
        companyType: _selectedCompanyType ?? '',
      );

      try {
        final success = await AuthService().updateMarketProfile(request);

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
          await prefs.setString('companyType', _selectedCompanyType ?? '');

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Hesap bilgileri başarıyla güncellendi.')),
          );

          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Hesap bilgilerini güncelleme başarısız.'),
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
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedCompanyType,
                decoration: const InputDecoration(labelText: 'Şirket Türü'),
                items: companyTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCompanyType = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen bir şirket türü seçin.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _updateMarketProfile,
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
