import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:farmapp/models/product_add.dart';
import 'package:farmapp/services/ProductService.dart';

class UpdateProductPage extends StatefulWidget {
  final Product product;
  final String token;

  const UpdateProductPage(
      {super.key, required this.product, required this.token});

  @override
  _UpdateProductPageState createState() => _UpdateProductPageState();
}

class _UpdateProductPageState extends State<UpdateProductPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _productName;
  late TextEditingController _productDescription;
  late TextEditingController _productWeightOrAmount;
  late TextEditingController _productAddress;
  late TextEditingController _productFullAddress;
  late TextEditingController _productPrice;

  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  String? _base64Image; // Türü tek bir string olarak değiştirildi

  final List<String> unitTypes = ['Kilogram', 'Adet', 'Litre', 'Diğer'];
  final List<String> qualityOptions = ['A (En iyi)', 'B', 'C'];
  final List<String> categories = [
    'Meyve',
    'Sebze',
    'Hayvansal Ürünler',
    'Tahıllar ve Baklagiller',
    'Ev Yapımı Ürünler'
  ];

  late String? selectedUnitType;
  late String? selectedQuality;
  late String? selectedCategory;

  @override
  void initState() {
    super.initState();
    _productName = TextEditingController(text: widget.product.name);
    _productDescription =
        TextEditingController(text: widget.product.description);
    _productWeightOrAmount =
        TextEditingController(text: widget.product.weightOrAmount.toString());
    _productAddress = TextEditingController(text: widget.product.address);
    _productFullAddress =
        TextEditingController(text: widget.product.fullAddress);
    _productPrice =
        TextEditingController(text: widget.product.price.toString());

    selectedUnitType = widget.product.unitType;
    selectedQuality = widget.product.quality;
    selectedCategory = widget.product.categoryId.toString();
    _base64Image =
        widget.product.images.isNotEmpty ? widget.product.images[0] : null;
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _base64Image = base64Encode(_selectedImage!.readAsBytesSync());
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Hiçbir resim seçilmedi.")),
      );
    }
  }

  InputDecoration _customInputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blue, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blue, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    );
  }

  Future<void> _updateProduct() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final updatedProduct = Product(
        id: widget.product.id,
        name: _productName.text,
        description: _productDescription.text,
        weightOrAmount: int.tryParse(_productWeightOrAmount.text) ?? 0,
        address: _productAddress.text,
        fullAddress: _productFullAddress.text,
        categoryId: selectedCategory != null && selectedCategory!.isNotEmpty
            ? int.parse(selectedCategory!)
            : 0,
        quality: selectedQuality ?? '',
        price: double.tryParse(_productPrice.text) ?? 0.0,
        images: _base64Image != null ? [_base64Image!] : widget.product.images,
        unitType: selectedUnitType ?? '',
        quantity: widget.product.quantity,
        isActive: true,
      );

      final productService = ProductService();
      bool success =
          await productService.updateProduct(updatedProduct, widget.token);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Ürün başarıyla güncellendi.")),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Ürün güncellenirken bir hata oluştu.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ürün Güncelle'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Ürün Adı",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _productName,
                  decoration: _customInputDecoration("Ürünün adını girin"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ürün adı gerekli';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text("Ürün Açıklaması",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _productDescription,
                  decoration:
                      _customInputDecoration("Ürünün açıklamasını girin"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ürün açıklaması gerekli';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text("Ürün Resmi",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Center(
                  child: Column(
                    children: [
                      _selectedImage != null
                          ? Image.file(
                              _selectedImage!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            )
                          : _base64Image != null
                              ? Image.memory(
                                  base64Decode(_base64Image!),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                )
                              : const Text("Resim seçilmedi"),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _pickImage,
                        child: const Text("Resim Seç"),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: _updateProduct,
                    child: const Text('Ürünü Güncelle'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
