import 'dart:convert';
import 'package:farmapp/models/product_add.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProductService {
  // Ürün ekleme
  Future<Product> addProduct(Product product) async {
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
        // Backend'den gelen JSON verisini al
        final Map<String, dynamic> data = json.decode(response.body);

        // Backend'in döndürdüğü JSON'dan id'yi al
        final String productId =
            data['id']; // Örnek: {"id": "123", "name": "product", ...}

        // Yeni oluşturulan ürünün ID'si ile birlikte Product nesnesi oluştur
        return Product.fromJson({
          ...data, // Backend'den gelen diğer verileri kullan
          'id': productId, // id'yi backend'den al
        });
      } else {
        throw Exception('Ürün eklenirken hata oluştu');
      }
    } catch (error) {
      throw Exception("Ürün eklenirken hata oluştu: $error");
    }
  }

  // Ürünleri listeleme
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

  // Ürün silme (Soft delete)
  Future<bool> softDeleteProduct(String token, String productId) async {
    final url = Uri.parse(
        'https://farmtwomarket.com/api/Product/SoftDeleteProduct/$productId');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.delete(
        url,
        headers: headers,
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception("Silme işlemi başarısız: ${response.body}");
      }
    } catch (error) {
      throw Exception("Ürün silinirken hata oluştu: $error");
    }
  }

  Future<List<Product>> getAllProducts(String token) async {
    final url = Uri.parse('https://farmtwomarket.com/api/Product/GetProducts');
    final headers = {
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        print(response.body); // response'dan gelen veriyi kontrol et
        final List<dynamic> data = json.decode(response.body);
        return data.map((product) => Product.fromJson(product)).toList();
      } else {
        throw Exception('Tüm ürünler alınırken hata oluştu: ${response.body}');
      }
    } catch (error) {
      throw Exception('Ürünler alınırken hata oluştu: $error');
    }
  }
}
