import 'package:ecommercettl/models/OrderModel.dart';
import 'package:ecommercettl/pages/client/shoporderdetail.dart';
import 'package:ecommercettl/services/customer_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopConfirmpage extends StatefulWidget {
  const ShopConfirmpage({super.key});

  @override
  State<ShopConfirmpage> createState() => _ShopConfirmpageState();
}

class _ShopConfirmpageState extends State<ShopConfirmpage> {
  late SharedPreferences prefs;
  String? cusId;
  String query = "Đang đợi xét duyệt";
  List<OrderModel> listOrder = List.empty();
  CustomerService customerService = CustomerService();

  @override
  void initState() {
    super.initState();
    _loadPreferences(); 
  }

  Future<void> _loadPreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      cusId = prefs.getString('cusId'); 
    });

    if (cusId != null) {
      await _loadOrder(); 
    } else {
      print('cusId is null'); 
    }
  }

  Future<void> _loadOrder() async {
    try {
      print('cusid: ${cusId}');
      if (cusId != null) {
        List<OrderModel> orders = await customerService.fetchOrder(cusId!, query);
        print('query: ${query}');
        print('helo: ${orders}');
        setState(() {
          listOrder = orders; 
        });
      } else {
        print('Cannot fetch orders: cusId is null');
      }
    } catch (e) {
      print('Error loading orders: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(10.0),
        children: [
          buildOrder(
            imagePath: 'images/dress.png', // Replace with actual image path
            title: 'Đầm hoa nhí trẻ vai xinh phong cách.dsfsdfsdfsdfsdf..',
            subtitle: 'màu trắng, size s',
            price: '150,000 đ',
            quantity: 1,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ShopOrderDetail()),
              );
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
  Widget buildOrder({
    required String imagePath,
    required String title,
    required String subtitle,
    required String price,
    required int quantity,
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
              child: Image.asset(
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
                  price,
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
                const Text('3 sản phẩm'),
                Row(
                  children: [
                    const Text('Tổng tiền: '),
                    Text(
                      '320,000 VND',
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
