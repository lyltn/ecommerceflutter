import 'package:ecommercettl/pages/client/shopaddproduct.dart';
import 'package:ecommercettl/pages/client/shopbottomnav.dart';
import 'package:flutter/material.dart';

class ShopAddSize extends StatefulWidget {
  const ShopAddSize({super.key});

  @override
  State<ShopAddSize> createState() => _ShopAddSizeState();
}

class _ShopAddSizeState extends State<ShopAddSize> {
  final TextEditingController sizeController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  String? categoryValue;
  final List<String> productname = ['Áo khoác jean', 'Áo sơ mi', 'Quần jeans'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              const Text('Thêm phân loại SP', style: TextStyle(color: Colors.black)),
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
            const Text("Sản phẩm", style: TextStyle(fontWeight: FontWeight.bold)),
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
              items: productname
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
              hint: const Text('Chọn sản phẩm'),
            ),
            const SizedBox(height: 20),
            const Text("Kích cỡ (Phân loại)",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              controller: sizeController,
              decoration: InputDecoration(
                hintText: 'vd: XL',
                filled: true,
                fillColor: const Color(0xFFececf8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text("Màu (Phân loại)",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              controller: colorController,
              decoration: InputDecoration(
                hintText: 'vd: trắng',
                filled: true,
                fillColor: const Color(0xFFececf8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Số lượng",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      TextField(
                        controller: quantityController,
                        decoration: InputDecoration(
                          hintText: 'vd: 70',
                          filled: true,
                          fillColor: const Color(0xFFececf8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Giá",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      TextField(
                        controller: priceController,
                        decoration: InputDecoration(
                          hintText: 'vd: 100.000',
                          filled: true,
                          fillColor: const Color(0xFFececf8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {},
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
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ShopAddProduct()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(
                    color: Colors.green,
                    width: 2.0,
                  ),
                ),
              ),
              child: const Text(
                'Danh sách phân loại',
                style: TextStyle(
                  color: Colors.green,
                  fontFamily: 'Roboto',
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
