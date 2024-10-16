import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:ecommercettl/pages/client/shophome.dart';
import 'package:ecommercettl/pages/client/shoporder.dart';
import 'package:ecommercettl/pages/client/shopprofile.dart';
import 'package:ecommercettl/pages/client/shopresource.dart';
import 'package:flutter/material.dart';

class BottomnavShop extends StatefulWidget {
  const BottomnavShop({super.key});

  @override
  State<BottomnavShop> createState() => _BottomnavShopState();
}

class _BottomnavShopState extends State<BottomnavShop> {
  int currentTabIndex = 0;

  late List<Widget> pages;
  late Widget currentPage;
  late HomeShop homeShop;
  late ResourceShop resourceShop;
  late ProfileShop profileShop;
  late OrderShop orderShop;

  @override
  void initState() {
    homeShop = HomeShop();
    resourceShop = ResourceShop();
    profileShop = ProfileShop();
    orderShop = OrderShop();
    pages = [homeShop, resourceShop, orderShop, profileShop];
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
              Icon(Icons.category_outlined, color: Colors.white),
              Icon(Icons.receipt_long_outlined, color: Colors.white),
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
