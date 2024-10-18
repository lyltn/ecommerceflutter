import 'package:cloud_firestore/cloud_firestore.dart';

// shop phải đỗ dữ liệu ra theo userid
class CategoryService {
  final CollectionReference Categorys =
      FirebaseFirestore.instance.collection('categorys');

  Future<void> addCategory(String name, String userid, String status) {
    return Categorys.add({
      'name': name,
      'userid': userid,
      'status': status,
    });
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getCategoryById(String CategoryId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('categorys').doc(CategoryId).get();

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

  Future<List<String>> getnameCategories() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('categorys')
          .where('userid', isEqualTo: 'ly')
          .get();
      return snapshot.docs.map((doc) => doc['name'] as String).toList();
    } catch (e) {
      // Handle errors silently
      return [];
    }
  }

  Stream<QuerySnapshot> getCategorysStream() {
    final CategorysStream =
        Categorys.orderBy('timestamp', descending: true).snapshots();
    return CategorysStream;
  }

  Future<void> updateCategory(
      String docId, String name, String userid, String status) {
    return Categorys.doc(docId).update({
      'name': name,
      'userid': userid,
      'status': status,
    });
  }

  // Delete --added by zungcao
  Future<void> deleteCategory(String docId) {
    return Categorys.doc(docId).delete();
  }
}
