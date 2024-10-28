import 'package:cloud_firestore/cloud_firestore.dart';

class Voucher {
  final String idVoucher;
  final double condition;
  final int discount;
  final DateTime endDate;
  final double maxDiscount;
  final String role;
  final DateTime startDate;
  final String status; 
  final String userId;
  final String voucherCode;

  Voucher({
    required this.idVoucher,
    required this.condition,
    required this.discount,
    required this.endDate,
    required this.maxDiscount,
    required this.role,
    required this.startDate,
    required this.status,
    required this.userId,
    required this.voucherCode,
  });

  factory Voucher.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Voucher(
      idVoucher: documentId,
      condition: data['condition']?.toDouble() ?? 0.0, // Ensure it's a double
      discount: data['discount']?.toInt() ?? 0,       // Ensure it's an int
      endDate: (data['endDate'] as Timestamp).toDate(), // Convert Firestore Timestamp to DateTime
      maxDiscount: data['maxDiscount']?.toDouble() ?? 0.0,
      role: data['role'] ?? '',
      startDate: (data['startDate'] as Timestamp).toDate(), // Convert Firestore Timestamp to DateTime
      status: data['status'] ?? '',
      userId: data['userId'] ?? '',
      voucherCode: data['voucherCode'] ?? '',
    );
  }

  // Method to convert the Voucher object back to a map for saving to Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'condition': condition,
      'discount': discount,
      'endDate': Timestamp.fromDate(endDate), // Convert DateTime to Firestore Timestamp
      'maxDiscount': maxDiscount,
      'role': role,
      'startDate': Timestamp.fromDate(startDate), // Convert DateTime to Firestore Timestamp
      'status': status,
      'userId': userId,
      'voucherCode': voucherCode,
    };
  }
}
