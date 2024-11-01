import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommercettl/models/Product.dart';
import 'package:ecommercettl/pages/customer/component/ProductSellCard.dart';
import 'package:ecommercettl/pages/customer/productDetail.dart';
import 'package:ecommercettl/pages/customer/shopdetail.dart';
import 'package:flutter/material.dart';

class TopShopProduct extends StatelessWidget {
  final String userId;
  final String shopName;

  const TopShopProduct({Key? key, required this.userId, required this.shopName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Top Sản Phẩm Nổi Bật',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ShopDetailPage(shopName: shopName)),
                  );
                },
                child: const Text(
                  'Xem Tất Cả >',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 260, // Adjust this height as needed
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('products')
                .where('userid', isEqualTo: userId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final products = snapshot.data!.docs.map((doc) {
                var data = doc.data() as Map<String, dynamic>;
                return Product.fromFirestore(data, doc.id);
              }).toList();

              if (products.isEmpty) {
                return const Center(child: Text('No products found.'));
              }

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return GestureDetector( // Wrap with GestureDetector
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Productdetail(newProduct: product),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ProductSellCard(
                        imagePath: product.imageUrls.isNotEmpty
                            ? product.imageUrls[0]
                            : 'images/dress.png',
                        name: product.name,
                        price: product.price,
                        discountPercentage: 20, // Adjust as needed
                        rating: 5.0, // Adjust as needed
                        reviewCount: 4, // Adjust as needed
                        width: 160, // Specify the width for a scaled-down version
                        height: 240, // Specify the height for a scaled-down version
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
