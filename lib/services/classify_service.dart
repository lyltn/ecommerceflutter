import 'package:cloud_firestore/cloud_firestore.dart';

// shop phải đỗ dữ liệu ra theo userid
class ClassifyService {
  final CollectionReference Classifys =
      FirebaseFirestore.instance.collection('classifys');

  Future<void> addClassify(
      String size, String color, int quantity, String productid) {
    return Classifys.add({
      'size': size,
      'color': color,
      'quantity': quantity,
      'productid': productid,
    });
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getClassifyById(String ClassifyId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('classifys').doc(ClassifyId).get();

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

  Stream<QuerySnapshot> getClassifysStream() {
    final ClassifysStream =
        Classifys.orderBy('timestamp', descending: true).snapshots();
    return ClassifysStream;
  }

  Future<List<String>> getnameClassifys() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('Classifys')
          .where('userid', isEqualTo: 'ly')
          .get();
      return snapshot.docs.map((doc) => doc['name'] as String).toList();
    } catch (e) {
      // Handle errors silently
      return [];
    }
  }

  Future<void> updateClassify(
      String docId, String size, String color, int quantity, String productid) {
    return Classifys.doc(docId).update({
      'size': size,
      'color': color,
      'quantity': quantity,
      'productid': productid,
    });
  }

  // Delete --added by zungcao
  Future<void> deleteClassify(String docId) {
    return Classifys.doc(docId).delete();
  }

  Future<void> deleteClassifiesByProductId(String productId) async {
    // Get the query snapshot for classifys with matching productId
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('classifys')
        .where('productid', isEqualTo: productId)
        .get();

    // Loop through each document and delete it
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      await FirebaseFirestore.instance
          .collection('classifys')
          .doc(doc.id)
          .delete();
    }
  }
}
