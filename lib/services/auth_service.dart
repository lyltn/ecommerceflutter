import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> registerUser({
    required String username,
    required String email,
    required String password,
    required String phone,
    required String address,
    required String dob,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Lưu thông tin người dùng vào Firestore với vai trò customer
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'username': username,
        'phone': phone,
        'address': address,
        'email': email,
        'dob': dob,
        'role': 'customer', // Đặt vai trò mặc định là customer
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('Mật khẩu quá yếu.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('Email đã được sử dụng.');
      } else {
        throw Exception('Đăng ký thất bại. Vui lòng thử lại.');
      }
    } catch (e) {
      print(e);
      throw Exception('Đăng ký thất bại. Vui lòng thử lại.');
    }
  }

  Future<void> updateUserProfile({
    required String username,
    required String fullName,
    required String email,
    required String phone,
    required String address,
    required String dob,
    File? avatarImage,
  }) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String? avatarUrl;
        if (avatarImage != null) {
          avatarUrl = await uploadAvatarImage(avatarImage);
        }

        await _firestore.collection('users').doc(user.uid).update({
          'username': username,
          'fullName': fullName,
          'email': email,
          'phone': phone,
          'address': address,
          'dob': dob,
          if (avatarUrl != null) 'avatarUrl': avatarUrl,
        });
      } else {
        throw Exception('Người dùng chưa đăng nhập.');
      }
    } catch (e) {
      print(e);
      throw Exception('Cập nhật thông tin thất bại. Vui lòng thử lại.');
    }
  }

  Future<String> uploadAvatarImage(File image) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('avatars/${DateTime.now().toString()}');
      await storageRef.putFile(image);
      return await storageRef.getDownloadURL();
    } catch (e) {
      print('Failed to upload image: $e');
      return '';
    }
  }

  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          return userDoc.data() as Map<String, dynamic>?;
        }
      }
      return null;
    } catch (e) {
      print(e);
      throw Exception('Lấy thông tin người dùng thất bại. Vui lòng thử lại.');
    }
  }
}