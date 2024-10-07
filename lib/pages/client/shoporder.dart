import 'package:ecommercettl/pages/shopbottomnav.dart';
import 'package:ecommercettl/pages/shopcanceledpage.dart';
import 'package:ecommercettl/pages/shopconfirmpage.dart';
import 'package:ecommercettl/pages/shopdeliveredpage.dart';
import 'package:ecommercettl/pages/shopplacedPage.dart';
import 'package:ecommercettl/pages/shopreturngoods.dart';
import 'package:ecommercettl/pages/shopshippingpage.dart';
import 'package:ecommercettl/pages/shopwaitdelivery.dart';
import 'package:ecommercettl/widget/widget_support.dart';
import 'package:flutter/material.dart';

class OrderShop extends StatefulWidget {
  const OrderShop({super.key});

  @override
  State<OrderShop> createState() => _OrderShopState();
}

class _OrderShopState extends State<OrderShop> {
  int currentTabIndex = 0;

  late List<Widget> pages;
  late Widget confirmPage;
  late Widget placedPage;
  late Widget shippingPage;
  late Widget deliveredPage;
  late Widget canceledPage;
  late Widget returngoods;
  late Widget waitdelivery;

  @override
  void initState() {
    super.initState();
    confirmPage = ShopConfirmpage();
    placedPage = ShopPlacedPage();
    shippingPage = ShopShippingPage();
    deliveredPage = ShopDeliveredPage();
    canceledPage = ShopCanceledPage();
    returngoods = Shopreturngoods();
    waitdelivery = Shopwaitdelivery();
    pages = [
      confirmPage,
      placedPage,
      shippingPage,
      deliveredPage,
      canceledPage,
      returngoods,
      waitdelivery,
    ]; // Total of 7 pages, index from 0 to 6
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Row(
            children: [
              Image.asset(
                "images/logo-admin.png",
                height: 33.0,
                width: 33.0,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                width: 10.0,
              ),
              Text(
                "TTL",
                style: AppWiget.HeadlineTextFeildStyle(),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1.0, left: 20.0, right: 20.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: const Icon(Icons.search_outlined),
                      contentPadding: const EdgeInsets.symmetric(vertical: 5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20.0),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BottomnavShop()));
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF15A362), // Background color
                      shape: BoxShape.circle, // Makes the background circular
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(Icons.home_outlined, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20.0),
          Container(
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  buildTab('Chờ xác nhận', 0),
                  buildTab('Đã đặt', 1),
                  buildTab('Đang giao', 2),
                  buildTab('Đã giao', 3),
                  buildTab('Đã huỷ', 4),
                  buildTab('Trả hàng', 5),
                  buildTab('Chờ lấy hàng', 6),
                ],
              ),
            ),
          ),
          Expanded(
            child: pages[currentTabIndex], // Show the current selected page
          ),
        ],
      ),
    );
  }

  Widget buildTab(String text, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          currentTabIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 17),
        decoration: BoxDecoration(
          color: currentTabIndex == index
              ? Color(0xFFE1F5E6)
              : Colors.white, // Màu nền cho tab được chọn và không được chọn
          border: Border.all(
            color: Color(0xFF00A962), // Màu viền xanh cho tất cả các ô
            width: 1, // Độ dày viền
          ),
          borderRadius: BorderRadius.circular(3.0), // Bo góc 3
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // Màu đổ bóng nhẹ
              spreadRadius: 2, // Độ lan của bóng
              blurRadius: 3, // Độ mờ của bóng
              offset: Offset(0, 2), // Vị trí bóng (x, y)
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Color(0xFF00A962), // Màu xanh cho tất cả văn bản
            fontWeight: FontWeight.bold, // In đậm cho văn bản
          ),
          textAlign: TextAlign.center, // Căn giữa văn bản
        ),
      ),
    );
  }
}
