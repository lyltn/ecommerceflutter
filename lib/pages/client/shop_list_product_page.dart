import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommercettl/services/product_service.dart';
import 'package:flutter/material.dart';

class ShopListProductPage extends StatefulWidget {
  const ShopListProductPage({super.key});

  @override
  State<ShopListProductPage> createState() => _ShopListProductPageState();
}

class _ShopListProductPageState extends State<ShopListProductPage> {
  @override
  Widget build(BuildContext context) {
    final ProductService productService = ProductService();

    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController imageUrlController = TextEditingController();
    final TextEditingController priceController = TextEditingController();

    void openProductBox({Map<String, dynamic>? productData}) {
      if (productData != null) {
        // Pre-fill the controllers with the product data for editing
        nameController.text = productData['name'];
        descriptionController.text = productData['description'];
        imageUrlController.text = productData['imageUrl'];
        priceController.text = productData['price'].toString();
      } else {
        // Clear controllers for adding new product
        nameController.clear();
        descriptionController.clear();
        imageUrlController.clear();
        priceController.clear();
      }

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: imageUrlController,
                decoration: const InputDecoration(labelText: 'Image URL'),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (productData == null) {
                  // Add new product
                  productService.addProduct(
                    "1",
                    nameController.text,
                    descriptionController.text,
                    imageUrlController.text,
                    int.parse(priceController.text),
                  );
                } else {
                  // Update existing product
                  productService.updateProduct(
                    productData['id'],
                    nameController.text,
                    descriptionController.text,
                    imageUrlController.text,
                    int.parse(priceController.text),
                  );
                }

                // Clear input fields
                nameController.clear();
                descriptionController.clear();
                imageUrlController.clear();
                priceController.clear();

                Navigator.pop(context);
              },
              child: Text(productData == null ? 'Add' : 'Update'),
            ),
          ],
        ),
      );
    }


    return Scaffold(
      appBar: AppBar(title: const Text('danh sach san pham')),
      floatingActionButton: FloatingActionButton(
        onPressed: openProductBox,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: productService.getProductsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List productsList = snapshot.data!.docs;

            return ListView.builder(
              itemCount: productsList.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot document = productsList[index];
                  String docId = document.id;
                  Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                  data['id'] = docId; // Include docId in the product data

                  return ListTile(
                    title: Text(data['name']),
                    trailing: IconButton(
                      onPressed: () => openProductBox(productData: data),
                      icon: const Icon(Icons.edit),
                    ),
                  );
                }
            );
          } else {
            return const Text('error');
          }
        },
      ),
    );
  }
}
