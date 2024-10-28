import 'package:ecommercettl/models/ShopModel.dart';
import 'package:ecommercettl/models/VoucherModel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VoucherShop extends StatefulWidget {
  final ShopModel shop;
  final List<Voucher> voucherList;

  const VoucherShop({super.key, required this.shop, required this.voucherList});

  @override
  State<VoucherShop> createState() => _VoucherShopState();
}

class _VoucherShopState extends State<VoucherShop> {
  // State variable to track the selected voucher index
  int selectedVoucherIndex = -1; // -1 indicates no voucher selected

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.6, // Set height to 60% of the screen
          padding: EdgeInsets.all(16.0),
          color: Colors.white,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.shop.shopName,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.cancel),
                  ),
                ],
              ),
              Divider(),
              SizedBox(height: 20), // Optional spacing
              // Build the voucher items
              Expanded(
                child: ListView.builder(
                  itemCount: widget.voucherList.length,
                  itemBuilder: (context, index) {
                    var voucher = widget.voucherList[index];
                    return _buildVoucherItem(
                      voucher.discount,
                      voucher.condition,
                      voucher.maxDiscount,
                      voucher.endDate,
                      index, // Pass index to identify which checkbox is checked
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVoucherItem(int discount, double condition, double maxDiscount, DateTime endDate, int index) {
    return Container(
      color: Colors.white,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Shadow color with opacity
            offset: Offset(0, 4), // Horizontal and vertical offset
            blurRadius: 8.0, // Blur radius
            spreadRadius: 2.0, // Spread radius
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            'images/logo-cus.png',
            height: 80,
            width: 80,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 10), // Space between image and text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align text to start
              children: [
                Text(
                  'Giảm đ${discount}%',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Đơn tối thiểu đ${NumberFormat("#,###", "vi_VN").format(condition)}k',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'HSD: ${DateFormat('dd/MM/yyyy').format(endDate)}', // Format the end date
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Checkbox(
            value: selectedVoucherIndex == index, // Check if the current index is selected
            onChanged: (value) {
              setState(() {
                // If the checkbox is selected, update the selected voucher index
                selectedVoucherIndex = value! ? index : -1; // Set to -1 if unchecked
              });
            },
          ),
        ],
      ),
    );
  }
}
