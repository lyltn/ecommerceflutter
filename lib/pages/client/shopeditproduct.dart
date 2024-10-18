import 'dart:io';
import 'package:ecommercettl/pages/client/shopbottomnav.dart';
import 'package:ecommercettl/services/brand_service.dart';
import 'package:ecommercettl/services/category_service.dart';
import 'package:ecommercettl/services/product_service.dart';
import 'package:ecommercettl/widget/widget_support.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ShopEditProduct extends StatefulWidget {
  final String productId;

  const ShopEditProduct({Key? key, required this.productId}) : super(key: key);

  @override
  State<ShopEditProduct> createState() => _ShopEditProductState();
}

class _ShopEditProductState extends State<ShopEditProduct> {
  final ProductService productService = ProductService();
  final BrandService brandService = BrandService();
  final CategoryService categoryService = CategoryService();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController affialteController = TextEditingController();
  bool productStatus = true;
  String? categoryValue;
  String? genderValue;
  String? brandValue;
  String? imageUrl;
  File? _image;

  final List<String> genders = ['Nam', 'Nữ', 'Unisex'];

  List<String> categories = [];
  List<String> brands = [];

  @override
  void initState() {
    super.initState();
    loadProductData();
    _fetchData();
  }

  Future<void> _fetchData() async {
    // Fetch categories and brands
    categories = await categoryService.getnameCategories();
    brands = await brandService.getnameBrands();

    // Only update state if the lists are not empty
    if (categories.isNotEmpty && brands.isNotEmpty) {
      // Set initial values for dropdowns based on the fetched data
      // Ensure the category and brand exist in the lists
      setState(() {
        // Ensure selected value exists in the fetched categories
        if (categories.contains(categoryValue)) {
          categoryValue = categoryValue;
        } else {
          categoryValue = categories.isNotEmpty
              ? categories[0]
              : null; // Default to first category if not found
        }

        // Ensure selected value exists in the fetched brands
        if (brands.contains(brandValue)) {
          brandValue = brandValue;
        } else {
          brandValue = brands.isNotEmpty
              ? brands[0]
              : null; // Default to first brand if not found
        }
      });
    } else {
      // If no categories or brands fetched, handle the case accordingly
      setState(() {
        categoryValue = null;
        brandValue = null;
      });
    }
  }

  Future<void> loadProductData() async {
    final product = await productService.getProductById(widget.productId);
    setState(() {
      nameController.text = product?['name'] ?? '';
      descriptionController.text = product?['description'] ?? '';
      priceController.text = product?['price']?.toString() ?? '';
      affialteController.text = product?['affiliate']?.toString() ?? '';
      categoryValue = product?['categoryid'];
      brandValue = product?['brandid'];
      genderValue = product?['sex'];
      productStatus = product?['status'] == 'active';
      imageUrl = product?['imageUrl'];
    });
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Chỉnh sửa sản phẩm',
                style: TextStyle(color: Colors.black)),
            const SizedBox(width: 30.0),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BottomnavShop()));
              },
              child: Container(
                decoration: const BoxDecoration(
                    color: Color(0xFF15A362), shape: BoxShape.circle),
                padding: const EdgeInsets.all(8),
                child: const Icon(Icons.home_outlined, color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTextField("Tên sản phẩm", nameController, 'Nhập tên sản phẩm'),
            const SizedBox(height: 20),
            const Text("Danh mục",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFececf8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              value: categoryValue,
              items: categories
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  categoryValue = value;
                });
              },
              hint: const Text('Chọn danh mục'),
            ),
            const SizedBox(height: 20),
            const Text("Thương hiệu",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFececf8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              value: brandValue,
              items: brands
                  .map((brand) => DropdownMenuItem(
                        value: brand,
                        child: Text(brand),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  brandValue = value;
                });
              },
              hint: const Text('Chọn thương hiệu'),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Giới tính",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFececf8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        value: genderValue,
                        items: genders
                            .map((gender) => DropdownMenuItem(
                                  value: gender,
                                  child: Text(gender),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            genderValue = value;
                          });
                        },
                        hint: const Text('Chọn giới tính'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Tiền hoa hồng",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      TextField(
                        controller: affialteController,
                        decoration: InputDecoration(
                          hintText: affialteController.text,
                          filled: true,
                          fillColor: const Color(0xFFececf8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            buildTextField(
                "Mô tả sản phẩm", descriptionController, 'Nhập mô tả sản phẩm',
                maxLines: 5),
            const SizedBox(height: 20),
            buildTextField("Giá sản phẩm", priceController, 'Nhập giá tiền',
                keyboardType: TextInputType.number),
            const SizedBox(height: 20),
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: _image == null && imageUrl != null
                    ? Image.network(imageUrl!,
                        width: 150, height: 150, fit: BoxFit.cover)
                    : _image != null
                        ? Image.file(_image!,
                            width: 150, height: 150, fit: BoxFit.cover)
                        : buildImagePlaceholder(),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Container(
                  child: Row(
                    children: [
                      Text('Trạng thái:',
                          style: AppWiget.LightTextFeildStyle()),
                      Transform.scale(
                        scale:
                            0.8, // Điều chỉnh tỷ lệ để chiều cao gần với 18 (vì Switch mặc định khá lớn)
                        child: Switch(
                          value: productStatus,
                          onChanged: (value) {
                            setState(() {
                              productStatus = value;
                            });
                          },
                          activeColor: const Color.fromARGB(
                              255, 113, 155, 65), // Màu khi bật
                          inactiveTrackColor: Colors
                              .lightGreen.shade100, // Màu khi tắt (xanh nhạt)
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 70.0,
                ),
                Container(
                  child: ElevatedButton(
                    onPressed: () async {
                      String? uploadedImageUrl;
                      if (_image != null) {
                        uploadedImageUrl =
                            await productService.uploadImage(_image!);
                      }

                      await productService.updateProduct(
                        widget.productId,
                        nameController.text,
                        descriptionController.text,
                        brandValue!,
                        categoryValue!,
                        genderValue!,
                        double.parse(affialteController.text),
                        double.parse(priceController.text),
                        uploadedImageUrl ?? imageUrl,
                        'ly',
                        productStatus ? 'active' : 'inactive',
                      );

                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text(
                      'Thêm',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Roboto',
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildImagePlaceholder() {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(color: Colors.green, width: 2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Icon(Icons.camera_alt, color: Colors.green, size: 40),
    );
  }

  Widget buildTextField(
      String label, TextEditingController controller, String hintText,
      {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: const Color(0xFFececf8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
