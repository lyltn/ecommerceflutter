import 'package:ecommercettl/models/Product.dart';
import 'package:ecommercettl/models/ShopModel.dart';
import 'package:ecommercettl/models/UserModel.dart';
import 'package:ecommercettl/models/VoucherModel.dart';
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
  bool showShopVoucher = false;
  CustomerService customerService = CustomerService();
  List<Voucher> voucherList = [];

  @override
  void initState() {
    super.initState();
    fetchVouchers(); // Fetch vouchers when the screen is initialized
  }


  Future<void> fetchVouchers() async {
    voucherList = await customerService.fetchVouchersByShopId(widget.shopinf.shopid);
    setState(() {}); // Refresh the UI
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = widget.product.price * widget.quantity - selectedShopVoucher;

    return Scaffold(
      appBar: AppBar(
        title: Text('Thanh toán'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Delivery Address
              Text(
                'Địa chỉ nhận hàng',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${widget.customer.fullName} | ${widget.customer.phone}\n${widget.customer.address}',
                    style: TextStyle(
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
                leading: Image.network(widget.product.imageUrls[0]),
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
                    fontSize: 14
                  ),
                  ),
              ),
              Divider(),

              // Voucher Section
              ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true, // Allows us to control the height of the bottom sheet
                    backgroundColor: Colors.black.withOpacity(0.7), // Set the background color to translucent black
                    builder: (BuildContext context) {
                      return VoucherShop(
                        shop: widget.shopinf,
                        voucherList: voucherList,
                      ); // Call your VoucherShop widget here
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.zero,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero, // No rounded corners
                    side: BorderSide.none, // No border
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
                        SizedBox(width: 10,),
                        SizedBox(height: 40,),
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
                          selectedShopVoucher > 0
                              ? '-${NumberFormat("#,###", "vi_VN").format(selectedShopVoucher)}đ'
                              : 'Chọn hoặc nhập mã',
                          style: TextStyle(
                            fontSize: 16,
                            color: selectedShopVoucher > 0 ? Colors.green : Colors.grey,
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          size: 18,
                        )

                      ],
                    )
                  ],
                ),
              ),
              
              // Voucher List
              // FutureBuilder<List<Voucher>>(
              //   future: customerService.fetchVouchersByShopId(widget.shopinf.shopid),
              //   builder: (context, snapshot) {
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       return CircularProgressIndicator();
              //     } else if (snapshot.hasError) {
              //       return Text('Lỗi khi lấy voucher: ${snapshot.error}');
              //     } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              //       return Text('Không có voucher nào');
              //     } else {
              //       final vouchers = snapshot.data!;
              //       return Column(
              //         children: vouchers.map((voucher) {
              //           return ListTile(
              //             title: Text(voucher.VoucherCode),
              //             subtitle: Text('Giảm giá: ${voucher.discount}%'),
              //             onTap: () {
              //               setState(() {
              //                 selectedShopVoucher = (widget.product.price * voucher.discount / 100).clamp(0, voucher.maxDiscount);
              //               });
              //             },
              //           );
              //         }).toList(),
              //       );
              //     }
              //   },
              // ),

              // Order Summary
              Divider(),
              Text('Tổng số tiền (1 sản phẩm)'),
              Text('${NumberFormat("#,###", "vi_VN").format(totalPrice)} đ', style: TextStyle(fontWeight: FontWeight.bold)),
              Divider(),

              // Payment Method
              Text('Phương thức thanh toán'),
              Text('Thanh toán khi nhận hàng'),
              Divider(),

              // Order Details
              Text('Chi tiết thanh toán'),
              // Add more detailed breakdown here
              Divider(),
              Text('Tổng thanh toán'),
              Text('${NumberFormat("#,###", "vi_VN").format(totalPrice)} đ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16.0),
        child: ElevatedButton(
          child: Text('Mua hàng (1)'),
          onPressed: () {
            // Handle purchase
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
