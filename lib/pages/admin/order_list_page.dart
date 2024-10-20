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

    void addOrder() {
      orderService.addOrder(
        'ORD12345', // orderCode
        1, // orderStatusId (e.g., 1 for 'pending', 2 for 'shipped', etc.)
        'VOUCHER50', // voucherCode
        99.99, // total (order total)
        'John Doe', // Fixed name issue
        '+1234567890', // phone
        '123 Main St, City', // address
        'pending', // status (pending, shipped, delivered, etc.)
        'John Doe', // useri
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Order List')),
      floatingActionButton: FloatingActionButton(
        onPressed: addOrder,
        child: const Icon(Icons.add),
      ),
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
