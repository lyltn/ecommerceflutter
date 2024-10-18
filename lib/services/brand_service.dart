import 'package:cloud_firestore/cloud_firestore.dart';

// shop phải đỗ dữ liệu ra theo userid
class BrandService {
  final CollectionReference brands =
      FirebaseFirestore.instance.collection('brands');

  Future<void> addBrand(
      String name, String nation, String userid, String status) {
    return brands.add({
      'name': name,
      'nation': nation,
      'userid': userid,
      'status': status,
    });
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getBrandById(String BrandId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('brands').doc(BrandId).get();

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

  Stream<QuerySnapshot> getbrandsStream() {
    final brandsStream =
        brands.orderBy('timestamp', descending: true).snapshots();
    return brandsStream;
  }

  Future<List<String>> getnameBrands() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('brands')
          .where('userid', isEqualTo: 'ly')
          .get();
      return snapshot.docs.map((doc) => doc['name'] as String).toList();
    } catch (e) {
      // Handle errors silently
      return [];
    }
  }

  Future<void> updateBrand(
      String docId, String name, String nation, String userid, String status) {
    return brands.doc(docId).update({
      'name': name,
      'nation': nation,
      'userid': userid,
      'status': status,
    });
  }

  // Delete --added by zungcao
  Future<void> deleteBrand(String docId) {
    return brands.doc(docId).delete();
  }
}
