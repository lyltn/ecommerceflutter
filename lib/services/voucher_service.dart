import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

// shop phải đỗ dữ liệu ra theo userid
class VoucherService {
  final CollectionReference vouchers = FirebaseFirestore.instance.collection('vouchers');

  Future<void> addVoucher(
      String docId,
      int voucherID,
      int discount,
      double condition,
      DateTime startDate,
      DateTime endDate,
      double maxDiscount,
      String userID,
      bool status,
      ) {
    return vouchers.add({
      'voucherID': voucherID,
      'discount': discount,
      'condition': condition,
      'startDate': Timestamp.now(),
      'endDate': Timestamp.now(),
      'maxDiscount': maxDiscount,
      'userID': userID,
      'status': status,
    });
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getVouchersStream() {
    final vouchersStream =
    vouchers.orderBy('startDate', descending: true).snapshots();
    return vouchersStream;
  }

  Future<void> updateVoucher(
      String docId,
      int voucherID,
      int discount,
      double condition,
      DateTime startDate,
      DateTime endDate,
      double maxDiscount,
      String userID,
      bool status,
      ) {
    return vouchers.doc(docId).update({
      'voucherID': voucherID,
      'discount': discount,
      'condition': condition,
      'startDate': Timestamp.now(),
      'endDate': Timestamp.now(),
      'maxDiscount': maxDiscount,
      'userID': userID,
      'status': status,
    });
  }

  // Delete --added by zungcao
  Future<void> deleteVoucher(String voucherID) {
    return vouchers.doc(voucherID).delete();
  }

}
