import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommercettl/pages/client/shopaddproduct.dart';
import 'package:ecommercettl/pages/client/shopaddsize.dart';
import 'package:ecommercettl/pages/client/shopbottomnav.dart';
import 'package:ecommercettl/pages/client/shopeditproduct.dart';
import 'package:ecommercettl/services/product_service.dart';
import 'package:ecommercettl/widget/widget_support.dart';
import 'package:flutter/material.dart';

class ShopListProduct extends StatefulWidget {
  const ShopListProduct({super.key});

  @override
  State<ShopListProduct> createState() => _ShopListProductState();
}

class _ShopListProductState extends State<ShopListProduct> {
  @override
  final ProductService productService = ProductService();
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách sản phẩm', style: AppWiget.boldTextFeildStyle()),
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
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: const Icon(Icons.search_outlined),
                      contentPadding: const EdgeInsets.symmetric(vertical: 5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
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

            // Product List
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('products')
                    .where('userid', isEqualTo: 'ly')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  return ListView(
                    children: snapshot.data!.docs.map((doc) {
                      var data = doc.data() as Map<String, dynamic>;

                      return Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ListTile(
                          leading: (data.containsKey('imageUrl') &&
                                  data['imageUrl'] != null)
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    data[
                                        'imageUrl'], // Use actual image URL from Firestore
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    'images/dress.png', // Fallback image if URL is not available
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                          title: Text(
                            data['name'] ?? 'No Name', // Dynamic product name
                            style: TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Row(
                            children: [
                              Text(
                                '${data['price'] ?? '0'} VND', // Dynamic price
                                style: TextStyle(color: Colors.green),
                              ),
                              SizedBox(width: 10.0),
                              Icon(Icons.star, color: Colors.yellow, size: 16),
                              Text('4.5'), // Dynamic rating
                            ],
                          ),
                          trailing: PopupMenuButton(
                            icon: Icon(Icons.more_vert),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                child: GestureDetector(
                                  onLongPress: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ShopEditProduct(productId: doc.id),
                                      ),
                                    );
                                  },
                                  child: Icon(Icons.edit_outlined,
                                      color: Colors.green),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ShopEditProduct(productId: doc.id),
                                    ),
                                  );
                                },
                              ),
                              PopupMenuItem(
                                child: GestureDetector(
                                  onLongPress: () {
                                    productService.deleteProduct(doc.id);
                                  },
                                  child: Icon(Icons.delete_outline,
                                      color: Colors.red),
                                ),
                                onTap: () {
                                  productService.deleteProduct(doc.id);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),

            const SizedBox(height: 20.0),

            // Add Product Button
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ShopAddProduct()));
              },
              child: SingleChildScrollView(
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
                                    builder: (context) => ShopAddProduct()));
                          },
                          child: const Text(
                            'Thêm sản phẩm +',
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
                                    builder: (context) => ShopAddSize()));
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
            ),
          ],
        ),
      ),
    );
  }
}
