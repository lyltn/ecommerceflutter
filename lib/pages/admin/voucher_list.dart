import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommercettl/services/voucher_service.dart';
import 'package:flutter/material.dart';

class VoucherManagementScreen extends StatefulWidget {
  @override
  _VoucherManagementScreenState createState() => _VoucherManagementScreenState();
}

class _VoucherManagementScreenState extends State<VoucherManagementScreen> {
  @override
  Widget build(BuildContext context) {
    final VoucherService voucherService = VoucherService();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 2,
                offset: Offset(0, 2), // changes position of shadow
              ),
            ],
          ),
          child: AppBar(
            title: Text(
              'QUẢN LÝ VOUCHER',
              style: TextStyle(color: Colors.black),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 1,
            leading: IconButton(
              icon: Icon(Icons.menu, color: Colors.black),
              onPressed: () {

              },
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.notifications, color: Colors.black),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    _showAddVoucherDialog(context);
                  },
                  label: Text(
                    'Thêm voucher',
                    style: TextStyle(
                      color: Colors.green,
                      fontFamily: 'Roboto',
                      fontSize: 16.0,
                    ),
                  ),
                  icon: Icon(Icons.add, color: Colors.green),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.green),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: voucherService.getVouchersStream(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Something went wrong: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No data available'));
                }

                List<DocumentSnapshot> voucherList = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: voucherList.length, // Số lượng hàng
                  itemBuilder: (context, index) {
                    DocumentSnapshot document = voucherList[index];
                    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                    return Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(data['userID'] ?? 'No ID'),
                                  SizedBox(width: 30),
                                  Text(data['voucherID']?.toString() ?? 'No Voucher Code'),
                                ],
                              ),
                              Row(
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      _showDetailDialog(context, data, document.id);
                                    },
                                    child: Text(
                                      "Xem chi tiết",
                                      style: TextStyle(color: Colors.grey, fontSize: 10),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      _showEditDialog(context, data, document.id); // Mở dialog chỉnh sửa
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      _showDeleteConfirmationDialog(context, document.id);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Divider(thickness: 1, color: Colors.grey), // Dòng kẻ
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showDetailDialog(BuildContext context, Map<String, dynamic> data, String docId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Chi tiết Voucher'),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  // Edit action
                  Navigator.of(context).pop(); // Đóng dialog hiện tại
                  _showEditDialog(context, data, docId); // Mở dialog chỉnh sửa
                },
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8, // 80% chiều rộng màn hình
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Field')),
                  DataColumn(label: Text('Value')),
                ],
                rows: [
                  DataRow(cells: [
                    DataCell(Text('User ID')),
                    DataCell(Text(data['userID']?.toString() ?? 'No ID')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Voucher ID')),
                    DataCell(Text(data['voucherID']?.toString() ?? 'No Voucher Code')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Discount')),
                    DataCell(Text(data['discount']?.toString() ?? 'No Discount')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Condition')),
                    DataCell(Text(data['condition'] ?? 'No Condition')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Start Date')),
                    DataCell(Text(data['startDate']?.toDate().toString() ?? 'No Start Date')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('End Date')),
                    DataCell(Text(data['endDate']?.toDate().toString() ?? 'No End Date')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Max Discount')),
                    DataCell(Text(data['maxDiscount']?.toString() ?? 'No Max Discount')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Status')),
                    DataCell(Text(data['status']?.toString() ?? 'No Status')),
                  ]),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Đóng'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, Map<String, dynamic> data, String docId) {
    final VoucherService voucherService = VoucherService();

    // Controllers for form fields
    TextEditingController userIDController = TextEditingController(text: data['userID']?.toString());
    TextEditingController voucherIDController = TextEditingController(text: data['voucherID']?.toString());
    TextEditingController discountController = TextEditingController(text: data['discount']?.toString());
    TextEditingController conditionController = TextEditingController(text: data['condition']);
    TextEditingController startDateController = TextEditingController(text: data['startDate']?.toDate().toString());
    TextEditingController endDateController = TextEditingController(text: data['endDate']?.toDate().toString());
    TextEditingController maxDiscountController = TextEditingController(text: data['maxDiscount']?.toString());
    TextEditingController statusController = TextEditingController(text: data['status']?.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Chỉnh sửa Voucher'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: userIDController,
                  decoration: InputDecoration(labelText: 'User ID'),
                ),
                TextFormField(
                  controller: voucherIDController,
                  decoration: InputDecoration(labelText: 'Voucher ID'),
                ),
                TextFormField(
                  controller: discountController,
                  decoration: InputDecoration(labelText: 'Discount'),
                ),
                TextFormField(
                  controller: conditionController,
                  decoration: InputDecoration(labelText: 'Condition'),
                ),
                TextFormField(
                  controller: startDateController,
                  decoration: InputDecoration(labelText: 'Start Date'),
                ),
                TextFormField(
                  controller: endDateController,
                  decoration: InputDecoration(labelText: 'End Date'),
                ),
                TextFormField(
                  controller: maxDiscountController,
                  decoration: InputDecoration(labelText: 'Max Discount'),
                ),
                TextFormField(
                  controller: statusController,
                  decoration: InputDecoration(labelText: 'Status'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Lưu'),
              onPressed: () async {
                // Save action
                await voucherService.updateVoucher(
                  docId,
                  int.parse(voucherIDController.text),
                  int.parse(discountController.text),
                  double.parse(conditionController.text),
                  DateTime.parse(startDateController.text),
                  DateTime.parse(endDateController.text),
                  double.parse(maxDiscountController.text),
                  userIDController.text,
                  statusController.text.toLowerCase() == 'true',
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String docId) {
    final VoucherService voucherService = VoucherService();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác nhận xóa'),
          content: Text('Bạn có chắc chắn muốn xóa voucher này không?'),
          actions: <Widget>[
            TextButton(
              child: Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Xóa'),
              onPressed: () async {
                // Delete action
                await voucherService.deleteVoucher(docId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

void _showAddVoucherDialog(BuildContext context) {
  final VoucherService voucherService = VoucherService();

  // Controllers for form fields
  TextEditingController userIDController = TextEditingController();
  TextEditingController voucherIDController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController conditionController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController maxDiscountController = TextEditingController();
  TextEditingController statusController = TextEditingController();

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      controller.text = picked.toIso8601String();
    }
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Thêm Voucher'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: userIDController,
                decoration: InputDecoration(labelText: 'User ID'),
              ),
              TextFormField(
                controller: voucherIDController,
                decoration: InputDecoration(labelText: 'Voucher ID'),
              ),
              TextFormField(
                controller: discountController,
                decoration: InputDecoration(labelText: 'Discount'),
              ),
              TextFormField(
                controller: conditionController,
                decoration: InputDecoration(labelText: 'Condition'),
              ),
              TextFormField(
                controller: startDateController,
                decoration: InputDecoration(
                  labelText: 'Start Date',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () {
                      _selectDate(context, startDateController);
                    },
                  ),
                ),
              ),
              TextFormField(
                controller: endDateController,
                decoration: InputDecoration(
                  labelText: 'End Date',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () {
                      _selectDate(context, endDateController);
                    },
                  ),
                ),
              ),
              TextFormField(
                controller: maxDiscountController,
                decoration: InputDecoration(labelText: 'Max Discount'),
              ),
              TextFormField(
                controller: statusController,
                decoration: InputDecoration(labelText: 'Status'),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Hủy'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Lưu'),
            onPressed: () async {
              // Save action
              await voucherService.addVoucher(
                '',
                int.parse(voucherIDController.text),
                int.parse(discountController.text),
                double.parse(conditionController.text),
                DateTime.parse(startDateController.text),
                DateTime.parse(endDateController.text),
                double.parse(maxDiscountController.text),
                userIDController.text,
                statusController.text.toLowerCase() == 'true',
              );
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
