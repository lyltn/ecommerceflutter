import 'package:cloud_firestore/cloud_firestore.dart';

class ShopModel {
  final String email;
  final DateTime reviewedAt;
  final String reviewedBy;
  final String shopDescription;
  final String shopName;
  final String status;
  final String shopid;

  ShopModel({
    required this.email,
    required this.reviewedAt,
    required this.reviewedBy,
    required this.shopDescription,
    required this.shopName,
    required this.status,
    required this.shopid,
  });

  // Factory method to create a ShopModel instance from a Firestore document
  factory ShopModel.fromFirestore(Map<String, dynamic> data) {
    return ShopModel(
      email: data['email'] ?? '',
      reviewedAt: (data['reviewedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      reviewedBy: data['reviewedBy'] ?? '',
      shopDescription: data['shopDescription'] ?? '',
      shopName: data['shopName'] ?? '',
      status: data['status'] ?? '',
      shopid: data['uid'] ?? '',
    );
  }

  // Method to convert a ShopModel instance to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'reviewedAt': Timestamp.fromDate(reviewedAt),
      'reviewedBy': reviewedBy,
      'shopDescription': shopDescription,
      'shopName': shopName,
      'status': status,
      'uid': shopid,
    };
  }
}
