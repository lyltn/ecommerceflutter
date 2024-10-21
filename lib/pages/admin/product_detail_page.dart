import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'images_gallery.dart'; // Import the ImagesGallery class

class ProductDetailPage extends StatelessWidget {
  final DocumentSnapshot product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = product.data() as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(title: const Text('Product Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (data['imageUrl'] != null && data['imageUrl'].isNotEmpty)
                ImagesGallery(imageUrls: List<String>.from(data['imageUrl'])),
              const SizedBox(height: 16.0),
              Text('Name: ${data['name']}'),
              Text('Description: ${data['description']}'),
              Text('Brand: ${data['brandid']}'),
              Text('Category: ${data['categoryid']}'),
              Text('Sex: ${data['sex']}'),
              Text('Affiliate: ${data['affiliate']}%'),
              Text('Price: \$${data['price']}'),
              Text('User ID: ${data['userid']}'),
              Text('Status: ${data['status']}'),
            ],
          ),
        ),
      ),
    );
  }
}
