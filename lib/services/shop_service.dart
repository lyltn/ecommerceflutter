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
        });
      }
    } catch (e) {
      print(e);
      throw Exception('Đăng ký shop thất bại. Vui lòng thử lại.');
    }
  }

  Future<void> deleteUserAndProducts(String docId) async {
    try {
      // Xóa người dùng với id là docId
      await _firestore.collection('shopRequests').doc(docId).delete();

      // Lấy danh sách các sản phẩm có userId là docId
      QuerySnapshot productsSnapshot = await _firestore
          .collection('products')
          .where('userId', isEqualTo: docId)
          .get();

      // Dùng vòng lặp để xóa từng sản phẩm
      for (var doc in productsSnapshot.docs) {
        await doc.reference.delete();
      }

      print("User and related products deleted successfully.");
    } catch (e) {
      print("Error deleting user and products: $e");
    }
  }

  static Future<String?> getCurrentUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid; // If user is null, return null; otherwise return uid
  }
}
