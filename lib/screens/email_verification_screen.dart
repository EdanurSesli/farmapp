import 'package:farmapp/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EmailVerificationScreen extends StatefulWidget {
  final String token;
  final int confirmationNumber;

  const EmailVerificationScreen({
    Key? key,
    required this.token,
    required this.confirmationNumber,
  }) : super(key: key);

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final TextEditingController _verificationCodeController =
      TextEditingController();
  bool _isLoading = false;

  Future<void> _verifyEmail() async {
    String confirmationCodeStr = _verificationCodeController.text.trim();

    if (confirmationCodeStr.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen doğrulama kodunu girin.')),
      );
      return;
    }

    int? confirmationNumber = int.tryParse(confirmationCodeStr);
    if (confirmationNumber == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Geçersiz doğrulama kodu.')),
      );
      return;
    }

    final url = Uri.parse(
        'https://farmtwomarket.com/api/Auth/ConfirmMail/?number=${confirmationNumber}');

    setState(() {
      _isLoading = true;
    });

    try {
      final body = json.encode({
        'number': confirmationNumber,
      });

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email doğrulandı.')),
        );
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var email = prefs.getString('email');
        var username = prefs.getString('userName');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(
              userName: username!,
              email: email!,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Doğrulama başarısız: ${response.reasonPhrase}')),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bir hata oluştu: $Error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Doğrulama'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Emailinize gönderilen doğrulama kodunu giriniz.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _verificationCodeController,
              keyboardType: TextInputType.number,
              maxLength: 4,
              decoration: InputDecoration(
                labelText: 'Doğrulama Kodu',
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
              ),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _verifyEmail,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: const Color.fromRGBO(133, 8, 62, 1),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Doğrula'),
                  ),
          ],
        ),
      ),
    );
  }
}
