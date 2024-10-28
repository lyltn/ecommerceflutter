import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommercettl/models/VoucherModel.dart';

class VoucherService {
  final CollectionReference vouchers =
      FirebaseFirestore.instance.collection('vouchers');

  Future<void> addVoucher(Voucher voucher) {
    return vouchers.add(voucher.toMap());
  }

  Stream<QuerySnapshot> getVouchersStream() {
    return vouchers.orderBy('startDate', descending: true).snapshots();
  }

  Future<void> updateVoucher(String docId, Voucher voucher) {
    return vouchers.doc(docId).update(voucher.toMap());
  }

  Future<void> deleteVoucher(String voucherID) {
    return vouchers.doc(voucherID).delete();
  }

  // Lấy danh sách voucher theo userID
  Stream<QuerySnapshot> getVouchersByUserID(String userID) {
    return vouchers.where('userID', isEqualTo: userID).snapshots();
  }
}
