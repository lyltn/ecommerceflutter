import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommercettl/pages/admin/AddVoucherForm.dart';
import 'package:ecommercettl/pages/admin/EditVoucherForm.dart';
import 'package:ecommercettl/pages/admin/VoucherDetailForm.dart';
import 'package:ecommercettl/pages/admin/adminleftnav.dart';
import 'package:ecommercettl/services/shop_service.dart';
import 'package:ecommercettl/services/voucher_service.dart';
import 'package:flutter/material.dart';

class VoucherManagementScreen extends StatefulWidget {
  // final GlobalKey<ScaffoldState> scaffoldKey;

  VoucherManagementScreen({super.key});

  @override
  _VoucherManagementScreenState createState() =>
      _VoucherManagementScreenState();
}

class _VoucherManagementScreenState extends State<VoucherManagementScreen> {
  String? uid;

  @override
  void initState() {
    super.initState();
    _getCurrentUserId();
  }

  Future<void> _getCurrentUserId() async {
    uid = await ShopService.getCurrentUserId();
    print('User ID: $uid');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final VoucherService voucherService = VoucherService();

    return Scaffold(
      drawer: LeftNavigation(),
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
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AddVoucherForm(),
                      ),
                    );
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
              stream: voucherService.getVouchersByUserID(uid!),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                      child: Text('Something went wrong: ${snapshot.error}'));
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
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;

                    return Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  // Image logo
                                  SizedBox(width: 20),
                                  SizedBox(
                                    width: 40, // Adjust size as needed
                                    height: 40, // Adjust size as needed
                                    child: Image.asset(
                                      'images/logo-cus.png', // Replace with the correct path to your logo
                                      fit: BoxFit
                                          .cover, // Adjust the fit as necessary
                                    ),
                                  ),
                                  SizedBox(
                                      width:
                                          10), // Add some spacing between the logo and the text
                                  Text(
                                    data['voucherCode']?.toString() ??
                                        'No Voucher Code',
                                    style: TextStyle(
                                        fontSize:
                                            16), // You can adjust the text style as needed
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              VoucherDetailForm(
                                                  data: data,
                                                  docId: document.id),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "Xem chi tiết",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 10),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => EditVoucherForm(
                                              data: data, docId: document.id),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      _showDeleteConfirmationDialog(
                                          context, document.id);
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
