import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommercettl/pages/client/shoporderdetail.dart';
import 'package:ecommercettl/services/order_service.dart';
import 'package:flutter/material.dart';

class ShopConfirmpage extends StatefulWidget {
  const ShopConfirmpage({super.key});

  @override
  State<ShopConfirmpage> createState() => _ShopConfirmpageState();
}

class _ShopConfirmpageState extends State<ShopConfirmpage> {
  final OrderService orderService = OrderService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shop Confirm Page"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('usercode', isEqualTo: 'ly')
            .where('status', isEqualTo: 'Đang đợi xét duyệt')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            padding: const EdgeInsets.all(10.0),
            children: snapshot.data!.docs.map((doc) {
              var data = doc.data() as Map<String, dynamic>;

              return Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: (data.containsKey('imageUrl') &&
                              data['imageUrl'] != null)
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                data['imageUrl']
                                    [0], // Use actual image URL from Firestore
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                'images/dress.png', // Fallback image if URL is not available
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                      title: Text(
                        data['productName'] ?? 'No Name',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Row(
                        children: [
                          Text(
                            data['color'] ?? 'No ',
                          ),
                          SizedBox(width: 5.0),
                          Text(
                            data['size'] ?? 'No ',
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            data['productPrice'] ?? '000000',
                            style: TextStyle(color: Colors.green),
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            data['productCount'] ?? '0',
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      color: Colors.grey,
                      thickness: 1,
                      indent: 10,
                      endIndent: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            data['quantity'] ?? '0',
                          ),
                          Row(
                            children: [
                              Text('Tổng tiền: '),
                              Text(
                                data['total'] ?? '000',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    OverflowBar(
                      alignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ShopOrderDetail(),
                              ),
                            );
                          },
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.all(8.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                            label: const Text(
                              'xem chi tiết đơn hàng',
                              style: TextStyle(
                                color: Color.fromARGB(255, 46, 46, 46),
                                fontSize: 12.0,
                              ),
                            ),
                            icon: const Icon(
                              Icons.remove_red_eye,
                              color: Color.fromARGB(255, 55, 54, 54),
                              size: 15.0,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            orderService.updateOrderStatus(doc.id);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 10.0,
                            ),
                          ),
                          child: const Text(
                            'duyệt',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
