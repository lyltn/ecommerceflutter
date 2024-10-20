import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommercettl/pages/client/shopaddproduct.dart';
import 'package:ecommercettl/pages/client/shopbottomnav.dart';
import 'package:ecommercettl/pages/client/shoplistclassify.dart';
import 'package:ecommercettl/services/classify_service.dart';
import 'package:flutter/material.dart';

class ShopAddSize extends StatefulWidget {
  final String proId;

  const ShopAddSize({Key? key, required this.proId}) : super(key: key);

  @override
  State<ShopAddSize> createState() => _ShopAddSizeState();
}

class _ShopAddSizeState extends State<ShopAddSize> {
  final ClassifyService classifyService = ClassifyService();
  final TextEditingController sizeController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  String? productValue;

  @override
  void initState() {
    super.initState();
    // Set the passed productId if not null
    productValue = widget.proId.isNotEmpty ? widget.proId : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              const Text('Thêm phân loại SP',
                  style: TextStyle(color: Colors.black)),
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
            const Text("Sản phẩm",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('products')
                  .where('userid', isEqualTo: 'ly')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                return DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFececf8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  value: productValue,
                  items: snapshot.data!.docs.map((doc) {
                    var data = doc.data() as Map<String, dynamic>;
                    return DropdownMenuItem(
                      value: doc.id, // Assuming doc.id is the product ID
                      child: Text(data['name']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      productValue = value;
                    });
                  },
                  hint: const Text('Chọn sản phẩm'),
                );
              },
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
            Column(
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
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    if (productValue != null && productValue!.isNotEmpty) {
                      await classifyService.addClassify(
                        sizeController.text,
                        colorController.text,
                        int.parse(quantityController.text),
                        productValue!,
                      );
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ShopListClassify()));
                    }
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
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ShopListClassify()));
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
