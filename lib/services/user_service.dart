import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserService {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  final storage = FlutterSecureStorage();

  Future<void> addUser(String uid, String username, String phone,
      String address, String email, String dob) {
    return users.doc(uid).set({
      'username': username,
      'phone': phone,
      'address': address,
      'email': email,
      'dob': dob,
    });
  }

  Future<String> uploadImage(File image) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('UserAvatar/${DateTime.now().toString()}');
      await storageRef.putFile(image);
      return await storageRef.getDownloadURL();
    } catch (e) {
      print('Failed to upload image: $e');
      return '';
    }
  }

  Future<Map<String, dynamic>?> getUserById(String uid) async {
    try {
      DocumentSnapshot doc = await users.doc(uid).get();

      if (doc.exists) {
        return doc.data() as Map<String, dynamic>?;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> saveUserId({required String userId}) async {
    await storage.write(key: 'userId', value: userId);
  }

  Future<String?> getUserRole() async {
    // Lấy userId từ FirebaseAuth
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return null; // Trả về null nếu user chưa đăng nhập
    }

    try {
      // Truy xuất tài liệu của người dùng từ Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      // Lấy role từ tài liệu của người dùng
      String? userRole = userDoc['role'];

      return userRole;
    } catch (e) {
      print("Error getting user role: $e");
      return null; // Trả về null nếu có lỗi xảy ra
    }
  }
}
