import 'package:ecommercettl/pages/client/shoporderdetail.dart';
import 'package:flutter/material.dart';

class ShopConfirmpage extends StatefulWidget {
  const ShopConfirmpage({super.key});

  @override
  State<ShopConfirmpage> createState() => _ShopConfirmpageState();
}

class _ShopConfirmpageState extends State<ShopConfirmpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(10.0),
        children: [
          Card(
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
                      'images/dress.png', // Replace with actual image path
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: const Text(
                    'Đầm hoa nhí trẻ vai xinh phong cách.dsfsdfsdfsdfsdf..',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: const Row(
                    children: [
                      Text('màu trắng, size s'),
                      SizedBox(width: 8.0),
                      Text(
                        '150,000 đ',
                        style: TextStyle(color: Colors.green),
                      ),
                      SizedBox(width: 8.0),
                      Text('x1'),
                    ],
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 1,
                  indent: 10, // Padding from the left
                  endIndent: 10, // Padding from the right
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('3 sản phẩm'),
                      Row(
                        children: [
                          Text('Tổng tiền: '),
                          Text(
                            ' 320,000 VND',
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
                                builder: (context) => ShopOrderDetail()));
                      },
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.all(8.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                5.0), // Set border radius to 5
                          ),
                        ),
                        label: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ShopOrderDetail()));
                          },
                          child: const Text(
                            'xem chi tiết đơn hàng',
                            style: TextStyle(
                                color: Color.fromARGB(255, 46, 46, 46),
                                fontSize: 12.0),
                          ),
                        ),
                        icon: const Icon(
                          Icons.remove_red_eye,
                          color: Color.fromARGB(
                              255, 55, 54, 54), // Set icon color to black
                          size: 15.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
