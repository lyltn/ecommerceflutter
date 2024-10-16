import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:ecommercettl/pages/customer/home.dart';
import 'package:ecommercettl/pages/customer/order.dart';
import 'package:ecommercettl/pages/customer/post.dart';
import 'package:ecommercettl/pages/customer/profile.dart';
import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentTabIndex = 0;

  late List<Widget> pages;
  late Widget currentPage;
  late Home homepage;
  late Profile profile;
  late Post post;
  late Order order;

  @override
  void initState() {
    homepage = Home();
    order = Order();
    profile = Profile();
    post = Post();
    pages = [homepage, post, order, profile];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min, // Đảm bảo kích thước cột tối thiểu
        children: [
          CurvedNavigationBar(
            height: 50,
            backgroundColor: Colors.white,
            color: const Color(0xFF15A362),
            animationDuration:
                const Duration(milliseconds: 500), // Đổi thành milliseconds
            onTap: (int index) {
              setState(() {
                currentTabIndex = index;
              });
            },
            items: const [
              Icon(Icons.home_outlined, color: Colors.white),
              Icon(Icons.article_outlined, color: Colors.white),
              Icon(Icons.local_shipping_outlined, color: Colors.white),
              Icon(Icons.person_outline, color: Colors.white),
            ],
          ),
          // Phần tên tab nằm dưới biểu tượng của thanh điều hướng
        ],
      ),
      body: pages[currentTabIndex],
    );
  }
}
