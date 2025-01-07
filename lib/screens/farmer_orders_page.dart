import 'package:farmapp/models/market_farmer_order.dart';
import 'package:farmapp/services/ProductService.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FarmerOrdersPage extends StatefulWidget {
  final ProductService productService;

  const FarmerOrdersPage({Key? key, required this.productService})
      : super(key: key);

  @override
  _FarmerOrdersPageState createState() => _FarmerOrdersPageState();
}

class _FarmerOrdersPageState extends State<FarmerOrdersPage> {
  late Future<List<FarmerOrder>> ordersFuture;

  @override
  void initState() {
    super.initState();
    ordersFuture = widget.productService.getSoldOrders();
  }

  String formatOrderDate(DateTime date) {
    return DateFormat('dd.MM.yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Siparişlerim",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: const Color.fromARGB(255, 114, 154, 104),
      ),
      body: FutureBuilder<List<FarmerOrder>>(
        future: ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No orders found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final order = snapshot.data![index];
                double totalPrice = order.products.fold(0,
                    (sum, product) => sum + (product.price * product.quantity));

                return Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sipariş Tarihi: ${formatOrderDate(order.orderDate)}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Market Adı: ${order.marketReceiverName}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const Divider(),
                        const Text(
                          'Ürünler:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        ...order.products.map((product) => Text(
                            '- ${product.productName} (Miktar: ${product.quantity}, Fiyat: ₺${product.price.toStringAsFixed(2)})')),
                        const SizedBox(height: 8),
                        Text(
                          'Toplam Fiyat: ₺${totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
