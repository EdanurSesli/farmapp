import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:farmapp/models/product_add.dart';
import 'package:farmapp/services/ProductService.dart';

class UpdateProductPage extends StatefulWidget {
  final Product product;
  final String token;

  const UpdateProductPage({
    Key? key,
    required this.product,
    required this.token,
  }) : super(key: key);

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
  late TextEditingController _productQuantity;

  final ImagePicker _picker = ImagePicker();
  List<File?> _selectedImages = [null, null, null];
  List<String?> _base64Images = [null, null, null];

  final List<String> unitTypes = ['Kilogram', 'Adet', 'Litre', 'Diğer'];
  final List<String> qualityOptions = ['A (En iyi)', 'B', 'C'];
  final List<Map<String, dynamic>> categories = [
    {'id': 1, 'name': 'Meyve'},
    {'id': 2, 'name': 'Sebze'},
    {'id': 3, 'name': 'Hayvansal Ürünler'},
    {'id': 4, 'name': 'Tahıllar ve Baklagiller'},
    {'id': 5, 'name': 'Ev Yapımı Ürünler'}
  ];

  late String? selectedUnitType;
  late String? selectedQuality;
  late int? selectedCategoryId;
  late bool isActive;

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
    _productQuantity =
        TextEditingController(text: widget.product.quantity.toString());

    selectedUnitType = widget.product.unitType;
    selectedQuality = widget.product.quality;
    selectedCategoryId = widget.product.categoryId;
    isActive = widget.product.isActive;

    _base64Images[0] = widget.product.image1;
    _base64Images[1] = widget.product.image2;
    _base64Images[2] = widget.product.image3;
  }

  Future<void> _pickImage(int index) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImages[index] = File(pickedFile.path);
        _base64Images[index] =
            base64Encode(_selectedImages[index]!.readAsBytesSync());
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
        borderSide:
            BorderSide(color: Color.fromARGB(255, 114, 154, 104), width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide:
            BorderSide(color: Color.fromARGB(255, 114, 154, 104), width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide:
            BorderSide(color: Color.fromARGB(255, 114, 154, 104), width: 2),
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
        categoryId: selectedCategoryId ?? 0,
        quality: selectedQuality ?? '',
        price: double.tryParse(_productPrice.text) ?? 0.0,
        image1: _base64Images[0],
        image2: _base64Images[1],
        image3: _base64Images[2],
        unitType: selectedUnitType ?? '',
        quantity: int.tryParse(_productQuantity.text) ?? 0,
        isActive: isActive,
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
                  decoration: _customInputDecoration("Ürün açıklamasını girin"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ürün miktarı gerekli';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text("Ürün Ağırlık / Miktar",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _productWeightOrAmount,
                  keyboardType: TextInputType.number,
                  decoration: _customInputDecoration("Ürün miktarını girin"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ürün miktarı gerekli';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text("Adres(İlçe-İl)",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _productAddress,
                  decoration: _customInputDecoration("Ürün adresini girin"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ürün adresi gerekli';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text("Detaylı Adres",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _productFullAddress,
                  decoration: _customInputDecoration("Detaylı adresi girin"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ürün detaylı adresi gerekli';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text("Kategori Seçimi",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                DropdownButtonFormField<int>(
                  value: selectedCategoryId,
                  decoration: _customInputDecoration("Kategori seçin"),
                  items: categories.map((category) {
                    return DropdownMenuItem<int>(
                      value: category['id'],
                      child: Text(category['name']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategoryId = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                const Text("Kalite Seçimi",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedQuality,
                  decoration: _customInputDecoration("Kalite seçin"),
                  items: qualityOptions.map((quality) {
                    return DropdownMenuItem<String>(
                      value: quality,
                      child: Text(quality),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedQuality = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                const Text("Birimi Seçin",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedUnitType,
                  decoration: _customInputDecoration("Birimi seçin"),
                  items: unitTypes.map((unit) {
                    return DropdownMenuItem<String>(
                      value: unit,
                      child: Text(unit),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedUnitType = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                const Text("Ürün Resimleri",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                for (int i = 0; i < 3; i++)
                  Column(
                    children: [
                      _selectedImages[i] != null
                          ? Image.file(_selectedImages[i]!,
                              width: 100, height: 100, fit: BoxFit.cover)
                          : _base64Images[i] != null
                              ? Image.memory(base64Decode(_base64Images[i]!),
                                  width: 100, height: 100, fit: BoxFit.cover)
                              : const Text("Resim seçilmedi"),
                      ElevatedButton(
                        onPressed: () => _pickImage(i),
                        child: Text("Resim ${i + 1} Seç"),
                      ),
                    ],
                  ),
                const SizedBox(height: 16),
                const Text("Pasif mi?",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromARGB(255, 114, 154, 104),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Pasif mi?",
                        style: TextStyle(fontSize: 16),
                      ),
                      Switch(
                        value: isActive,
                        onChanged: (value) {
                          setState(() {
                            isActive = value;
                          });
                        },
                        activeColor: const Color.fromARGB(255, 114, 154, 104),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: _updateProduct,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: const Color.fromRGBO(133, 8, 62, 1),
                      foregroundColor: Colors.white,
                    ),
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
