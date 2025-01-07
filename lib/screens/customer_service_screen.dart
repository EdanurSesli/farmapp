import 'package:flutter/material.dart';

class CustomerServiceScreen extends StatefulWidget {
  const CustomerServiceScreen({super.key});

  @override
  _CustomerServiceScreenState createState() => _CustomerServiceScreenState();
}

class _CustomerServiceScreenState extends State<CustomerServiceScreen> {
  final List<Map<String, String>> _qaPairs = [
    {
      'question': 'Siparişim ne zaman teslim edilir?',
      'answer': 'Siparişler genellikle 3-5 iş günü içinde teslim edilmektedir.'
    },
    {
      'question': 'İade politikası nedir?',
      'answer':
          'Ürünlerinizi teslim aldıktan sonra 14 gün içinde iade edebilirsiniz.'
    },
    {
      'question': 'Kargo ücreti ne kadar?',
      'answer':
          'Kargo ücreti sipariş toplamınıza bağlı olarak değişmektedir. 200₺ üzeri siparişlerde ücretsizdir.'
    },
    {
      'question': 'Ürünler nasıl paketleniyor?',
      'answer':
          'Ürünler, tazelik ve güvenlik için özel ambalajlarla paketlenmektedir.'
    },
    {
      'question': 'Ödeme yöntemleri nelerdir?',
      'answer':
          'Kredi kartı, banka kartı ve kapıda ödeme seçenekleri mevcuttur.'
    },
    {
      'question': 'Ürün stok durumu nasıl öğrenilir?',
      'answer': 'Ürün detay sayfasında stok durumunu görebilirsiniz.'
    },
    {
      'question': 'Siparişimi nasıl takip edebilirim?',
      'answer':
          'Hesabınıza giriş yaparak siparişlerim kısmından takip edebilirsiniz.'
    },
    {
      'question': 'Müşteri hizmetlerine nasıl ulaşabilirim?',
      'answer': 'Bize 0850 123 45 67 numaralı telefondan ulaşabilirsiniz.'
    },
    {
      'question': 'Satış sonrası destek sunuyor musunuz?',
      'answer': 'Evet, satış sonrası destek ekibimiz her zaman hizmetinizdedir.'
    },
  ];

  final List<Map<String, String>> _chatHistory = [];

  void _onQuestionPressed(String question, String answer) {
    setState(() {
      _chatHistory.add({'question': question, 'answer': answer});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Müşteri Hizmetleri',
          style: TextStyle(
            fontFamily: 'Font',
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 114, 154, 104),
        elevation: 0,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _chatHistory.length,
              itemBuilder: (context, index) {
                final qa = _chatHistory[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Soru: ${qa['question']}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Cevap: ${qa['answer']}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1, color: Colors.grey),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: _qaPairs.map((qa) {
                return ElevatedButton(
                  onPressed: () =>
                      _onQuestionPressed(qa['question']!, qa['answer']!),
                  child: Text(qa['question']!),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 114, 154, 104),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 16.0),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
