import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommercettl/models/UserModel.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthService {

  final CollectionReference collectionUser = FirebaseFirestore.instance
      .collection('users');

  Future<UserModel?> getUserProfile(String userId) async {
    try {
      DocumentSnapshot documentSnapshot = await collectionUser.doc(userId)
          .get();
      if (documentSnapshot.exists) {
        return UserModel.fromFirestore(documentSnapshot);
      }
    } catch (e) {
      print('Error fetching user profile: $e');
    }
    return null;
  }

  Future<bool> updateUserProfile(UserModel userModel) async {
    try {
      UserModel? user = await getUserProfile(userModel.id);
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userModel.id)
            .update(userModel.toMap());
        print('Thông tin người dùng đã được cập nhật thành công.');
        return true;
      } else {
        print('Người dùng không tồn tại.');
        return false;
      }
    } catch (e) {
      print('Cập nhật thông tin người dùng thất bại: $e');
      return false;
    }
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
}


//   Future<String> uploadAvatarImage(File image) async {
//     try {
//       final storageRef = FirebaseStorage.instance
//           .ref()
//           .child('avatars/${DateTime.now().toString()}');
//       await storageRef.putFile(image);
//       return await storageRef.getDownloadURL();
//     } catch (e) {
//       print('Failed to upload image: $e');
//       return '';
//     }
//   }
