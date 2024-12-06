import 'dart:convert';
import 'package:farmapp/models/product_add.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProductService {
  Future<bool> addProduct(Product product) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    final url = Uri.parse('https://farmtwomarket.com/api/Product/AddProduct');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(product.toJson()),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      throw Exception("Ürün eklenirken hata oluştu: $error");
    }
  }

  Future<List<Product>> fetchProducts(String token) async {
    final response = await http.get(
      Uri.parse('https://farmtwomarket.com/api/Product/GetProductsByFarmer'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((product) => Product.fromJson(product)).toList();
    } else {
      throw Exception('Ürünler alınırken hata oluştu.');
    }
  }
}
