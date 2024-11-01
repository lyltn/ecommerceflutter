import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommercettl/pages/client/shoporderdetail.dart';
import 'package:ecommercettl/services/order_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Shopwaitdelivery extends StatefulWidget {
  const Shopwaitdelivery({super.key});

  @override
  State<Shopwaitdelivery> createState() => _ShopwaitdeliveryState();
}

class _ShopwaitdeliveryState extends State<Shopwaitdelivery> {
  final OrderService orderService = OrderService();
  String? uid;

  @override
  void initState() {
    super.initState();

    // Anonymous async function inside initState
    () async {
      uid = (await FirebaseAuth.instance.currentUser) as String?;
      print('User ID: $uid');
      setState(() {}); // Update UI if necessary
    }();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('shopId', isEqualTo: uid)
            .where('status', isEqualTo: 'Chờ lấy hàng trả')
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
                      leading: (data.containsKey('productImg') &&
                              data['productImg'] != null)
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                data[
                                    'productImg'], // Load image from Firebase URL
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
                            (data['productPrice'] ?? 0).toString(),
                            style: TextStyle(color: Colors.green),
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            (data['productCount'] ?? 0).toString(),
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
                            (data['quantity'] ?? 0).toString(),
                          ),
                          Row(
                            children: [
                              Text('Tổng tiền: '),
                              Text(
                                (data['total'] ?? 0).toString(),
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
                                builder: (context) =>
                                    ShopOrderDetail(orderId: data['orderCode']),
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
                            label: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ShopOrderDetail(
                                        orderId: data['orderCode']),
                                  ),
                                );
                              },
                              child: Text(
                                'xem chi tiết đơn hàng',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 46, 46, 46),
                                  fontSize: 12.0,
                                ),
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
                            orderService.updateOrderStatus(doc.id, 'Bị huỷ');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5D6778),
                            padding: const EdgeInsets.only(
                                top: 8.0, bottom: 8.0, left: 10.0, right: 10.0),
                          ),
                          child: const Text(
                            'đã nhận hàng trả',
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
