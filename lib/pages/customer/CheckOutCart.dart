import 'dart:math';

import 'package:ecommercettl/models/UserModel.dart';
import 'package:ecommercettl/pages/customer/component/CartItem.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ecommercettl/models/CartModel.dart';
import 'package:ecommercettl/models/Product.dart';
import 'package:ecommercettl/models/VoucherModel.dart';
import 'package:ecommercettl/services/customer_service.dart';
import 'package:ecommercettl/pages/customer/component/shopVoucher.dart';

class CheckOutCart extends StatefulWidget {
  final List<Product?> listProduct;
  final List<Cart> listCart;
  final UserModel customer;
  const CheckOutCart({Key? key, required this.listProduct, required this.listCart, required this.customer}) : super(key: key);

  @override
  State<CheckOutCart> createState() => _CheckOutCartState();
}

class _CheckOutCartState extends State<CheckOutCart> {
  CustomerService customerService = CustomerService();
  Map<String, Voucher?> selectedVouchers = {};
  double selectedAdminVoucher = 0;
  Voucher? AdminSelectedVoucher;
  List<Voucher> adminVoucherList = List.empty();
  double totalOrderAmount = 0;
  Map<String, double> deliveryCosts = {};
  double totalDeliveryCost = 0;

  Map<String, TextEditingController> _messageControllers = {};
  String message = "";

  @override
  void initState() {
    super.initState();
    calculateDeliveryCost(widget.listCart);
    calculateTotalOrderAmount();
    fetchAdminVouchers();
    for (var cart in widget.listCart) {
      if (!_messageControllers.containsKey(cart.shopId)) {
        _messageControllers[cart.shopId] = TextEditingController();
      }
    };
  }
  @override
  void dispose() {
    // Dispose of all message controllers
    for (var controller in _messageControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void calculateDeliveryCost(List<Cart> cartItems) {
    Map<String, double> shopTotals = {};
    Map<String, double> newDeliveryCosts = {};

    // Calculate total price for each shop
    for (var item in cartItems) {
      shopTotals[item.shopName] = (shopTotals[item.shopName] ?? 0) + (item.price * item.quantity);
    }

    // Calculate delivery cost for each shop
    shopTotals.forEach((shopName, total) {
      if (total > 1500000) {
        newDeliveryCosts[shopName] = 0;
      } else if (total > 690000) {
        newDeliveryCosts[shopName] = 15000;
      } else if (total > 300000) {
        newDeliveryCosts[shopName] = 25000;
      } else {
        newDeliveryCosts[shopName] = 33000;
      }
    });

    setState(() {
      deliveryCosts = newDeliveryCosts;
      totalDeliveryCost = newDeliveryCosts.values.reduce((sum, cost) => sum + cost);
    });
  }

  void calculateTotalOrderAmount() {
    double total = 0;
    Map<String, Map<String, dynamic>> groupedItems = groupCartItemsByShopName();

    groupedItems.forEach((shopId, shopData) {
      List<Cart> items = shopData['items'];
      double shopTotal = items.fold(0, (sum, item) => sum + (item.price * item.quantity));
      double discount = calculateShopDiscount(shopId, shopTotal);
      total += shopTotal - discount + (deliveryCosts[shopId] ?? 0);
    });

    // Apply admin voucher discount
    double adminDiscount = calculateAdminDiscount();
    total -= adminDiscount;

    setState(() {
      totalOrderAmount = total;
    });
  }
  Map<String, Map<String, dynamic>> groupCartItemsByShopName() {
    Map<String, Map<String, dynamic>> groupedItems = {};
    for (var cart in widget.listCart) {
      if (!groupedItems.containsKey(cart.shopName)) {
        groupedItems[cart.shopName] = {
          'items': <Cart>[],
          'shopImg': cart.shopimg,
        };
      }
      (groupedItems[cart.shopName]!['items'] as List<Cart>).add(cart);
    }
    return groupedItems;
  }

  double calculateShopDiscount(String shopName, double price) {
    if (selectedVouchers[shopName] != null) {
      return (price * selectedVouchers[shopName]!.discount / 100);
    }
    return 0;
  }
  double calculateTotalShopDiscount() {
    double totalDiscount = 0;
    Map<String, Map<String, dynamic>> groupedItems = groupCartItemsByShopName();

    groupedItems.forEach((shopId, shopData) {
      List<Cart> items = shopData['items'];
      double shopTotal = items.fold(0, (sum, item) => sum + (item.price * item.quantity));
      totalDiscount += calculateShopDiscount(shopId, shopTotal);
    });

    return totalDiscount;
  }

  Future<List<Voucher>?> fetchVouchers(String shopId) async {
    try {
      List<Voucher> voucherList = await customerService.fetchVouchersByShopId(shopId);
      setState(() {}); // Refresh the UI
      return voucherList;
    } catch (error) {
      print("Error fetching vouchers: $error");
    }
    return null;
  }
  Future<void> fetchAdminVouchers() async {
    try {
      adminVoucherList = await customerService.fetchVouchersByADmin();
      setState(() {}); // Refresh the UI
    } catch (error) {
      print("Error fetching vouchers: $error");
    }
  }

   double calculateAdminDiscount() {
    if (AdminSelectedVoucher != null && totalOrderAmount > AdminSelectedVoucher!.condition) {
      double discount = (totalOrderAmount * AdminSelectedVoucher!.discount / 100)
          .clamp(0, AdminSelectedVoucher!.maxDiscount);
      return discount;
    }
    return 0;
  }
  String generateRandomString(int length) {
    const characters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    
    // Use a Set to ensure characters are unique
    final uniqueCharacters = <String>{};
    
    while (uniqueCharacters.length < length) {
      // Generate a random index to select a character
      final randomIndex = random.nextInt(characters.length);
      // Add the character to the set (duplicates are ignored)
      uniqueCharacters.add(characters[randomIndex]);
    }
    
    // Convert the set to a string
    return uniqueCharacters.join('');
  }

  Future<void> createOrder() async {
    String cusId = widget.customer.id;
    String name = widget.customer.fullName;
    String phone = widget.customer.phone;
    String address = widget.customer.address;
    String status = "Đang đợi xét duyệt";
    DateTime orderDate = DateTime.now();

    CustomerService customerService = CustomerService();

    // Group cart items by shop
    Map<String, List<Cart>> shopOrders = {};
    for (var item in widget.listCart) {
      if (!shopOrders.containsKey(item.shopId)) {
        shopOrders[item.shopId] = [];
      }
      shopOrders[item.shopId]!.add(item);
    }

    try {
      // Create an order for each shop
      for (var entry in shopOrders.entries) {
        String shopId = entry.key;
        List<Cart> shopItems = entry.value;
        
        // Generate a unique order code for each shop
        String orderCode = generateRandomString(10);

        // Calculate total price for this shop's order
        double shopTotal = shopItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

        // Get shop-specific voucher
        String? shopVoucher = selectedVouchers[shopId]?.voucherID;

        // Get shop-specific message
        String shopMessage = _messageControllers[shopId]?.text ?? "";
        
        // Fetch the first product's details to use as the order's main product
        Product? firstProduct = await customerService.fetchProductById(shopItems.first.productId);

        // Create the order for this shop
        await customerService.addOrder(
          orderCode,
          orderDate,
          shopVoucher ?? "",
          AdminSelectedVoucher?.voucherID ?? "",
          shopTotal,
          cusId,
          name,
          phone,
          address,
          status,
          shopMessage,
          shopId,
          firstProduct!.imageUrls[0].isNotEmpty ? firstProduct.imageUrls[0] : '',
          firstProduct.name,
          shopTotal,
          shopItems.length,
          "", // Leave color blank as it's per item
          "", // Leave size blank as it's per item
          shopItems.fold(0, (sum, item) => sum! + item.quantity),
        );

        // Add order details for each product in this shop's order
        for (var item in shopItems) {
          // Fetch product details for each item
          Product? product = await customerService.fetchProductById(item.productId);
          
          await customerService.addOrderDetails(
            orderCode,
            item.productId,
            cusId,
            item.size ?? "",
            item.color ?? "",
            item.quantity,
          );
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Orders created successfully!')),
      );
      Navigator.pop(context);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create orders: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, Map<String, dynamic>> groupedCartItems = groupCartItemsByShopName();
    calculateTotalOrderAmount();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Thanh toán'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.red),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Free shipping banner
            Container(
              color: Color(0xFFFFF8E7),
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  Text(
                    'FREE\nSHIP',
                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text('Đã áp dụng Mã miễn phí vận chuyển'),
                  ),
                ],
              ),
            ),

            // Shipping address
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined),
                      SizedBox(width: 8),
                      Text('Địa chỉ nhận hàng'),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Đào Trung Thành | (+84) 946 814 775'),
                        Text('Ngã Tư Lưu Quang Vũ, Đường Mai Đăng Chơn\nPhường Hòa Quý, Quận Ngũ Hành Sơn, Đà Nẵng'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Store sections
            for (var entry in groupedCartItems.entries)
              buildShopSection(
                entry.key,
                entry.value['shopImg'] as String,
                (entry.value['items'] as List<Cart>),
              ),
            ElevatedButton(
              onPressed: () async {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.black.withOpacity(0.7),
                  builder: (BuildContext context) {
                    return VoucherShop(
                      shop: "Admin",
                      price: totalOrderAmount,
                      voucherList: adminVoucherList,
                      onVoucherSelected: (Voucher? userSelectedVoucher) {
                        if (userSelectedVoucher != null) {
                          setState(() {
                            AdminSelectedVoucher = userSelectedVoucher;
                            calculateTotalOrderAmount();
                          });
                          print('Selected Admin Voucher: ${userSelectedVoucher.discount}%');
                        } else {
                          print('No admin voucher selected');
                        }
                        Navigator.pop(context);
                      },
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: EdgeInsets.zero,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                  side: BorderSide.none,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.ticket,
                        color: Colors.blue.shade700,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Voucher của Sàn',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        selectedAdminVoucher != 0
                            ? '-${NumberFormat("#,###", "vi_VN").format(calculateAdminDiscount())}đ'
                            : 'Chọn hoặc nhập mã',
                        style: TextStyle(
                          fontSize: 16,
                          color: selectedAdminVoucher != 0 ? Colors.green : Colors.grey,
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        size: 18,
                      ),
                    ],
                  )
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: [
                Text(
                  'Phương thức thanh toán',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 4), 
                Text(
                  'Thanh toán khi nhận hàng',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            Divider(),
            buildPaymentDetails(),
          ],
        ),
      ),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  Widget buildShopSection(String shopName, String shopImg, List<Cart> cartItems) {
    double shopTotal = cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
    double discount = calculateShopDiscount(shopName, shopTotal);
    double shopDeliveryCost = deliveryCosts[shopName] ?? 0;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Shop name
          Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                shopImg != null && shopImg.isNotEmpty 
                ? ClipOval(
                    child: Image.network(
                      shopImg,
                      width: 30,
                      height: 30,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'NO IMG',
                            style: TextStyle(fontSize: 10, color: Colors.white),
                          ),
                        );
                      },
                    ),
                  )
                : Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'NO IMG',
                      style: TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  ),
                SizedBox(width: 8),
                Text(
                  shopName,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ),
          // Products list
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              var cartItem = cartItems[index];
              var product = widget.listProduct.firstWhere((p) => p?.id == cartItem.productId, orElse: () => null);
              if (product != null) {
                return ProductItem(
                  product: product,
                  cart: cartItem,
                  details: {
                    'size': cartItem.size,
                    'color': cartItem.color,
                    'quantity': cartItem.quantity,
                  },
                );
              }
              return SizedBox();
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Lời nhắn cho Shop',
                  style: TextStyle(fontSize: 18), // Adjust the font size here
                ),
                Expanded(
                  child: TextField(
                    controller: _messageControllers[cartItems.first.shopId],
                    decoration: InputDecoration(
                      hintText: 'Để lại lời nhắn',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                    ),
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          Divider(),
          // Shop total and discount
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tổng tiền hàng: ${NumberFormat("#,###", "vi_VN").format(shopTotal)}đ'),
                if (discount > 0)
                  Text('Giảm giá: -${NumberFormat("#,###", "vi_VN").format(discount)}đ',
                      style: TextStyle(color: Colors.green)),
                Text('Phí vận chuyển: ${NumberFormat("#,###", "vi_VN").format(shopDeliveryCost)}đ'),
                Text('Tổng sau giảm giá và phí vận chuyển: ${NumberFormat("#,###", "vi_VN").format(shopTotal - discount + shopDeliveryCost)}đ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          // Shop voucher button
          ElevatedButton(
            onPressed: () async {
              String shopId = cartItems.first.shopId;
              List<Voucher>? fetchedVouchers = await fetchVouchers(shopId);
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.black.withOpacity(0.7),
                builder: (BuildContext context) {
                  return VoucherShop(
                    shop: shopName,
                    price: shopTotal,
                    voucherList: fetchedVouchers!,
                    onVoucherSelected: (Voucher? userSelectedVoucher) {
                      if (userSelectedVoucher != null) {
                        setState(() {
                          selectedVouchers[shopName] = userSelectedVoucher;
                          calculateTotalOrderAmount();
                        });
                        print('Selected Voucher: ${userSelectedVoucher.discount}%');
                      } else {
                        print('No voucher selected');
                      }
                      Navigator.pop(context);
                    },
                  );
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              padding: EdgeInsets.zero,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
                side: BorderSide.none,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.ticket,
                      color: Colors.redAccent.shade700,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Voucher của Shop',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      selectedVouchers[shopName] != null
                          ? '-${NumberFormat("#,###", "vi_VN").format(discount)}đ'
                          : 'Chọn hoặc nhập mã',
                      style: TextStyle(
                        fontSize: 16,
                        color: selectedVouchers[shopName] != null ? Colors.green : Colors.grey,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      size: 18,
                    ),
                  ],
                )
              ],
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
  Widget buildPaymentDetails() {
    double subtotal = widget.listCart.fold(0, (sum, item) => sum + (item.price * item.quantity));
    double totalShopDiscount = calculateTotalShopDiscount();
    double adminDiscount = calculateAdminDiscount();
    double totalVoucherDiscount = totalShopDiscount + adminDiscount;
    double totalDeliveryCost = deliveryCosts.values.reduce((sum, cost) => sum + cost);

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.receipt_long_rounded,
                color: Colors.orange,
                size: 30,
              ),
              SizedBox(width: 10),
              Text(
                'Chi tiết thanh toán',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),

          // Payment Details Rows
          _buildDetailRow('Tổng tiền hàng', subtotal),
          _buildDetailRow('Tổng tiền phí vận chuyển', totalDeliveryCost),
          _buildDetailRow('Shop voucher', -totalShopDiscount, isDiscount: true),
          _buildDetailRow('TTL Voucher', -adminDiscount, isDiscount: true),
          _buildDetailRow('Tổng cộng Voucher giảm giá', -totalVoucherDiscount, isDiscount: true),
            
          Divider(height: 24),
          
          // Total Amount
          _buildDetailRow(
            'Tổng thanh toán',
            totalOrderAmount,
            textStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.red.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, double amount, {
    bool isDiscount = false,
    TextStyle? textStyle,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: textStyle ?? TextStyle(fontSize: 14),
          ),
          Text(
            '${isDiscount ? '-' : ''}đ${NumberFormat("#,###", "vi_VN").format(amount.abs())}',
            style: textStyle ?? TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget buildBottomNavigationBar() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tổng thanh toán'),
              Text(
                '${NumberFormat("#,###", "vi_VN").format(totalOrderAmount)}đ',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              createOrder().then((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Order created successfully!')),
                );
              }).catchError((error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to create order: $error')),
                );
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: Text(
              'Đặt hàng',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductItem extends StatelessWidget {
  final Cart cart;
  final Product product;
  final Map<String, dynamic> details;

  const ProductItem({
    Key? key,
    required this.product,
    required this.cart,
    required this.details,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            product.imageUrls.isNotEmpty ? product.imageUrls[0] : 'PlaceHolde',
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text('Phân loại: ${details['color'] ?? 'N/A'}, ${details['size'] ?? 'N/A'}'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'đ${NumberFormat("#,###", "vi_VN").format(cart.price)}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('x${details['quantity'] ?? 1}'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}