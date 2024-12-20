import 'package:flutter/material.dart';

class SellerVerificationScreen extends StatefulWidget {
  const SellerVerificationScreen({super.key});

  @override
  _SellerVerificationScreenState createState() =>
      _SellerVerificationScreenState();
}

class _SellerVerificationScreenState extends State<SellerVerificationScreen> {
  bool _isDocumentUploaded = false;

  @override
  void initState() {
    super.initState();
    _checkIfDocumentUploaded();
  }

  void _checkIfDocumentUploaded() {
    setState(() {
      _isDocumentUploaded = false;
    });
  }

  void _uploadDocument() {
    setState(() {
      _isDocumentUploaded = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Belgeniz yüklendi, kontrol aşamasında.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Satıcı Doğrulama'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Colors.grey[100],
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                border: Border.all(color: Colors.blue, width: 1.5),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Text(
                _isDocumentUploaded
                    ? 'Belgeniz yüklendi, kontrol aşamasında.'
                    : 'Çiftçilik yaptığınıza dair bir belgeniz veya ürünlerinizin içeriğine ilişkin belgeleriniz varsa yükleyiniz. Bu belgeleri yükleyerek profilinizde doğruluğunuzu ve güvenilirliğinizi gösterebilirsiniz.',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            if (!_isDocumentUploaded)
              Center(
                child: ElevatedButton.icon(
                  onPressed: _uploadDocument,
                  icon: const Icon(Icons.add),
                  label: const Text('Belge Ekle'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 24.0,
                    ),
                    backgroundColor: const Color.fromRGBO(133, 8, 62, 1),
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
