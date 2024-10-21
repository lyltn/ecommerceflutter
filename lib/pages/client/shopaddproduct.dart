import 'dart:ffi';
import 'dart:io';
import 'package:ecommercettl/pages/client/shopbottomnav.dart';
import 'package:ecommercettl/services/brand_service.dart';
import 'package:ecommercettl/services/category_service.dart';
import 'package:ecommercettl/services/product_service.dart';
import 'package:ecommercettl/widget/widget_support.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:io';

class ShopAddProduct extends StatefulWidget {
  const ShopAddProduct({super.key});

  @override
  State<ShopAddProduct> createState() => _ShopAddProductState();
}

class _ShopAddProductState extends State<ShopAddProduct> {
  final ProductService productService = ProductService();
  final BrandService brandService = BrandService();
  final CategoryService categoryService = CategoryService();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController commissionController = TextEditingController();
  bool productStatus = true;
  String? categoryValue;
  String? genderValue;
  String? brandValue;

  final List<String> genders = ['Nam', 'Nữ', 'Unisex'];

  List<File> _images = [];
  final ImagePicker _picker = ImagePicker();
  List<String> imageUrls = [];

  Future<void> pickImages() async {
    final List<XFile>? selectedImages = await _picker.pickMultiImage();
    if (selectedImages != null) {
      setState(() {
        _images = selectedImages.map((image) => File(image.path)).toList();
      });
    }
  }

  List<String> categories = [];
  List<String> brands = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    categories = await categoryService.getnameCategories();
    brands = await brandService.getnameBrands();

    // Trigger a rebuild to update the UI with the fetched data.
    setState(() {});
  }

  Widget _buildGridView(List<File> imageFiles) {
    if (imageFiles.isNotEmpty) {
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Hiển thị 3 ảnh mỗi hàng
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
        ),
        itemCount: imageFiles.length,
        itemBuilder: (context, index) {
          return Image.file(
            imageFiles[index],
            fit: BoxFit.cover,
          );
        },
      );
    } else {
      return Center(child: Text('No images available'));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Thêm sản phẩm', style: TextStyle(color: Colors.black)),
            const SizedBox(width: 50.0),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BottomnavShop()));
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF15A362), // Background color
                  shape: BoxShape.circle, // Makes the background circular
                ),
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
            const Text("Tên sản phẩm",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Nhập tên sản phẩm',
                filled: true,
                fillColor: const Color(0xFFececf8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
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
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
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
                        controller: commissionController,
                        decoration: InputDecoration(
                          hintText: 'Nhập % hoa hồng',
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
            const Text("Mô tả sản phẩm",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Nhập mô tả sản phẩm',
                filled: true,
                fillColor: const Color(0xFFececf8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text("Giá sản phẩm",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              controller: priceController,
              decoration: InputDecoration(
                hintText: 'Nhập giá tiền',
                filled: true,
                fillColor: const Color(0xFFececf8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            Center(
              child: GestureDetector(
                onTap: pickImages,
                child: _images.isEmpty
                    ? Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.green, width: 2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(Icons.camera_alt,
                            color: Colors.green, size: 40),
                      )
                    : SizedBox(
                      height: 150, // Chiều cao để giới hạn GridView
                      child: _buildGridView(_images),
          ),
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
                      if (_images != null) {
                        imageUrls = await productService.uploadImages(_images);
                      }

                      await productService.addProduct(
                        nameController.text,
                        descriptionController.text,
                        brandValue!,
                        categoryValue!,
                        genderValue!,
                        double.parse(commissionController.text),
                        double.parse(priceController.text),
                        imageUrls,
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
}
