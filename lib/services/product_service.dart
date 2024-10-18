import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProductService {

  // Fetch all products --added by zungcao
  final CollectionReference products =
      FirebaseFirestore.instance.collection('products');

  // Create a new product --added by zungcao
  Future<void> addProduct(String userId, String name, String description,
      String imageUrl, int price) {
    return products.add({
      'userId': userId,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'timestamp': Timestamp.now(),
    });
  }

  // Read --added by zungcao
  Stream<QuerySnapshot> getProductsStream() {
    final productsStream =
        products.orderBy('timestamp', descending: true).snapshots();
    return productsStream;
  }

  // Update --added by zungcao
  Future<void> updateProduct(String docId, String newName,
      String newDescription, String newImageUrl, int newPrice) {
    return products.doc(docId).update({
      'name': newName,
      'description': newDescription,
      'imageUrl': newImageUrl,
      'price': newPrice,
    });
  }

  // Delete --added by zungcao
  Future<void> deleteProduct(String docId) {
    return products.doc(docId).delete();
  }

  Future<String> uploadImage(File image) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('product_images/${DateTime.now().toString()}');
      await storageRef.putFile(image);
      return await storageRef.getDownloadURL();
    } catch (e) {
      return '';
    }
  }
}