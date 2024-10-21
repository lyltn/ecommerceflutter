import 'package:ecommercettl/pages/authen/auth_page.dart';
import 'package:ecommercettl/pages/authen/register_shop.dart';
import 'package:ecommercettl/pages/customer/update_profile.dart'; // Import trang cập nhật thông tin cá nhân
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 0,
      toolbarHeight: 20,
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        _buildProfileInfo(context),
        _buildMenuItems(context),
        Spacer(),
        _buildLogoutButton(context),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildProfileInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UpdateProfilePage()),
              );
            },
            child: CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('assets/images/kuta.png'),
            ),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Nguyễn Văn A',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 5),
                  Icon(
                    Icons.edit,
                    color: Colors.green,
                    size: 16,
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(
                'a@gmail.com',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    return Column(
      children: [
        _buildMenuItem(Icons.shopping_bag_outlined, 'Đơn hàng của tôi', () {
          // Handle navigation to "Đơn hàng của tôi"
        }),
        _buildMenuItem(Icons.account_balance_wallet_outlined, 'Ví của tôi', () {
          // Handle navigation to "Ví của tôi"
        }),
        _buildMenuItem(Icons.settings_outlined, 'Cài đặt', () {
          // Handle navigation to "Cài đặt"
        }),
        _buildMenuItem(Icons.shopping_cart_outlined, 'Giỏ hàng', () {
          // Handle navigation to "Giỏ hàng"
        }),
        _buildMenuItem(Icons.store_mall_directory_outlined, 'Đăng kí shop', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegisterShopPage()),
          );
        }),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ElevatedButton.icon(
        onPressed: () async {
          await FirebaseAuth.instance.signOut();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AuthPage()),
          );
        },
        icon: Icon(Icons.logout, color: Colors.green),
        label: Text('Log Out'),
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 50),
          backgroundColor: Colors.grey.shade200,
          foregroundColor: Colors.green,
          elevation: 0,
        ),
      ),
    );
  }
}