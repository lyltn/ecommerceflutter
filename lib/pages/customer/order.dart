import 'package:ecommercettl/models/OrderDetail.dart';
import 'package:ecommercettl/models/OrderModel.dart';
import 'package:ecommercettl/models/Product.dart';
import 'package:ecommercettl/pages/client/shopbottomnav.dart';
import 'package:ecommercettl/pages/customer/bottomnav.dart';
import 'package:ecommercettl/pages/customer/navigatiorder/shopcanceledpage.dart';
import 'package:ecommercettl/pages/customer/navigatiorder/OrderWaiting.dart';
import 'package:ecommercettl/pages/customer/navigatiorder/shopdeliveredpage.dart';
import 'package:ecommercettl/pages/customer/navigatiorder/ShopPlaced.dart';
import 'package:ecommercettl/pages/customer/navigatiorder/shopreturngoods.dart';
import 'package:ecommercettl/pages/customer/navigatiorder/ShopShiping.dart';
import 'package:ecommercettl/services/customer_service.dart';
import 'package:ecommercettl/services/shop_service.dart';

import 'package:ecommercettl/widget/widget_support.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  int currentTabIndex = 0;

  late List<String> pages;

  late SharedPreferences prefs;
  String? cusId;
  String query = "Đang đợi xét duyệt";

  List<OrderModel> filteredOrders = List.empty();

  // Change this to List<OrderModel> to hold flattened orders
  List<OrderModel> listOrder = List.empty();
  CustomerService customerService = CustomerService();

  List<List<OrderModel>> cachedOrders = List.generate(6, (_) => []);

  bool isLoading = false;
  bool isTimeOut = false;
  

  @override
  void initState() {
    super.initState();
    currentTabIndex = 0;
    _loadPreferences(); 
    _loadCachedOrders();
  }

  void _loadCachedOrders() {
    print("catche: ${cachedOrders}");
    if (cachedOrders.isNotEmpty) {
      setState(() {
        // Flatten the cachedOrders and assign to listOrder
        listOrder = cachedOrders.expand((i) => i).toList();
      });
    } else {
      // Handle empty cache case if needed
    }
  }

  Future<void> _loadPreferences() async {
    prefs = await SharedPreferences.getInstance();
    ShopService shopService = ShopService();
    cusId = FirebaseAuth.instance.currentUser!.uid;
 

    if (cusId != null) {
      await _loadOrder(currentTabIndex); 
      print('Loaded cusId: ${prefs.getString('cusId')}');

    } else {
      print('cusId is null neee');       
    }
  }

  Future<void> _loadOrder(int tabIndex) async {
    if (cachedOrders[tabIndex].isNotEmpty) {
      return;
    }
    setState(() {
      isLoading = true; 
      isTimeOut = false;
    });

    Future.delayed(Duration(seconds: 20), () {
      if (isLoading) {
        setState(() {
          isTimeOut = true; 
          isLoading = false;
        });
      }
    });

    try {
        print("CussidFecthne${cusId}");
      if (cusId != null) {
        print("CussidFecthne${cusId}");
        listOrder = await customerService.fetchOrder(cusId!, query);
        // List<OrderModel> ordersWithDetails = [];

        // for (var order in orders) {
        //   OrderDetail? orderDetail = await customerService.fetchOrderDetail(order.orderCode);
        //   int totalProduct = await customerService.numberOfProduct(order.orderCode);
        //   order.detail = orderDetail;
        //   order.productCount = totalProduct;

        //   if (order.detail != null && order.detail!.productId != null) {
        //     final productId = order.detail!.productId!;
        //     Product? pro = await customerService.fetchProductById(productId);

        //     if (pro != null) {
        //       order.productImg = pro.imageUrls.isNotEmpty ? pro.imageUrls[0] : null;
        //       order.productName = pro.name;
        //       order.productPrice = pro.price;
        //     } else {
        //       print('Product not found for productId: $productId');
        //     }
        //   } else {
        //     print('Order detail or productId is null for orderCode: ${order.orderCode}');
        //   }

          // ordersWithDetails.add(order);
        };
        setState(() {
          cachedOrders[tabIndex] = listOrder; 
          listOrder = cachedOrders.expand((i) => i).toList();
        });
    } catch (e) {
      print('Error loading orders: $e');
    } finally {
      if (!isTimeOut) {
        setState(() {
          isLoading = false; // End loading state
        });
      }
    }
  }

  Future<Widget> _loadPage(int numberOfPage) async {
    print("loadPAge:${numberOfPage}");
    print("curentpage:${currentTabIndex}");
    print("query:${query}");

    switch (numberOfPage) {
      case 0:
        filteredOrders = listOrder.where((order) => order.status == "Đang đợi xét duyệt").toList();
        print("ditocnemeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee${filteredOrders}");
        return OrderWaiting(listOrder: filteredOrders);
      case 1:
        filteredOrders = listOrder.where((order) => order.status == "Đã duyệt").toList();
        return ShopPlacedPage(listOrder: filteredOrders);
      case 2:
        filteredOrders = listOrder.where((order) => order.status == "Đang giao tới khách").toList();
        return ShopShipingPage(listOrder: filteredOrders);
      case 3:
        filteredOrders = listOrder.where((order) => order.status  == "Đã giao" && order.reviews == 0).toList();
        return ShopDeliveredPage(listOrder: filteredOrders, cusId: cusId!,);
      case 4:
        filteredOrders = listOrder.where((order) => order.status == "Đã huỷ").toList();
        return ShopCanceledPage();
      case 5:
        filteredOrders = listOrder.where((order) => order.status == "Trả hàng").toList();
        return Shopreturngoods();
      default:
        return Text("Error");
    }

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
          const SizedBox(height: 20.0),
          Container(
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  buildTab('Chờ xác nhận', 0),
                  buildTab('Chờ lấy hàng', 1),
                  buildTab('Chờ giao hàng', 2),
                  buildTab('Đã giao', 3),
                  buildTab('Đã huỷ', 4),
                  buildTab('Trả hàng', 5),
                ],
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? LoadingScreen() // Show LoadingScreen while loading
                : isTimeOut
                    ? Center(child: Text('Không có dữ liệu')) // Show message if timeout
                    : FutureBuilder<Widget>(
                        future: _loadPage(currentTabIndex),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return LoadingScreen(); // Show LoadingScreen in FutureBuilder
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Có lỗi xảy ra: ${snapshot.error}'));
                          } else {
                            // Check if filteredOrders is empty after loading
                            if (filteredOrders == null || filteredOrders.isEmpty) {
                              return Center(child: Text('Không có dữ liệu')); // Show message if orders are empty
                            }
                            return snapshot.data!;
                          }
                        },
                      ),
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
          switch (index) {
            case 0:
              query = "Đang đợi xét duyệt";
              break;
            case 1:
              query = "Đã duyệt";
              break;
            case 2:
              query = "Đang giao tới khách";
              break;
            case 3:
              query = "Đã giao";
              break;
            case 4:
              query = "Bị huỷ";
              break;
            case 5:
              query = "Trả hàng";
              break;
          }
          _loadOrder(currentTabIndex); 
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 17),
        decoration: BoxDecoration(
          color: currentTabIndex == index
              ? const Color(0xFFE1F5E6)
              : Colors.white, // Background color for selected and non-selected tabs
          border: Border.all(
            color: const Color(0xFF00A962), // Border color for all tabs
            width: 1, // Border thickness
          ),
          borderRadius: BorderRadius.circular(3.0), // Border radius
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // Light shadow color
              spreadRadius: 2, // Shadow spread
              blurRadius: 3, // Shadow blur
              offset: const Offset(0, 1), // Shadow position
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
            color: currentTabIndex == index ? const Color(0xFF00A962) : Colors.black,
          ),
        ),
      ),
    );
  }
   Widget LoadingScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(), // Vòng tròn loading
          SizedBox(height: 20), // Khoảng cách giữa loading và text
          Text(
            "Đang tải dữ liệu...",
            style: TextStyle(fontSize: 18, color: Colors.black), // Văn bản hiển thị
          ),
        ],
      ),
    );
  }
}
