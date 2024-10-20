import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser(String uid, String username, String phone, String address, String email, String dob) {
    return users.doc(uid).set({
      'username': username,
      'phone': phone,
      'address': address,
      'email': email,
      'dob': dob,
    });
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
}