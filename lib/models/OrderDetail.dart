import 'package:cloud_firestore/cloud_firestore.dart';

class OrderDetail {
  String orderCode;
  String productId;
  String size;
  String color; 
  int quantity;

  OrderDetail({
    required this.orderCode,
    required this.productId,
    required this.size,
    required this.color,
    required this.quantity,
  });

  // Method to create an OrderDetail from Firestore document data
  factory OrderDetail.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map; // Cast to a Map
    return OrderDetail(
      orderCode: data['orderCode'] ?? '',
      productId: data['productId'] ?? '',
      size: data['size'] ?? '',
      color: data['color'] ?? '',
      quantity: data['quantity'] ?? 0,
    );
  }

  // Method to convert an OrderDetail object to a Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'orderCode': orderCode,
      'productId': productId,
      'size': size,
      'color': color,
      'quantity': quantity,
    };
  }
}
