import 'dart:convert';
import 'package:farmapp/models/farmer_register.dart';
import 'package:farmapp/models/market_register.dart';
import 'package:http/http.dart' as http;

class AuthService {
  Future<FarmerRegister?> registerFarmer(FarmerRegister farmer) async {
    final response = await http.post(
      Uri.parse('https://farmtwomarket.com/api/Auth/FarmerRegister'),
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
      Uri.parse('https://farmtwomarket.com/api/Auth/MarketRegister'),
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

  Future<bool> verifyEmail(String userId, String verificationCode) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://farmtwomarket.com/api/Auth/ConfirmMail?id=$userId&number=$verificationCode'),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['success'] ?? false;
      } else {
        throw Exception('Doğrulama başarısız: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('API çağrısı sırasında hata oluştu: $e');
    }
  }
}
