import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'order_confirmation_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color.fromRGBO(133, 8, 62, 1),
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
        backgroundColor: const Color.fromRGBO(133, 8, 62, 1),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: cartProvider.cartItems.isEmpty
                ? const Center(child: Text("Sepetiniz boş."))
                : ListView.builder(
                    itemCount: cartProvider.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartProvider.cartItems[index];
                      return ListTile(
                        title: Text(item.name),
                        subtitle: Text(
                            "Fiyat: ${item.price.toStringAsFixed(2)} ₺ x ${item.quantity}"),
                        trailing: Text(
                          "Toplam: ${item.totalPrice.toStringAsFixed(2)} ₺",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                  ),
          ),
          if (cartProvider.cartItems.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OrderConfirmationScreen(),
                    ),
                  );
                },
                child: const Text(
                  "Sepeti Onayla",
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
