import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

Future<void> addProduct(
    String name,
    String des,
    String brandid,
    String cateid,
    String sex,
    double affialte,
    String userid,
    String? imageUrl,
    bool status) async {
  CollectionReference products =
      FirebaseFirestore.instance.collection('products');

  await products.add({
    'name': name,
    'des': des,
    'brandid': brandid,
    'cateid': cateid,
    'sex': sex,
    'affialte': affialte,
    'usreid': userid,
    'imageUrl': imageUrl,
    'status': status,
  });
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

Future<void> updateProduct(
    String docId,
    String name,
    String des,
    String brandid,
    String cateid,
    String sex,
    double affialte,
    String userid,
    String? imageUrl,
    bool status) async {
  CollectionReference products =
      FirebaseFirestore.instance.collection('products');

  await products.doc(docId).update({
    'name': name,
    'des': des,
    'brandid': brandid,
    'cateid': cateid,
    'sex': sex,
    'affialte': affialte,
    'usreid': userid,
    'imageUrl': imageUrl,
    'status': status,
  });
}

Future<void> deleteProduct(String docId) async {
  CollectionReference products =
      FirebaseFirestore.instance.collection('products');

  await products.doc(docId).delete();
}
