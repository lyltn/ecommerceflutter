import 'package:ecommercettl/models/ShopModel.dart';
import 'package:ecommercettl/models/VoucherModel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminVoucher extends StatefulWidget {
  final List<Voucher> voucherList;
  final Function(Voucher?) onVoucherSelected;

  const AdminVoucher({
    Key? key,
    required this.voucherList,
    required this.onVoucherSelected,
  }) : super(key: key);

  @override
  State<AdminVoucher> createState() => _AdminVoucherState();
}

class _AdminVoucherState extends State<AdminVoucher> {
  int selectedVoucherIndex = -1; // -1 indicates no voucher selected

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.6,
          padding: EdgeInsets.all(16.0),
          color: Colors.white,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Chọn TTL Voucher',
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
              SizedBox(height: 20),
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
                      index,
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (selectedVoucherIndex != -1) {
                    widget.onVoucherSelected(widget.voucherList[selectedVoucherIndex]);
                  } else {
                    widget.onVoucherSelected(null); // No voucher selected
                  }
                },
                child: Text('Select Voucher'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVoucherItem(int discount, double condition, double maxDiscount, DateTime endDate, int index) {
    final currentDate = DateTime.now(); // Get the current date
    final isVoucherValid = currentDate.isBefore(endDate); // Check if the voucher is valid

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: Offset(0, 4),
            blurRadius: 8.0,
            spreadRadius: 2.0,
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Image.asset(
              'images/logo-cus.png',
              height: 50,
              width: 50,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
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
                  'HSD: ${DateFormat('dd/MM/yyyy').format(endDate)}',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: GestureDetector(
              onTap: () {
                if (isVoucherValid) {
                  setState(() {
                    selectedVoucherIndex = selectedVoucherIndex == index ? -1 : index; // Toggle selection
                  });
                } else {
                  // Show dialog for expired voucher
                  _showExpiredVoucherDialog();
                }
              },
              child: Checkbox(
                value: selectedVoucherIndex == index,
                onChanged: isVoucherValid ? (value) {
                  setState(() {
                    selectedVoucherIndex = value! ? index : -1; // Set to -1 if unchecked
                  });
                } : null, // Disable checkbox if expired
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showExpiredVoucherDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Voucher Expired'),
          content: Text('This voucher has expired.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
