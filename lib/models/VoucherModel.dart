import 'package:cloud_firestore/cloud_firestore.dart';

class Voucher {
<<<<<<< HEAD
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
=======
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
  factory Voucher.fromMap(Map<String, dynamic> data, int id) {
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
>>>>>>> 830797f7ec0825d79919b18c18673b4a28100826
    };
  }
}
