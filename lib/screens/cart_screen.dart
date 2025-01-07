import 'dart:convert';
import 'package:farmapp/screens/order_summary_screen.dart';
import 'package:farmapp/services/ProductService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/cart_provider.dart';
import '../models/order.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color.fromARGB(255, 114, 154, 104),
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sepetim',
          style: TextStyle(
            fontFamily: 'Font',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 114, 154, 104),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder(
        future: cartProvider.fetchCartItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Bir hata oluştu. Lütfen tekrar deneyin."),
            );
          }

          if (cartProvider.cart == null ||
              cartProvider.cart!.cartItems.isEmpty) {
            return const Center(
              child: Text(
                "Sepetiniz boş.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartProvider.cart!.cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartProvider.cart!.cartItems[index];
                    return ListTile(
                      leading: const Icon(Icons.shopping_cart, size: 50),
                      title: Text(item.productName),
                      subtitle: Text(
                        "Ağırlık/Miktar: ${item.weightOrAmount} | Birim Fiyat: ${item.unitPrice.toStringAsFixed(2)} ₺",
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Toplam: ${item.totalPrice.toStringAsFixed(2)} ₺",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              try {
                                await cartProvider
                                    .removeFromCart(item.cartItemId);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Öğe sepetten silindi."),
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text("Silme işlemi sırasında hata: $e"),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 114, 154, 104),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () async {
                    try {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      final token = prefs.getString('token');
                      if (token == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text("Geçersiz oturum, lütfen giriş yapın."),
                          ),
                        );
                        return;
                      }

                      final response =
                          await ProductService().createOrderFromCart(token);

                      if (response != null) {
                        final order = CreateOrderResponse.fromJson(response);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                OrderSummaryScreen(order: order),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Sipariş oluşturulamadı."),
                          ),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Sipariş oluşturulamadı: $e")),
                      );
                    }
                  },
                  child: Text(
                    "Sepeti Onayla (${cartProvider.cart?.totalPrice.toStringAsFixed(2)} ₺)",
                    style: const TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
