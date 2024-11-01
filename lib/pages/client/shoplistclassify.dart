import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommercettl/pages/client/shopaddsize.dart';
import 'package:ecommercettl/pages/client/shopbottomnav.dart';
import 'package:ecommercettl/pages/client/shoplistproduct.dart';
import 'package:ecommercettl/services/classify_service.dart';
import 'package:ecommercettl/services/shop_service.dart';
import 'package:ecommercettl/widget/widget_support.dart';
import 'package:flutter/material.dart';

class ShopListClassify extends StatefulWidget {
  const ShopListClassify({super.key});

  @override
  State<ShopListClassify> createState() => _ShopListClassifyState();
}

class _ShopListClassifyState extends State<ShopListClassify> {
  String productid = '';
  String id = '';
  final ClassifyService classifyService = ClassifyService();

  String? uid;

  @override
  void initState() {
    super.initState();

    // Anonymous async function inside initState
    () async {
      uid = await ShopService.getCurrentUserId();
      print('User ID: $uid');
      setState(() {}); // Update UI if necessary
    }();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Danh sách phân loại', style: AppWiget.boldTextFeildStyle()),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 1.0, left: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Row(
              children: [
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('products')
                        .where('userid', isEqualTo: uid!)
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
                        isExpanded: true, // Ensures dropdown takes full width
                        value: productid.isEmpty ? null : productid,
                        items: snapshot.data!.docs.map((doc) {
                          var data = doc.data() as Map<String, dynamic>;
                          return DropdownMenuItem(
                            value: doc.id,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context).size.width -
                                      80), // Adjust max width if needed
                              child: Text(
                                data['name'],
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            productid = value!;
                          });
                        },
                        hint: const Text('Chọn sản phẩm'),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 20.0),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BottomnavShop()));
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
            const SizedBox(height: 20.0),

            // List of Classifications
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('classifys')
                    .where('productid', isEqualTo: productid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.data!.docs.isEmpty) {
                    return const Center(
                        child: Text('No classifications found.'));
                  }

                  return ListView.separated(
                    itemCount: snapshot.data!.docs.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      var doc = snapshot.data!.docs[index];
                      var data = doc.data() as Map<String, dynamic>;

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(data['size'] ?? '',
                                style: const TextStyle(fontSize: 16)),
                          ),
                          Expanded(
                            child: Text(data['color'] ?? '',
                                style: const TextStyle(fontSize: 16)),
                          ),
                          Expanded(
                            child: Text(data['quantity'].toString(),
                                style: const TextStyle(fontSize: 16)),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              await classifyService.deleteClassify(doc.id);
                              setState(() {
                                // Refresh UI after deletion
                              });
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20.0),

            // Add Product Button

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Container(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(
                            color: Colors.green, // Đặt màu viền
                            width: 2.0, // Độ dày của viền
                          ),
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ShopListProduct()));
                        },
                        child: const Text(
                          'Danh sách sản phẩm',
                          style: TextStyle(
                            color: Colors.green,
                            fontFamily: 'Roboto',
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  Container(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(
                            color: Colors.green, // Đặt màu viền
                            width: 2.0, // Độ dày của viền
                          ),
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ShopAddSize(
                                        proId: '',
                                      )));
                        },
                        child: const Text(
                          'Thêm phân loại +',
                          style: TextStyle(
                            color: Colors.green,
                            fontFamily: 'Roboto',
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
