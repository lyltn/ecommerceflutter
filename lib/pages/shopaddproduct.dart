import 'dart:io';
import 'package:ecommercettl/pages/shopbottomnav.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ShopAddProduct extends StatefulWidget {
  const ShopAddProduct({super.key});

  @override
  State<ShopAddProduct> createState() => _ShopAddProductState();
}

class _ShopAddProductState extends State<ShopAddProduct> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController commissionController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String? categoryValue;
  String? genderValue;
  final List<String> categories = ['Áo khoác jean', 'Áo sơ mi', 'Quần jeans'];
  final List<String> genders = ['Nam', 'Nữ', 'Unisex'];
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Thêm sản phẩm', style: TextStyle(color: Colors.black)),
            const SizedBox(width: 50.0),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BottomnavShop()));
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
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Tên sản phẩm", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Nhập tên sản phẩm',
                filled: true,
                fillColor: Color(0xFFececf8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text("Danh mục", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFFececf8),
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
              hint: Text('Chọn danh mục'),
            ),
            SizedBox(height: 20),
            Text("Thương hiệu", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFFececf8),
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
              hint: Text('Chọn thương hiệu'),
            ),
            SizedBox(height: 20),
            Text("Giới tính", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFFececf8),
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
              hint: Text('Chọn giới tính'),
            ),
            SizedBox(height: 20),
            Text("Tiền hoa hồng",
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            TextField(
              controller: commissionController,
              decoration: InputDecoration(
                hintText: 'Nhập % hoa hồng',
                filled: true,
                fillColor: Color(0xFFececf8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            Text("Mô tả sản phẩm",
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Nhập mô tả sản phẩm',
                filled: true,
                fillColor: Color(0xFFececf8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text("Thêm hình ảnh",
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            selectedImage == null
                ? Center(
                    child: GestureDetector(
                      onTap: getImage,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.camera_alt_outlined,
                            color: Colors.black),
                      ),
                    ),
                  )
                : Center(
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.file(selectedImage!, fit: BoxFit.cover),
                    ),
                  ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: Text(
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
      ),
    );
  }
}
