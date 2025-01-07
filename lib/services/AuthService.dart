import 'dart:convert';
import 'package:farmapp/models/UpdateFarmerProfile.dart';
import 'package:farmapp/models/UpdateMarketProfile.dart';
import 'package:farmapp/models/change_password.dart';
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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('firstName', farmer.firstName ?? '');
      await prefs.setString('lastName', farmer.lastName ?? '');
      await prefs.setString('userName', farmer.userName ?? '');
      await prefs.setString('email', farmer.email ?? '');
      await prefs.setString('adress', farmer.adress ?? '');
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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('firstName', market.firstName ?? '');
      await prefs.setString('lastName', market.lastName ?? '');
      await prefs.setString('userName', market.userName ?? '');
      await prefs.setString('email', market.email ?? '');
      await prefs.setString('adress', market.adress);
      await prefs.setString('marketName', market.marketName);
      await prefs.setString('companyType', market.companyType);
      return market;
    } else {
      print('Market registration error: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null;
    }
  }

  Future<Map<String, String?>> getUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return {
      'firstName': prefs.getString('firstName'),
      'lastName': prefs.getString('lastName'),
      'userName': prefs.getString('userName'),
      'email': prefs.getString('email'),
      'adress': prefs.getString('adress'),
      'marketName': prefs.getString('marketName'),
      'companyType': prefs.getString('companyType'),
    };
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

  Future<bool> changePassword(ChangePassword request) async {
    final url = Uri.parse('https://farmtwomarket.com/api/Auth/ChangePassword');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    // Token kontrolü
    if (token == null) {
      throw Exception('Kullanıcı oturum açmamış veya token bulunamadı.');
    }

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'currentPassword': request.currentPassword,
          'newPassword': request.newPassword,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        final responseBody = jsonDecode(response.body);
        throw Exception(
            'Şifre değiştirme başarısız: ${responseBody['message'] ?? 'Hata oluştu.'}');
      }
    } catch (e) {
      print('Şifre değiştirme sırasında bir hata oluştu: $e');
      throw Exception('Şifre değiştirme işlemi başarısız.');
    }
  }

  Future<bool> updateMarketProfile(UpdateMarketProfile request) async {
    final url =
        Uri.parse('https://farmtwomarket.com/api/Auth/UpdateMarketProfile');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    // Token kontrolü
    if (token == null) {
      throw Exception('Kullanıcı oturum açmamış veya token bulunamadı.');
    }

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'firstName': request.firstName,
          'lastName': request.lastName,
          'userName': request.userName,
          'email': request.email,
          'adress': request.adress,
          'marketName': request.marketName,
          'companyType': request.companyType,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        final responseBody = jsonDecode(response.body);
        throw Exception(
            'Hesap bilgilerini güncelleme başarısız: ${responseBody['message'] ?? 'Hata oluştu.'}');
      }
    } catch (e) {
      print('Hesap bilgilerini güncelleme sırasında bir hata oluştu: $e');
      throw Exception('Hesap bilgilerini güncelleme işlemi başarısız.');
    }
  }

  Future<bool> updateFarmerProfile(UpdateFarmerProfile request) async {
    final url =
        Uri.parse('https://farmtwomarket.com/api/Auth/UpdateFarmerProfile');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    // Token kontrolü
    if (token == null) {
      throw Exception('Kullanıcı oturum açmamış veya token bulunamadı.');
    }

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'firstName': request.firstName,
          'lastName': request.lastName,
          'userName': request.userName,
          'email': request.email,
          'adress': request.adress,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        final responseBody = jsonDecode(response.body);
        throw Exception(
            'Farmer profili güncelleme başarısız: ${responseBody['message'] ?? 'Hata oluştu.'}');
      }
    } catch (e) {
      print('Farmer profili güncelleme sırasında bir hata oluştu: $e');
      throw Exception('Farmer profili güncelleme işlemi başarısız.');
    }
  }
}
