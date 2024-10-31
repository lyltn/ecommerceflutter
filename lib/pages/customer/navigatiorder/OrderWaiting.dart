import 'package:ecommercettl/models/OrderDetail.dart';
import 'package:ecommercettl/models/OrderModel.dart';
import 'package:ecommercettl/models/Product.dart';
import 'package:ecommercettl/pages/client/shoporderdetail.dart';
import 'package:ecommercettl/services/customer_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderWaiting extends StatefulWidget {
  final List<OrderModel> listOrder;
  const OrderWaiting({Key? key, required this.listOrder}) : super(key: key);

  @override
  State<OrderWaiting> createState() => _OrderWaitingState();
}

class _OrderWaitingState extends State<OrderWaiting> {
  @override
  void initState() {
    super.initState();
    print("ditocnem ${widget.listOrder}");
  }

  @override
  Widget build(BuildContext context) {
    print('Received listOrder in OrderWaiting: ${widget.listOrder}');
    return Scaffold(
      body: ListView.builder(
        itemCount: widget.listOrder.length,
        padding: const EdgeInsets.all(10.0),
        itemBuilder: (context, index) {
          final order = widget.listOrder[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: buildOrder(
              imagePath: order.productImg!,
              title: order.productName!,
              subtitle: 'Màu ${order.color}, size ${order.size}',
              price: NumberFormat("#,###", "vi_VN").format(order.productPrice!),
              quantity: order.quantity ?? 0,
              totalProduct: order.productCount,
              totalPrice: order.total,
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => ShopOrderDetail()),
                // );
              },
            ),
          );
        },
      ),
    );
  }

  Widget buildOrder({
    required String imagePath,
    required String title,
    required String subtitle,
    required String price,
    required int quantity,
    required totalProduct,
    required totalPrice,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                imagePath,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Row(
              children: [
                Text(subtitle),
                const SizedBox(width: 8.0),
                Text(
                  '${price}đ',
                  style: const TextStyle(color: Colors.green),
                ),
                const SizedBox(width: 8.0),
                Text('x$quantity'),
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
                Text('${totalProduct} sản phẩm'),
                Row(
                  children: [
                    const Text('Tổng tiền: '),
                    Text(
                      '${NumberFormat("#,###", "vi_VN").format(totalPrice)}',
                      style: const TextStyle(
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
                onTap: onTap,
                child: OutlinedButton.icon(
                  onPressed: () {}, // Can be empty if onTap is used
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
            ],
          ),
        ],
      ),
    );
  }
}
