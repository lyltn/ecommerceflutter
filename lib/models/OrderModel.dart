import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommercettl/models/OrderDetail.dart';

class OrderModel {
  String orderCode;
  DateTime orderDate;
  String adminVoucher;
  String shopVoucher;
  double total; 
  String cusId;
  String name;
  String phone;
  String address; 
  String status;
  String note;
  String shopId;
  OrderDetail? detail;
  String? productImg;
  String? productName;
  double? productPrice;
  int? productCount;
  String? color;
  String? size;
  int? quantity;
  int reviews;
  double AdminPriceDiscount;

  OrderModel({
    required this.orderCode,
    required this.orderDate,
    required this.adminVoucher,
    required this.shopVoucher,
    required this.total,
    required this.cusId,
    required this.name,
    required this.phone,
    required this.address,
    required this.status,
    required this.note,
    required this.shopId,
    this.detail,
    this.productImg,
    this.productName,
    this.productCount,
    this.productPrice,
    this.color,
    this.size, 
    this.quantity,
    required this.reviews,
    required this.AdminPriceDiscount,
  });

  // Factory method to create an Order from a Firestore document
  factory OrderModel.fromFirestore(Map<String, dynamic> data) {
    return OrderModel(
      orderCode: data['orderCode'] ?? '',
      orderDate: (data['orderDate'] as Timestamp).toDate(), // Convert Firestore Timestamp to DateTime
      adminVoucher: data['adminVoucher'] ?? '',
      shopVoucher: data['shopVoucher'] ?? '',
      total: data['total']?.toDouble() ?? 0.0, // Ensure total is double
      cusId: data['cusId'] ?? '',
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      address: data['address'] ?? '',
      status: data['status'] ?? '',
      note: data['note'] ?? '',
      shopId: data['shopId' ?? ''],
      productImg: data['productImg'] ?? '',
      productCount: data['productCount'] ?? '',
      productName: data['productName'] ?? '',
      productPrice: data['productPrice'] ?? '',
      color: data['color'] ?? '',
      size: data['size'] ?? '',
      quantity: data['quantity'] ?? 0,
      reviews: data['reviews'] ?? 0,
      AdminPriceDiscount: data['adminPriceDiscount'] ?? 0
    );
  }

  // Method to convert the Order object to a Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'orderCode': orderCode,
      'orderDate': Timestamp.fromDate(orderDate), // Convert DateTime to Firestore Timestamp
      'adminVoucher': adminVoucher,
      'shopVoucher': shopVoucher,
      'total': total,
      'cusId': cusId,
      'name': name,
      'phone': phone,
      'address': address,
      'status': status,
      'note': note,
      'shopId': shopId,
      'productImg' : productImg,
      'productCount' : productCount,
      'productName' : productName,
      'productPrice' : productPrice,
      'color' : color,
      'size' : size,
      'quantity' : quantity,
      'reviews': reviews,
      'adminPriceDiscount': AdminPriceDiscount
    };
  }
}
