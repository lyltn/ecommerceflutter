import 'package:ecommercettl/main.dart';
import 'package:ecommercettl/pages/admin/adminhome.dart';
import 'package:flutter/material.dart';

class LeftNavigation extends StatelessWidget {
  const LeftNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                'nguyen thi kim ngan',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              accountEmail: Text(
                'ngan@gmail.com',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('images/image 47.png'),
              ),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
            ),
            ListTile(
              leading: Icon(Icons.home_rounded),
              title: Text('Trang chủ'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminHome()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Quản lý người dùng'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.card_giftcard),
              title: Text('Quản lý voucher'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.article),
              title: Text('Quản lý bài đăng'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.bar_chart),
              title: Text('Quản lý thống kê'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
