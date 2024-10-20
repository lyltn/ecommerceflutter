import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommercettl/services/order_service.dart';
import 'package:flutter/material.dart';

import 'order_detail_page.dart';

class OrderListPage extends StatefulWidget {
  const OrderListPage({super.key});

  @override
  State<OrderListPage> createState() => _OrderListPage();
}

class _OrderListPage extends State<OrderListPage> {
  @override
  Widget build(BuildContext context) {
    final OrderService orderService = OrderService();

    return Scaffold(
      appBar: AppBar(title: const Text('Order List')),
      body: StreamBuilder<QuerySnapshot>(
        stream: orderService.getOrderStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (snapshot.hasData) {
            List orderList = snapshot.data!.docs;

            return ListView.builder(
              itemCount: orderList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = orderList[index];
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;

                return ListTile(
                  title: Text(data['address']),
                  trailing: IconButton(
                    onPressed: () => orderService.deleteOrder(document.id),
                    icon: const Icon(Icons.delete),
                  ),
                  onTap: () {
                    // Navigate to the OrderDetailPage with the selected order
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderDetailPage(order: document),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return const Text('No orders found');
          }
        },
      ),
    );
  }
}
