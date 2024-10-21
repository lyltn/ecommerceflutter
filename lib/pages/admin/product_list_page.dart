import 'package:cloud_firestore/cloud_firestore.dart';
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

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  leading: data['imageUrl'] != null && data['imageUrl'].isNotEmpty
                      ? Image.network(
                    data['imageUrl'][0], // Get the first image
                    height: 50, // Adjust height as needed
                    width: 50, // Adjust width as needed
                    fit: BoxFit.cover, // Ensure the image covers the given dimensions
                  )
                      : const SizedBox(width: 50, height: 50), // Placeholder if no image

                  title: Text(data['name']),
                  subtitle: Text('\$${data['price']}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailPage(product: product),
                      ),
                    );
                  },
                  trailing: IconButton(
                    onPressed: () => productService.deleteProduct(product.id),
                    icon: const Icon(Icons.delete),
                  ),
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
