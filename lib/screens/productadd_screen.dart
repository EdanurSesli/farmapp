import 'package:farmapp/models/product_add.dart';
import 'package:farmapp/providers/product_provider.dart';
import 'package:farmapp/screens/home_screen.dart';
import 'package:farmapp/services/ProductService.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ProductAddScreen extends StatefulWidget {
  const ProductAddScreen({super.key});

  @override
  _ProductAddScreenState createState() => _ProductAddScreenState();
}

class _ProductAddScreenState extends State<ProductAddScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _productName = TextEditingController();
  final TextEditingController _productDescription = TextEditingController();
  final TextEditingController _productWeightOrAmount = TextEditingController();
  final TextEditingController _productAddress = TextEditingController();
  final TextEditingController _productFullAddress = TextEditingController();
  final TextEditingController _productPrice = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  List<String>? _base64Image = [];

  final List<String> unitTypes = ['Kilogram', 'Adet', 'Litre', 'Diğer'];
  final List<String> qualityOptions = ['A (En iyi)', 'B', 'C'];
  final ProductService productService = ProductService();
  List<Map<String, dynamic>> categories = [];
  int? selectedCategoryId;

  String? selectedUnitType = 'Kilogram';
  String? selectedQuality = 'A (En iyi)';

  Future<void> pickImage() async {
    if (_base64Image != null && _base64Image!.length >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("En fazla 3 resim ekleyebilirsiniz.")),
      );
      return;
    }

    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        final bytes = _selectedImage!.readAsBytesSync();
        final base64Image = base64Encode(bytes);
        _base64Image?.add(base64Image);
      });
    } else {
      print('Hiçbir resim seçilmedi.');
    }
  }

  Future<void> _loadCategories() async {
    try {
      final categoryData = await productService.getCategories();
      setState(() {
        categories = categoryData.map<Map<String, dynamic>>((category) {
          return {
            'id': category.id as int,
            'name': category.name as String,
          };
        }).toList();
      });
    } catch (e) {
      print("Kategoriler yüklenirken hata oluştu: $e");
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

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 114, 154, 104),
        title: const Text(
          'Ürün Ekle',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
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
                  maxLines: 3,
                  controller: _productDescription,
                  decoration:
                      _customInputDecoration("Ürün hakkında kısa açıklama"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ürün açıklaması gerekli';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text("Ağırlık / Miktar",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _productWeightOrAmount,
                  decoration: _customInputDecoration("Ürünün miktarını girin"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ağırlık veya miktar';
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
                  decoration: _customInputDecoration("Adres(İlçe-İl)"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Adres gerekli';
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
                  decoration: _customInputDecoration("Detaylı Adres"),
                ),
                const SizedBox(height: 16),
                const Text("Kategori",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                categories.isNotEmpty
                    ? DropdownButtonFormField<int>(
                        value: selectedCategoryId,
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
                        decoration: _customInputDecoration("Kategori seçin"),
                        validator: (value) {
                          if (value == null) {
                            return 'Kategori seçin';
                          }
                          return null;
                        },
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
                const SizedBox(height: 16),
                const Text("Kalite",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedQuality,
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
                  decoration: _customInputDecoration("Kalite seçin"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Kalite seçin';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text("Fiyat",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _productPrice,
                  decoration: _customInputDecoration("Ör: 15 ₺ / kg"),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Fiyat gerekli';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text("Birim Tipi",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedUnitType,
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
                  decoration: _customInputDecoration("Birim tipi seçin"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Birim tipi seçin';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text("Ürün Görselleri",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: pickImage,
                      icon: const Icon(Icons.add_a_photo, color: Colors.white),
                      label: const Text("Fotoğraf Seç"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(133, 8, 62, 1),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _base64Image != null && _base64Image!.isNotEmpty
                          ? Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _base64Image!.map((image) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.memory(
                                    base64Decode(image),
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              }).toList(),
                            )
                          : const Text("Fotoğraf seçilmedi"),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        final int quantity =
                            int.tryParse(_productWeightOrAmount.text) ?? 1;

                        final newProduct = Product(
                          id: 0,
                          name: _productName.text,
                          description: _productDescription.text,
                          weightOrAmount:
                              int.tryParse(_productWeightOrAmount.text) ?? 0,
                          address: _productAddress.text,
                          fullAddress: _productFullAddress.text,
                          categoryId: selectedCategoryId ?? 0,
                          quality: selectedQuality ?? '',
                          quantity:
                              int.tryParse(_productWeightOrAmount.text) ?? 1,
                          price: double.tryParse(_productPrice.text) ?? 0.0,
                          image1: _base64Image!.isNotEmpty
                              ? _base64Image![0]
                              : null,
                          image2: _base64Image!.length > 1
                              ? _base64Image![1]
                              : null,
                          image3: _base64Image!.length > 2
                              ? _base64Image![2]
                              : null,
                          unitType: selectedUnitType ?? '',
                          isActive: true,
                        );

                        final productService = ProductService();
                        bool success =
                            await productService.addProduct(newProduct);

                        if (success) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Ürün başarıyla yüklendi.")),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text("Ürün eklenirken bir hata oluştu.")),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(133, 8, 62, 1),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 8,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.add_circle, size: 20),
                        const SizedBox(width: 8),
                        const Text(
                          "Ürünü Ekle",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
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
