import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderDetailPage extends StatelessWidget {
  final DocumentSnapshot order;

  const OrderDetailPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    // Extracting data from the passed order document
    Map<String, dynamic> data = order.data() as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(title: const Text('Order Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order Code: ${data['orderCode']}'),
            Text('Order Date: ${data['orderDate'].toDate()}'),
            Text('Status: ${data['status']}'),
            Text('Voucher Code: ${data['voucherCode']}'),
            Text('Name: ${data['userId']}'),
            Text('Phone: ${data['phone']}'),
            Text('Address: ${data['address']}'),
            Text('Total: \đ${data['total']}'),
          ],
        ),
      ),
    );
  }
}
