import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

// shop phải đỗ dữ liệu ra theo userid
class ProductService {
  final CollectionReference products =
      FirebaseFirestore.instance.collection('products');

  Future<void> addProduct(
    String name,
    String des,
    String brand,
    String cate,
    String sex,
    double affialte,
    double price,
    String? imageUrl,
    String userid,
    String status,
  ) {
    return products.add({
      'name': name,
      'description': des,
      'brandid': brand,
      'categoryid': cate,
      'sex': sex,
      'affiliate': affialte,
      'price': price,
      'imageUrl': imageUrl,
      'userid': userid,
      'status': status,
    });
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getProductById(String productId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('products').doc(productId).get();

      if (doc.exists) {
        // Trả về dữ liệu của sản phẩm dưới dạng Map
        return doc.data() as Map<String, dynamic>;
      } else {
        print('Sản phẩm không tồn tại.');
        return null;
      }
    } catch (e) {
      print('Lỗi khi lấy dữ liệu sản phẩm: $e');
      return null;
    }
  }

  Stream<QuerySnapshot> getProductsStream() {
    final productsStream =
        products.orderBy('timestamp', descending: true).snapshots();
    return productsStream;
  }

  Future<void> updateProduct(
    String docId,
    String name,
    String des,
    String brand,
    String cate,
    String sex,
    double affialte,
    double price,
    String? imageUrl,
    String userid,
    String status,
  ) {
    return products.doc(docId).update({
      'name': name,
      'description': des,
      'brandid': brand,
      'categoryid': cate,
      'sex': sex,
      'affiliate': affialte,
      'price': price,
      'imageUrl': imageUrl,
      'userid': userid,
      'status': status,
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
      print('Failed to upload image: $e');
      return '';
    }
  }
}
