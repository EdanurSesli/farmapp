import 'dart:convert';
import 'package:farmapp/models/category.dart';
import 'package:farmapp/models/product_add.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProductService {
  // Ürün ekleme
  Future<bool> addProduct(Product product) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    if (token == null) {
      throw Exception('Geçerli bir token bulunamadı.');
    }

    final url = Uri.parse('https://farmtwomarket.com/api/Product/AddProduct');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
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
        throw Exception('Ürün eklenirken hata oluştu: ${response.body}');
      }
    } catch (error) {
      throw Exception('Ürün eklenirken hata oluştu: $error');
    }
  }

  // Tüm ürünleri almak için
  Future<List<Product>> getAllProducts() async {
    final url = Uri.parse('https://farmtwomarket.com/api/Product/GetProducts');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((product) => Product.fromJson(product)).toList();
      } else {
        throw Exception('Tüm ürünler alınırken hata oluştu: ${response.body}');
      }
    } catch (error) {
      throw Exception('Ürünler alınırken hata oluştu: $error');
    }
  }

  // Kullanıcının ürünlerini almak için
  Future<List<Product>> fetchProducts(String token) async {
    final url =
        Uri.parse('https://farmtwomarket.com/api/Product/GetProductsByFarmer');
    final headers = {
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        print('API Yanıtı: ${response.body}');

        final List<dynamic> data = json.decode(response.body);
        return data.map((product) => Product.fromJson(product)).toList();
      } else {
        throw Exception('Ürünler alınırken hata oluştu: ${response.body}');
      }
    } catch (error) {
      throw Exception('Ürünler alınırken hata oluştu: $error');
    }
  }

  // Ürün silme
  Future<bool> softDeleteProduct(String token, int id) async {
    final url = Uri.parse(
        'https://farmtwomarket.com/api/Product/SoftDeleteProduct/$id');
    final headers = {
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.delete(url, headers: headers);

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Response body: ${response.body}');
        throw Exception('Silme işlemi başarısız: ${response.body}');
      }
    } catch (error) {
      print('Hata oluştu: $error');
      throw Exception('Ürün silinirken hata oluştu: $error');
    }
  }

  // Ürün güncelleme
  Future<bool> updateProduct(Product product, String token) async {
    final url =
        Uri.parse('https://farmtwomarket.com/api/Product/UpdateProduct');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.put(
        url,
        headers: headers,
        body: json.encode(product.toJson()),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Güncelleme hatası: ${response.body}');
        throw Exception('Ürün güncellenirken hata oluştu: ${response.body}');
      }
    } catch (error) {
      print('Hata oluştu: $error');
      throw Exception('Ürün güncellenirken hata oluştu: $error');
    }
  }

  // Kategorileri almak için
  Future<List<Category>> getCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Geçerli bir token bulunamadı.');
    }

    try {
      final response = await http.get(
        Uri.parse('https://farmtwomarket.com/api/Product/GetCategory'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((category) => Category.fromJson(category)).toList();
      } else {
        throw Exception('Kategoriler alınamadı: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Kategoriler alınırken hata oluştu: $error');
    }
  }
}
