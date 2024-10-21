import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommercettl/pages/admin/Components/shop_item.dart';
import 'package:ecommercettl/services/product_service.dart';
import 'package:flutter/material.dart';
import 'product_detail_page.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final ProductService productService = ProductService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product List')),
      body: StreamBuilder<QuerySnapshot>(
        stream: productService.getProductsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            List<DocumentSnapshot> productList = snapshot.data!.docs;

            return ListView.builder(
              itemCount: productList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot product = productList[index];
                Map<String, dynamic> data = product.data() as Map<String, dynamic>;

                // Extract necessary fields from Firestore document
                String shopName = data['userid'] ?? 'Unknown Shop';
                String productName = data['name'] ?? 'Unnamed Product';
                double price = data['price']?.toDouble() ?? 0.0; // Ensure price is a double
                String imageUrl = data['imageUrl'] != null && data['imageUrl'].isNotEmpty
                    ? data['imageUrl'][0] // Get the first image
                    : ''; // Default or placeholder image

                return ShopItem(
                  shopName: shopName,
                  productName: productName,
                  price: price,
                  imageUrl: imageUrl,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailPage(product: product),
                      ),
                    );
                  },
                  onDelete: () => productService.deleteProduct(product.id), // Handle delete action
                );
              },
            );
          } else {
            return const Center(child: Text('No products found'));
          }
        },
      ),
    );
  }
}
