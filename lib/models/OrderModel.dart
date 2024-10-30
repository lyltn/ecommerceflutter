import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommercettl/models/OrderDetail.dart';

class OrderModel {
  String orderCode;
  DateTime orderDate;
  String shopVoucher;
  String adminVoucher;
  double total; 
  String cusId;
  String name;
  String phone;
  String address; 
  String status;
  String note;
  OrderDetail? detail;
  String? productImg;
  String? productName;
  double? productPrice;
  int? productCount;

  OrderModel({
    required this.orderCode,
    required this.orderDate,
    required this.shopVoucher,
    required this.adminVoucher,
    required this.total,
    required this.cusId,
    required this.name,
    required this.phone,
    required this.address,
    required this.status,
    required this.note,
    this.detail,
    this.productName,
    this.productCount,
    this.productPrice
  });

  // Factory method to create an Order from a Firestore document
  factory OrderModel.fromFirestore(Map<String, dynamic> data) {
    return OrderModel(
      orderCode: data['orderCode'] ?? '',
      orderDate: (data['orderDate'] as Timestamp).toDate(), // Convert Firestore Timestamp to DateTime
      shopVoucher: data['shopVoucher'] ?? '',
      adminVoucher: data['adminVoucher'] ?? '',
      total: data['total']?.toDouble() ?? 0.0, // Ensure total is double
      cusId: data['cusId'] ?? '',
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      address: data['address'] ?? '',
      status: data['status'] ?? '',
      note: data['note'] ?? '',
    );
  }

  // Method to convert the Order object to a Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'orderCode': orderCode,
      'orderDate': Timestamp.fromDate(orderDate), // Convert DateTime to Firestore Timestamp
      'shopVoucher': shopVoucher,
      'adminVoucher': adminVoucher,
      'total': total,
      'cusId': cusId,
      'name': name,
      'phone': phone,
      'address': address,
      'status': status,
      'note': note
    };
  }
}
