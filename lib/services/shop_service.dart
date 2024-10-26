import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ShopService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registerShop({
    required String shopName,
    required String shopDescription,
    required String email,
  }) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String uid = user.uid;

        await _firestore.collection('shopRequests').add({
          'uid': uid,
          'email': email,
          'shopName': shopName,
          'shopDescription': shopDescription,
          'status': 'pending',
          'submittedAt': DateFormat('yyyy-MM-dd').format(DateTime.now()),
          'reviewedBy': null,
          'reviewedAt': null,
        });
      }
    } catch (e) {
      print(e);
      throw Exception('Đăng ký shop thất bại. Vui lòng thử lại.');
    }
  }

  static Future<String?> getCurrentUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid; // If user is null, return null; otherwise return uid
  }
}
