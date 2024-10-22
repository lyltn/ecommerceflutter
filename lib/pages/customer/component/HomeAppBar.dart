import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Icon(Icons.menu, color: Colors.black),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center, // Căn giữa hàng
        children: [
          // Image.asset(
          //   'images/logo-cus.png', // Đường dẫn tới hình ảnh
          //   width: 50,
          //   height: 50,
          //   fit: BoxFit.cover,
          // ),
          SizedBox(width: 8),
          Text(
            'TTL',
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
      actions: [
        CircleAvatar(
          backgroundImage: NetworkImage('https://example.com/avatar.jpg'),
        ),
        SizedBox(width: 16),
      ],
    );
  }
}