import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommercettl/pages/admin/AddVoucherForm.dart';
import 'package:ecommercettl/pages/admin/EditVoucherForm.dart';
import 'package:ecommercettl/pages/admin/VoucherDetailForm.dart';
import 'package:ecommercettl/pages/client/shopbottomnav.dart';
import 'package:ecommercettl/services/shop_service.dart';
import 'package:ecommercettl/services/voucher_service.dart';
import 'package:ecommercettl/widget/widget_support.dart';
import 'package:flutter/material.dart';

class VoucherManagementScreen extends StatefulWidget {
  const VoucherManagementScreen({super.key});

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
      appBar: AppBar(
        title: Text('Danh sách voucher', style: AppWiget.boldTextFeildStyle()),
      ),
      body: Padding(
        padding:
            const EdgeInsets.all(20.0), // Adjusted padding for better layout
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Row(
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
                      MaterialPageRoute(builder: (context) => BottomnavShop()),
                    );
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF15A362),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(Icons.home_outlined, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => AddVoucherForm()),
                      );
                    },
                    label: Text(
                      'Thêm voucher',
                      style: TextStyle(
                          color: Colors.green,
                          fontFamily: 'Roboto',
                          fontSize: 16.0),
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
              child: uid == null
                  ? Center(child: CircularProgressIndicator())
                  : StreamBuilder<QuerySnapshot>(
                      stream: voucherService.getVouchersByUserID(uid!),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                              child: Text(
                                  'Something went wrong: ${snapshot.error}'));
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Center(child: Text('No data available'));
                        }

                        List<DocumentSnapshot> voucherList =
                            snapshot.data!.docs;

                        return ListView.builder(
                          itemCount: voucherList.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot document = voucherList[index];
                            Map<String, dynamic> data =
                                document.data() as Map<String, dynamic>;

                            return Column(
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(width: 20),
                                          SizedBox(
                                            width: 40,
                                            height: 40,
                                            child: Image.asset(
                                              'images/logo-cus.png', // Ensure this path is correct
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            data['voucherCode']?.toString() ??
                                                'No Voucher Code',
                                            style: TextStyle(fontSize: 16),
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
                                                  color: Colors.grey,
                                                  fontSize: 10),
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.edit),
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditVoucherForm(
                                                          data: data,
                                                          docId: document.id),
                                                ),
                                              );
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.delete,
                                                color: Colors.red),
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
                                const Divider(thickness: 1, color: Colors.grey),
                              ],
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
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
