import 'package:cloud_firestore/cloud_firestore.dart';

class ShopModel {
  final String email;
  final String reviewedBy;
  final String shopDescription;
  final String shopName;
  final String status;
  final String shopid;

  ShopModel({
    required this.email,
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
      reviewedBy: data['reviewedBy'] ?? '',
      shopDescription: data['shopDescription'] ?? '',
      shopName: data['shopName'] ?? '',
      status: data['status'] ?? '',
      shopid: data['shopid'] ?? '',
    );
  }

  // Method to convert a ShopModel instance to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'reviewedBy': reviewedBy,
      'shopDescription': shopDescription,
      'shopName': shopName,
      'status': status,
      'shopid': shopid,
    };
  }
}
