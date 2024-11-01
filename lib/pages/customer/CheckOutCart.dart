import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
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
  Map<String, Voucher> selectedVouchers = {};
  Voucher? AdminSelectedVoucher;
  List<Voucher> adminVoucherList = [];
  double totalOrderAmount = 0;
  double totalShopAmount = 0;
  Map<String, double> deliveryCosts = {};
  double totalDeliveryCost = 0;
  Map<String, double> shopPricesBeforeDiscount = {};
  Map<String, double> shopPricesAfterDiscount = {};

  Map<String, TextEditingController> _messageControllers = {};

  @override
  void initState() {
    super.initState();
    calculateDeliveryCost(widget.listCart);
    calculateShopPrices();
    calculateTotalOrderAmount();
    fetchAdminVouchers();
    for (var cart in widget.listCart) {
      if (!_messageControllers.containsKey(cart.shopId)) {
        _messageControllers[cart.shopId] = TextEditingController();
      }
    }
    print("Initial selectedVouchers: $selectedVouchers");
  }

  @override
  void dispose() {
    for (var controller in _messageControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void calculateDeliveryCost(List<Cart> cartItems) {
    Map<String, double> shopTotals = {};
    Map<String, double> newDeliveryCosts = {};

    for (var item in cartItems) {
      shopTotals[item.shopId] = (shopTotals[item.shopId] ?? 0) + (item.price * item.quantity);
    }

    shopTotals.forEach((shopId, total) {
      if (total > 1500000) {
        newDeliveryCosts[shopId] = 0;
      } else if (total > 690000) {
        newDeliveryCosts[shopId] = 15000;
      } else if (total > 300000) {
        newDeliveryCosts[shopId] = 25000;
      } else {
        newDeliveryCosts[shopId] = 33000;
      }
    });

    setState(() {
      deliveryCosts = newDeliveryCosts;
      totalDeliveryCost = newDeliveryCosts.values.reduce((sum, cost) => sum + cost);
    });
  }

  void calculateShopPrices() {
    Map<String, double> beforeDiscount = {};
    Map<String, double> afterDiscount = {};

    for (var entry in groupCartItemsByShopId().entries) {
      String shopId = entry.key;
      List<Cart> items = entry.value['items'];
      double shopTotal = items.fold(0, (sum, item) => sum + (item.price * item.quantity));
      beforeDiscount[shopId] = shopTotal;
      double discount = calculateShopDiscount(shopId, shopTotal);
      afterDiscount[shopId] = shopTotal - discount;
    }

    setState(() {
      shopPricesBeforeDiscount = beforeDiscount;
      shopPricesAfterDiscount = afterDiscount;
    });
  }

  void calculateTotalOrderAmount() {
    double totalBeforeDiscount = shopPricesBeforeDiscount.values.reduce((sum, price) => sum + price);
    double totalAfterShopDiscounts = shopPricesAfterDiscount.values.reduce((sum, price) => sum + price);
    double shopDiscount = totalBeforeDiscount - totalAfterShopDiscounts;
    
    double adminDiscount = calculateAdminDiscount(totalBeforeDiscount);
    
    double finalTotal = totalBeforeDiscount + totalDeliveryCost - shopDiscount - adminDiscount;

    setState(() {
      totalShopAmount = totalBeforeDiscount;
      totalOrderAmount = finalTotal;
    });

    print('Total Before Discount: $totalBeforeDiscount');
    print('Shop Discount: $shopDiscount');
    print('Total Delivery Cost: $totalDeliveryCost');
    print('Admin Discount: $adminDiscount');
    print('Final Total Order Amount: $finalTotal');
  }

  Map<String, Map<String, dynamic>> groupCartItemsByShopId() {
    Map<String, Map<String, dynamic>> groupedItems = {};
    for (var cart in widget.listCart) {
      if (!groupedItems.containsKey(cart.shopId)) {
        groupedItems[cart.shopId] = {
          'items': <Cart>[],
          'shopImg': cart.shopimg,
          'shopName': cart.shopName,
        };
      }
      (groupedItems[cart.shopId]!['items'] as List<Cart>).add(cart);
    }
    return groupedItems;
  }

  double calculateShopDiscount(String shopId, double price) {
    if (selectedVouchers.containsKey(shopId)) {
      Voucher voucher = selectedVouchers[shopId]!;
      double discount = (price * voucher.discount / 100).clamp(0, voucher.maxDiscount);
      print("Calculating discount for shop $shopId: $discount");
      return discount;
    }
    print("No discount applied for shop $shopId");
    return 0;
  }

  Future<List<Voucher>?> fetchVouchers(String shopId) async {
    try {
      List<Voucher> voucherList = await customerService.fetchVouchersByShopId(shopId);
      setState(() {});
      return voucherList;
    } catch (error) {
      print("Error fetching vouchers: $error");
    }
    return null;
  }

  Future<void> fetchAdminVouchers() async {
    try {
      adminVoucherList = await customerService.fetchVouchersByADmin();
      setState(() {});
    } catch (error) {
      print("Error fetching admin vouchers: $error");
    }
  }

  double calculateAdminDiscount(double total) {
    if (AdminSelectedVoucher != null && total > AdminSelectedVoucher!.condition) {
      double discount = (total * AdminSelectedVoucher!.discount / 100)
          .clamp(0, AdminSelectedVoucher!.maxDiscount);
      print("Admin discount: $discount");
      return discount;
    }
    print("No admin discount applied");
    return 0;
  }

  String generateRandomString(int length) {
    const characters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    final uniqueCharacters = <String>{};
    
    while (uniqueCharacters.length < length) {
      final randomIndex = random.nextInt(characters.length);
      uniqueCharacters.add(characters[randomIndex]);
    }
    
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

    Map<String, List<Cart>> shopOrders = groupCartItemsByShopId().map((key, value) => MapEntry(key, value['items'] as List<Cart>));

    try {
      
      for (var entry in shopOrders.entries) {
        String orderCode = generateRandomString(10);
        String shopId = entry.key;
        List<Cart> shopItems = entry.value;

        double shopPriceBeforeDiscount = shopPricesBeforeDiscount[shopId] ?? 0;
        double shopPriceAfterDiscount = shopPricesAfterDiscount[shopId] ?? 0;
        double delivery = deliveryCosts[shopId] ?? 0;

        String shopVoucher = selectedVouchers[shopId]?.voucherID ?? "";
        print("shopId: $shopId, shopVoucher: $shopVoucher");

        String shopMessage = _messageControllers[shopId]?.text ?? "";
        print("Shop message: $shopMessage");

        Product? firstProduct = await customerService.fetchProductById(shopItems.first.productId);

        await customerService.addOrder(
          orderCode,
          orderDate,
          AdminSelectedVoucher?.voucherID ?? "",
          shopVoucher,
          shopPriceAfterDiscount + delivery - calculateAdminDiscount(shopPriceBeforeDiscount),
          cusId,
          name,
          phone,
          address,
          status,
          shopMessage,
          shopId,
          firstProduct!.imageUrls.isNotEmpty ? firstProduct.imageUrls[0] : '',
          firstProduct.name,
          shopPriceBeforeDiscount + delivery,
          shopItems.length,
          shopItems.first.color ?? "",
          shopItems.first.size ?? "",
          shopItems.fold(0, (sum, item) => sum! + item.quantity),
          calculateAdminDiscount(shopPriceBeforeDiscount),
        );

        for (var item in shopItems) {
          await customerService.addOrderDetails(
            orderCode,
            item.productId,
            cusId,
            item.size ?? "",
            item.color ?? "",
            item.quantity
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
    Map<String, Map<String, dynamic>> groupedCartItems = groupCartItemsByShopId();
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
                        Text('${widget.customer.fullName} | ${widget.customer.phone}'),
                        Text(widget.customer.address),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            for (var entry in groupedCartItems.entries)
              buildShopSection(
                entry.key,
                entry.value['shopImg'] as String,
                entry.value['shopName'] as String,
                (entry.value['items'] as List<Cart>),
              ),
            buildAdminVoucherButton(),
            buildPaymentMethodSection(),
            Divider(),
            buildPaymentDetails(),
          ],
        ),
      ),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  Widget buildShopSection(String shopId, String shopImg, String shopName, List<Cart> cartItems) {
    double shopTotal = shopPricesBeforeDiscount[shopId] ?? 0;
    double discount = shopTotal - (shopPricesAfterDiscount[shopId] ?? 0);
    double shopDeliveryCost = deliveryCosts[shopId] ?? 0;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                shopImg.isNotEmpty 
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
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              var cartItem = cartItems[index];
              var product = 
                  widget.listProduct.firstWhere((p) => p?.id == cartItem.productId, orElse: () => null);
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
          buildShopMessageInput(shopId),
          Divider(),
          buildShopTotalSection(shopTotal, discount, shopDeliveryCost),
          buildShopVoucherButton(shopId, shopName, shopTotal),
          Divider(),
        ],
      ),
    );
  }

  Widget buildShopMessageInput(String shopId) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Lời nhắn cho Shop',
          style: TextStyle(fontSize: 18),
        ),
        Expanded(
          child: TextField(
            controller: _messageControllers[shopId],
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
    );
  }

  Widget buildShopTotalSection(double shopTotal, double discount, double shopDeliveryCost) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tổng tiền hàng: ${NumberFormat("#,###", "vi_VN").format(shopTotal)}đ'),
          if (discount > 0)
            Text('Giảm giá: -${NumberFormat("#,###", "vi_VN").format(discount)}đ',
                style: TextStyle(color: Colors.green)),
          Text('Phí vận chuyển: ${NumberFormat("#,###", "vi_VN").format(shopDeliveryCost)}đ'),
          Text(
              'Tổng sau giảm giá và phí vận chuyển: ${NumberFormat("#,###", "vi_VN").format(shopTotal - discount + shopDeliveryCost)}đ',
              style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget buildShopVoucherButton(String shopId, String shopName, double shopTotal) {
    return ElevatedButton(
      onPressed: () async {
        List<Voucher>? fetchedVouchers = await fetchVouchers(shopId);
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.black.withOpacity(0.7),
          builder: (BuildContext context) {
            return VoucherShop(
              shop: shopName,
              price: shopTotal,
              voucherList: fetchedVouchers ?? [],
              onVoucherSelected: (Voucher? userSelectedVoucher) {
                setState(() {
                  if (userSelectedVoucher != null) {
                    selectedVouchers[shopId] = userSelectedVoucher;
                    print('Voucher selected for shop $shopId: ${userSelectedVoucher.voucherID}');
                  } else {
                    selectedVouchers.remove(shopId);
                    print('Voucher removed for shop $shopId');
                  }
                  calculateShopPrices();
                  calculateTotalOrderAmount();
                });
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
                selectedVouchers[shopId] != null
                    ? '-${NumberFormat("#,###", "vi_VN").format(shopTotal - (shopPricesAfterDiscount[shopId] ?? 0))}đ'
                    : 'Chọn hoặc nhập mã',
                style: TextStyle(
                  fontSize: 16,
                  color: selectedVouchers[shopId] != null ? Colors.green : Colors.grey,
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
    );
  }

  Widget buildAdminVoucherButton() {
    return ElevatedButton(
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
                setState(() {
                  AdminSelectedVoucher = userSelectedVoucher;
                  calculateTotalOrderAmount();
                });
                print('Selected Admin Voucher: ${userSelectedVoucher?.discount ?? "None"}%');
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
                AdminSelectedVoucher != null
                    ? '-${NumberFormat("#,###", "vi_VN").format(calculateAdminDiscount(totalShopAmount))}đ'
                    : 'Chọn hoặc nhập mã',
                style: TextStyle(
                  fontSize: 16,
                  color: AdminSelectedVoucher != null ? Colors.green : Colors.grey,
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
    );
  }

  Widget buildPaymentMethodSection() {
    return Column(
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
    );
  }

  Widget buildPaymentDetails() {
    double subtotal = shopPricesBeforeDiscount.values.reduce((a, b) => a + b);
    double totalShopDiscount = subtotal - shopPricesAfterDiscount.values.reduce((a, b) => a + b);
    double adminDiscount = calculateAdminDiscount(totalShopAmount);
    double totalVoucherDiscount = totalShopDiscount + adminDiscount;

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
          _buildDetailRow('Tổng tiền hàng', subtotal),
          _buildDetailRow('Tổng tiền phí vận chuyển', totalDeliveryCost),
          _buildDetailRow('Shop voucher', -totalShopDiscount, isDiscount: true),
          _buildDetailRow('TTL Voucher', -adminDiscount, isDiscount: true),
          _buildDetailRow('Tổng cộng Voucher giảm giá', -totalVoucherDiscount, isDiscount: true),
          Divider(height: 24),
          _buildDetailRow(
            'Tổng thanh toán',
            subtotal + totalDeliveryCost - totalShopDiscount - adminDiscount,
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