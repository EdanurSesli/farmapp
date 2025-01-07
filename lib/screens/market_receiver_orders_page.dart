import 'package:farmapp/models/market_farmer_order.dart';
import 'package:farmapp/services/ProductService.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Tarih formatlama için

class MarketReceiverOrdersPage extends StatefulWidget {
  final ProductService productService;

  const MarketReceiverOrdersPage({Key? key, required this.productService})
      : super(key: key);

  @override
  _MarketReceiverOrdersPageState createState() =>
      _MarketReceiverOrdersPageState();
}

class _MarketReceiverOrdersPageState extends State<MarketReceiverOrdersPage> {
  late Future<List<MarketReceiverOrder>> ordersFuture;

  @override
  void initState() {
    super.initState();
    ordersFuture = widget.productService.getPaidOrders();
  }

  String formatOrderDate(DateTime date) {
    // Tarihi formatlıyoruz
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
      body: FutureBuilder<List<MarketReceiverOrder>>(
        future: ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Hiç sipariş bulunamadı.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final order = snapshot.data![index];
                double totalPrice = order.items
                    .fold(0, (sum, item) => sum + (item.price * item.quantity));

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
                          'Toplam Fiyat: ₺${totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const Divider(),
                        const Text(
                          'Ürünler:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        ...order.items.map((item) => Text(
                            '- ${item.productName} (Miktar: ${item.quantity}, Fiyat: ₺${item.price.toStringAsFixed(2)})')),
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
