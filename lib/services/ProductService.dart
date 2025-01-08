import 'dart:convert';
import 'package:farmapp/models/cart_item.dart';
import 'package:farmapp/models/category.dart';
import 'package:farmapp/models/checkout_session_response.dart';
import 'package:farmapp/models/market_farmer_order.dart';
import 'package:farmapp/models/product_add.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProductService {
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

  Future<bool> updateProduct(Product product, String token) async {
    final url = Uri.parse(
        'https://farmtwomarket.com/api/Product/UpdateProduct?id=${product.id}');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final Map<String, dynamic> productJson = product.toJson();

      if (product.image1 != null && product.image1!.isNotEmpty) {
        productJson['image1'] = product.image1;
      }
      if (product.image2 != null && product.image2!.isNotEmpty) {
        productJson['image2'] = product.image2;
      }
      if (product.image3 != null && product.image3!.isNotEmpty) {
        productJson['image3'] = product.image3;
      }

      final response = await http.put(
        url,
        headers: headers,
        body: json.encode(productJson),
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

  Future<List<Category>> getCategories() async {
    const String apiUrl = 'https://farmtwomarket.com/api/Product/GetCategory';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => Category.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (error) {
      print("Kategori API çağrısı sırasında hata oluştu: $error");
      rethrow;
    }
  }

  Future<bool> addFavorite(int productId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    if (token == null) {
      throw Exception('Geçerli bir token bulunamadı.');
    }

    final url = Uri.parse(
        'https://farmtwomarket.com/api/Favorite/add?productId=$productId');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.post(url, headers: headers);

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Favori eklenirken hata oluştu: ${response.body}');
      }
    } catch (error) {
      throw Exception('Favori eklenirken hata oluştu: $error');
    }
  }

  // Favori ürünleri listelemek için API çağrısı
  Future<List<Product>> getFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    if (token == null) {
      throw Exception('Geçerli bir token bulunamadı.');
    }

    final url = Uri.parse('https://farmtwomarket.com/api/Favorite/favorites');
    final headers = {
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((product) => Product.fromJson(product)).toList();
      } else {
        throw Exception('Favoriler alınırken hata oluştu: ${response.body}');
      }
    } catch (error) {
      throw Exception('Favoriler alınırken hata oluştu: $error');
    }
  }

  // Favoriden kaldırmak için API çağrısı
  Future<bool> removeFavorite(int productId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    if (token == null) {
      throw Exception('Geçerli bir token bulunamadı.');
    }

    final url = Uri.parse(
        'https://farmtwomarket.com/api/Favorite/remove?productId=$productId');
    final headers = {
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.delete(url, headers: headers);

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(
            'Favoriden kaldırılırken hata oluştu: ${response.body}');
      }
    } catch (error) {
      throw Exception('Favoriden kaldırılırken hata oluştu: $error');
    }
  }

  Future<void> addToCart(int productId, int weightOrAmount) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    if (token == null) {
      throw Exception('Geçerli bir token bulunamadı.');
    }

    final url = Uri.parse('https://farmtwomarket.com/api/Cart/AddToCart');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final body = json.encode({
      'productId': productId,
      'weightOrAmount': weightOrAmount,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        print('Ürün başarıyla sepete eklendi.');
      } else {
        print('Hata: ${response.body}');
        throw Exception('Sepete eklerken hata oluştu: ${response.body}');
      }
    } catch (error) {
      print('Hata oluştu: $error');
      throw Exception('Sepete eklerken hata oluştu: $error');
    }
  }

  Future<Cart> getCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    if (token == null) {
      throw Exception('Geçerli bir token bulunamadı.');
    }

    final url = Uri.parse('https://farmtwomarket.com/api/Cart/GetCart');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Cart.fromJson(data); // Tüm cevabı `Cart` nesnesine dönüştür
      } else {
        throw Exception('Sepet verileri alınamadı: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Hata: $e');
    }
  }

  Future<http.Response> removeCartItem(int cartItemId, String token) async {
    try {
      final response = await http.delete(
        Uri.parse(
            'https://farmtwomarket.com/api/Cart/RemoveCartItem/$cartItemId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      return response;
    } catch (e) {
      throw Exception("Sepet öğesi kaldırılırken bir hata oluştu: $e");
    }
  }

  Future<String?> createCheckoutSession() async {
    final url = Uri.parse(
        "https://farmtwomarket.com/api/Payment/CreateCheckoutSession");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception("Token bulunamadı. Giriş yapmanız gerekiyor.");
    }

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final checkoutSession = CheckoutSessionResponse.fromJson(responseData);
        return checkoutSession.url;
      } else {
        throw Exception("Ödeme oturumu oluşturulamadı: ${response.body}");
      }
    } catch (e) {
      throw Exception("Hata: $e");
    }
  }

  Future<Map<String, dynamic>> createOrderFromCart(String token) async {
    final url =
        Uri.parse('https://farmtwomarket.com/api/Cart/CreateOrderFromCart');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      throw Exception("Token bulunamadı. Giriş yapmanız gerekiyor.");
    }

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Sipariş oluşturulamadı: ${response.body}');
    }
  }

  Future<List<MarketReceiverOrder>> getPaidOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception("Token bulunamadı. Giriş yapmanız gerekiyor.");
    }

    final response = await http.get(
      Uri.parse('https://farmtwomarket.com/api/Cart/GetPaidOrders'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList
          .map((jsonItem) => MarketReceiverOrder.fromJson(jsonItem))
          .toList();
    } else {
      throw Exception(
          'Siparişler yüklenirken hata oluştu: ${response.statusCode}');
    }
  }

  Future<List<FarmerOrder>> getSoldOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception("Token bulunamadı. Giriş yapmanız gerekiyor.");
    }

    final response = await http.get(
      Uri.parse('https://farmtwomarket.com/api/Cart/GetSoldOrders'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList
          .map((jsonItem) => FarmerOrder.fromJson(jsonItem))
          .toList();
    } else {
      throw Exception(
          'Siparişler yüklenirken hata oluştu: ${response.statusCode}');
    }
  }
}
