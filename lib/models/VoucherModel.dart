import 'package:cloud_firestore/cloud_firestore.dart';

class Voucher {
  final String voucherID;
  final int discount;
  final double condition;
  final DateTime startDate;
  final DateTime endDate;
  final double maxDiscount;
  final String userID;
  final bool status;
  final String role;

  Voucher({
    required this.voucherID,
    required this.discount,
    required this.condition,
    required this.startDate,
    required this.endDate,
    required this.maxDiscount,
    required this.userID,
    required this.status,
    required this.role,
  });

  // Phương thức để chuyển đổi từ Map sang đối tượng Voucher
  factory Voucher.fromMap(Map<String, dynamic> data, String id) {
    return Voucher(
      voucherID: data['voucherCode'],
      discount: data['discount'],
      condition: data['condition'],
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      maxDiscount: data['maxDiscount'],
      userID: data['userID'],
      status: data['status'],
      role: data['role'],
    );
  }

  // Phương thức để chuyển đổi từ đối tượng Voucher sang Map
  Map<String, dynamic> toMap() {
    return {
      'voucherCode': voucherID,
      'discount': discount,
      'condition': condition,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'maxDiscount': maxDiscount,
      'userID': userID,
      'status': status,
      'role': role,
    };
  }
}
