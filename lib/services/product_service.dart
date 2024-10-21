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
    List<String> imageUrls,
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
      'imageUrl': imageUrls,
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
        products.orderBy('name', descending: true).snapshots();
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
    List<String> imageUrls,
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
      'imageUrl': imageUrls,
      'userid': userid,
      'status': status,
    });
  }

  // Delete --added by zungcao
  Future<void> deleteProduct(String docId) {
    return products.doc(docId).delete();
  }


  Future<List<String>> updateProductImages(String productId, List<File> newImages) async {
    List<String> uploadedUrls = [];
    
    try {
      // Step 1: Fetch the old image URLs from Firestore
      DocumentSnapshot productSnapshot = await FirebaseFirestore.instance.collection('products').doc(productId).get();
      if (productSnapshot.exists && productSnapshot['imageUrl'] != null) {
        List<String> oldImageUrls = List<String>.from(productSnapshot['imageUrl']);
        
        // Step 2: Delete the old images from Firebase Storage
        for (String imageUrl in oldImageUrls) {
          try {
            Reference storageRef = FirebaseStorage.instance.refFromURL(imageUrl);
            await storageRef.delete();
            print('Deleted old image: $imageUrl');
          } catch (e) {
            print('Error deleting old image: $e');
          }
        }
      }
      
      // Step 3: Upload the new images
      for (var image in newImages) {
        try {
          Reference storageRef = FirebaseStorage.instance
              .ref()
              .child('product_images/${DateTime.now().millisecondsSinceEpoch}_${image.path.split('/').last}');

          UploadTask uploadTask = storageRef.putFile(image);

          TaskSnapshot snapshot = await uploadTask;
          String downloadUrl = await snapshot.ref.getDownloadURL();
          uploadedUrls.add(downloadUrl);
          print('Uploaded new image: $downloadUrl');
        } catch (e) {
          print('Error uploading image: $e');
        }
      }
      
      // Return the list of new image URLs
      return uploadedUrls;
    } catch (e) {
      print('Error updating product images: $e');
      return [];
    }
  }


  Future<List<String>> uploadImages( List<File> _images) async {
    List<String> uploadedUrls = [];
    for (var image in _images) {
      try {
        Reference storageRef = FirebaseStorage.instance
            .ref()
            .child('product_images/${DateTime.now().millisecondsSinceEpoch}_${image.path.split('/').last}');

        UploadTask uploadTask = storageRef.putFile(image);

        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();
        uploadedUrls.add(downloadUrl);
        print('addne');
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
    return uploadedUrls;
  }
}
