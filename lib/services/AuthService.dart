import 'dart:convert';
import 'package:farmapp/models/farmer_register.dart';
import 'package:farmapp/models/market_register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = 'https://farmtwomarket.com/api/Auth';

  Future<FarmerRegister?> registerFarmer(FarmerRegister farmer) async {
    final response = await http.post(
      Uri.parse('$baseUrl/FarmerRegister'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(farmer.toJson()),
    );

    if (response.statusCode == 200) {
      return farmer;
    } else {
      print('Farmer registration error: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null;
    }
  }

  Future<MarketRegister?> registerMarket(MarketRegister market) async {
    final response = await http.post(
      Uri.parse('$baseUrl/MarketRegister'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(market.toJson()),
    );

    if (response.statusCode == 200) {
      return market;
    } else {
      print('Market registration error: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null;
    }
  }

  Future<bool> verifyEmail(String token, int confirmationNumber) async {
    final url = Uri.parse('https://farmtwomarket.com/api/Auth/ConfirmMail');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final body = json.encode({
      'number': confirmationNumber,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isEmailVerified', true);
          return true;
        } else {
          throw Exception(responseData['message'] ?? 'Doğrulama başarısız.');
        }
      } else {
        throw Exception(
            'Doğrulama başarısız: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (error) {
      throw Exception('Email doğrulama işlemi sırasında hata oluştu: $error');
    }
  }
}
