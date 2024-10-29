import 'dart:math';

import 'package:ecommercettl/models/Product.dart';
import 'package:ecommercettl/models/ShopModel.dart';
import 'package:ecommercettl/models/UserModel.dart';
import 'package:ecommercettl/models/VoucherModel.dart';
import 'package:ecommercettl/pages/customer/component/AdminVoucher.dart';
import 'package:ecommercettl/pages/customer/component/shopVoucher.dart';
import 'package:ecommercettl/services/customer_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class CheckoutScreen extends StatefulWidget {
  final ShopModel shopinf;
  final Product product;
  final UserModel customer;
  final String? color;
  final String? size;
  final int quantity;

  const CheckoutScreen({
    Key? key,
    required this.shopinf,
    required this.product,
    required this.customer,
    required this.color,
    required this.size,
    required this.quantity,
  }) : super(key: key);

  @override
  State<CheckoutScreen> createState() => CheckoutScreenState();
}

class CheckoutScreenState extends State<CheckoutScreen> {
  double selectedShopVoucher = 0;
  double selectedAdminVoucher = 0;
  double deliveryCost = 0;
  CustomerService customerService = CustomerService();
  List<Voucher> voucherList = [];
  List<Voucher> adminVoucher = [];
  final TextEditingController _messageController = TextEditingController();
  String message = "";
  Voucher? selectedVoucher;
  Voucher? AdminSelectedVoucher;

  @override
  void initState() {
    super.initState();
    fetchVouchers(); // Fetch vouchers when the screen is initialized
    fetchAdminVouchers();
    calculateDeliveryCost();
  }

  Future<void> fetchVouchers() async {
    try {
      voucherList = await customerService.fetchVouchersByShopId(widget.shopinf.shopid);
      print(voucherList);
      setState(() {}); // Refresh the UI
      print("shopid: ${widget.shopinf.shopid}");
      print("shopName: ${widget.shopinf.shopName}");
    } catch (error) {
      print("Error fetching vouchers: $error");
      // Optionally handle errors (e.g., show a Snackbar)
    }
  }
  Future<void> calculateDeliveryCost() async {
    double totalProductPrice = widget.product.price * widget.quantity;
    
    setState(() {
      if (totalProductPrice > 1500000) {
        deliveryCost = 0;
      } else if (totalProductPrice > 690000) {
        deliveryCost = 15000;
      } else if (totalProductPrice > 300000) {
        deliveryCost = 25000;
      } else {
        deliveryCost = 33000;
      }
    });
  }
  Future<void> fetchAdminVouchers() async {
    try {
      adminVoucher = await customerService.fetchVouchersByADmin();
      print(adminVoucher);
      setState(() {}); // Refresh the UI
    } catch (error) {
      print("Error fetching vouchers: $error");
      // Optionally handle errors (e.g., show a Snackbar)
    }
  }
  @override
  void dispose() {
    _messageController.dispose(); // Dọn dẹp controller khi không sử dụng
    super.dispose();
  }

  double calculateShopDiscount() {
    double totalProductPrice = widget.product.price * widget.quantity;

    if (selectedVoucher != null && totalProductPrice > selectedVoucher!.condition) {
      double discount = (totalProductPrice * selectedVoucher!.discount / 100)
          .clamp(0, selectedVoucher!.maxDiscount);
      return discount;
    }
    return 0;
  }

  double calculateAdminDiscount() {
    double totalProductPrice = widget.product.price * widget.quantity;

    if (AdminSelectedVoucher != null && totalProductPrice > AdminSelectedVoucher!.condition) {
      double discount = (totalProductPrice * AdminSelectedVoucher!.discount / 100)
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

  @override
  Widget build(BuildContext context) {
    
    double shopDiscount = calculateShopDiscount();
    double adminDiscount = calculateAdminDiscount();
    double totalDiscount = shopDiscount + adminDiscount;
    double firstPrice = (widget.product.price * widget.quantity) - shopDiscount;
    double totalPrice = (widget.product.price * widget.quantity) - totalDiscount;
    

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Thanh toán'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
          color: Colors.red,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Delivery Address
                const Text(
                  'Địa chỉ nhận hàng',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    backgroundColor: Colors.white,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${widget.customer.fullName} | ${widget.customer.phone}\n${widget.customer.address}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.chevron_right),
                    ),
                  ],
                ),
                Divider(),

                // Shop Information
                Row(
                  children: [
                    Icon(
                      Icons.storefront_outlined,
                      size: 30,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '${widget.shopinf.shopName}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // Product Information
                ListTile(
                  leading: Image.network
                  (
                    widget.product.imageUrls[0],
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                  title: Text(
                    widget.product.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Phân loại: ${widget.color ?? "Không có"} | Size: ${widget.size ?? "Không có"}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        'đ ${NumberFormat("#,###", "vi_VN").format(widget.product.price)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                  trailing: Text(
                    'x${widget.quantity}',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                Divider(),

                // Voucher Section
                ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.black.withOpacity(0.7),
                      builder: (BuildContext context) {
                        return VoucherShop(
                          shop: widget.shopinf,
                          voucherList: voucherList,
                          onVoucherSelected: (Voucher? UserSelectedVoucher) {
                            if (UserSelectedVoucher != null) {
                              selectedVoucher = UserSelectedVoucher;
                              selectedShopVoucher = calculateShopDiscount();
                              print('Selected Voucher: ${UserSelectedVoucher.discount}%');
                            } else {
                              print('No voucher selected');
                            }

                            Navigator.pop(context);
                            setState(() {}); // Refresh UI after selecting a voucher
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
                            selectedVoucher != null
                                ? '-${NumberFormat("#,###", "vi_VN").format(shopDiscount)}đ'
                                : 'Chọn hoặc nhập mã',
                            style: TextStyle(
                              fontSize: 16,
                              color: selectedVoucher != null ? Colors.green : Colors.grey,
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

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Lời nhắn cho Shop',
                      style: TextStyle(fontSize: 18), // Adjust the font size here
                    ),
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Để lại lời nhắn',
                          border: InputBorder.none, // No border
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0), // Adjust horizontal padding
                        ),
                        textAlign: TextAlign.right, // Align text to the right
                        style: TextStyle(fontSize: 16), // Adjust text size
                      ),
                    ),
                  ],
                ),
                Divider(),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tổng số tiền (1 sản phẩm)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500
                      ),
                      ),
                    Text(
                      '${NumberFormat("#,###", "vi_VN").format(firstPrice)} đ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.red.shade800,
                      )
                    ),
                  ],
                ),
                Divider(),

                ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.black.withOpacity(0.7),
                      builder: (BuildContext context) {
                        return AdminVoucher(
                          voucherList: adminVoucher,
                          onVoucherSelected: (Voucher? UserSelectedVoucher) {
                            if (UserSelectedVoucher != null) {
                              AdminSelectedVoucher = UserSelectedVoucher;
                              selectedAdminVoucher = calculateAdminDiscount();
                              print('Selected Voucher: ${UserSelectedVoucher.discount}%');
                            } else {
                              print('No voucher selected');
                            }

                            Navigator.pop(context);
                            setState(() {}); // Refresh UI after selecting a voucher
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
                            'TTL Voucher',
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
                                ? '-${NumberFormat("#,###", "vi_VN").format(adminDiscount)}đ'
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
                ),
                Divider(),

                Text('Phương thức thanh toán'),
                Text('Thanh toán khi nhận hàng'),
                Divider(),

                // Order Details
                Column(
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.receipt_long_rounded,
                          color: Colors.orange,
                          size: 30,
                          ),
                        SizedBox(width: 10,),
                        Text(
                          'Chi tiết thanh toán',
                          style: TextStyle(
                            fontSize: 18
                          ),
                        ),
                        SizedBox(height: 30,),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tổng tiền hàng'
                        ),
                        Spacer(),
                        Text('đ${NumberFormat("#,###", "vi_VN").format(widget.product.price * widget.quantity)}'),
                        SizedBox(height: 30,)
                      ],
                    ),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tổng tiền phí vận chuyển'
                        ),
                        Spacer(),
                        Text('đ${NumberFormat("#,###", "vi_VN").format(deliveryCost)}'),
                        SizedBox(height: 30,)
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Shop voucher'
                        ),
                        Spacer(),
                        Text('-đ${NumberFormat("#,###", "vi_VN").format(shopDiscount)}'),
                        SizedBox(height: 30,)
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'TTL Voucher'
                        ),
                        Spacer(),
                        Text('-đ${NumberFormat("#,###", "vi_VN").format(adminDiscount)}'),
                        SizedBox(height: 30,)
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tổng cộng Voucher giảm giá'
                        ),
                        Spacer(),
                        Text('-đ${NumberFormat("#,###", "vi_VN").format(adminDiscount+shopDiscount)}'),
                        SizedBox(height: 30,)
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Tổng thanh toán'),
                        Spacer(),
                        Text('đ${NumberFormat("#,###", "vi_VN").format(totalPrice)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.red.shade700
                            ),
                        ),
                        SizedBox(height: 30,)
                      ],
                    ),
                  ],
                ),
                Divider(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16.0),
        child: ElevatedButton(
          child: Text('Đặt hàng'),
          onPressed: () {
            String orderCode = generateRandomString(10);
            DateTime orderDate = DateTime.now();
            String? shopVoucher = selectedVoucher?.voucherID;
            String? adminVoucher = AdminSelectedVoucher?.voucherID;
            double total = totalPrice;
            String cusId = widget.customer.id;
            String name = widget.customer.fullName;
            String phone = widget.customer.phone;
            String address = widget.customer.address;
            String status = "Đang đợi xét duyệt";
            
            CustomerService customerService = CustomerService();

            customerService.addOrder(
              orderCode, 
              orderDate, 
              shopVoucher ?? "", 
              adminVoucher ?? "", 
              total, 
              cusId, 
              name,
              phone, 
              address, 
              status
              );
            
            customerService.addOrderDetails(
              orderCode, 
              widget.customer.id, 
              widget.size ?? "", 
              widget.color ?? "",
              widget.quantity,
              ).then((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Order created successfully!')),
                );
                Navigator.pop(context);
              }).catchError((error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to create order: $error')),
                );
              });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            minimumSize: Size(double.infinity, 50),
          ),
        ),
      ),
    );
  }
}
