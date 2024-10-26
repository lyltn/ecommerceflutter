import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Shop must load data based on userid
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

  Future<Map<String, dynamic>?> getBrandById(String brandId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('brands').doc(brandId).get();

      if (doc.exists) {
        // Return brand data as a Map
        return doc.data() as Map<String, dynamic>;
      } else {
        print('Brand does not exist.');
        return null;
      }
    } catch (e) {
      print('Error retrieving brand data: $e');
      return null;
    }
  }

  Stream<QuerySnapshot> getBrandsStream() {
    final brandsStream =
        brands.orderBy('timestamp', descending: true).snapshots();
    return brandsStream;
  }

  Future<List<String>> getNameBrands() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String uid = user.uid;

        QuerySnapshot snapshot = await _firestore
            .collection('brands')
            .where('userid', isEqualTo: uid)
            .get();

        return snapshot.docs.map((doc) => doc['name'] as String).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Error retrieving brand names: $e');
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
