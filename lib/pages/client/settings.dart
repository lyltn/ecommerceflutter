import 'package:ecommercettl/models/UserModel.dart';
import 'package:ecommercettl/pages/authen/auth_page.dart';
import 'package:ecommercettl/pages/customer/update_profile.dart';
import 'package:ecommercettl/services/auth_service.dart';
import 'package:ecommercettl/services/shop_service.dart';
import 'package:ecommercettl/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsShop extends StatefulWidget {
  const SettingsShop({Key? key}) : super(key: key);

  @override
  State<SettingsShop> createState() => _SettingsShopState();
}

class _SettingsShopState extends State<SettingsShop> {
  bool isPushNotificationsEnabled = false;
  bool isDarkModeEnabled = false;

  String? uid;
  late AuthService auth = AuthService();
  UserModel? userModel; // Change to nullable

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      userModel =
          await auth.getUserProfile(FirebaseAuth.instance.currentUser!.uid);
      setState(() {}); // Update the UI once the data is fetched
    } catch (e) {
      print('Error fetching user profile: $e');
    }
  }

  // load data khi sang trang
  Future<void> navigation() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UpdateProfilePage()),
    ).then((_) {
      _loadUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SettingsShop',
          style: TextStyle(
            color: Colors.white, // Màu chữ trắng
            fontSize: 24, // Tăng kích thước chữ
            fontWeight: FontWeight.bold, // Đậm chữ (tuỳ chọn)
          ),
        ),
        backgroundColor: Colors.green,
        leading: const Icon(
          Icons.settings,
          color: Colors.white, // Màu biểu tượng trắng
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cài đặt tài khoản',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Đóng tài khoản'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                _showDeleteConfirmationDialog();
              },
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Sửa thông tin tài khoản'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                navigation();
              },
            ),
            ListTile(
              title: const Text('Thay đổi mật khẩu'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
            SwitchListTile(
              title: const Text('Chế độ tối'),
              value: isDarkModeEnabled,
              onChanged: (value) {
                setState(() {
                  isDarkModeEnabled = value;
                });
              },
            ),
            const SizedBox(height: 32),
            const Text(
              'More',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('About us'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Privacy policy'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Terms and conditions'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog() {
    final ShopService shopService = ShopService();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác nhận xóa'),
          content: Text('Bạn có chắc chắn muốn đóng tài khoản này không?'),
          actions: <Widget>[
            TextButton(
              child: Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Đóng'),
              onPressed: () async {
                // Delete action
                await shopService.deleteUserAndProducts(
                    FirebaseAuth.instance.currentUser!.uid);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AuthPage(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
