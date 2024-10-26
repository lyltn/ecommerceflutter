import 'package:ecommercettl/pages/authen/auth_page.dart';
import 'package:ecommercettl/pages/customer/bottomnav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileShop extends StatefulWidget {
  const ProfileShop({super.key});

  @override
  State<ProfileShop> createState() => _ProfileShopState();
}

class _ProfileShopState extends State<ProfileShop> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
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

  Widget _buildBody() {
    return Column(
      children: [
        _buildProfileInfo(),
        _buildMenuItems(),
        Spacer(),
        _buildLogoutButton(),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildProfileInfo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage('images/dress.png'),
          ),
          SizedBox(width: 16),
          // Sử dụng Expanded để tránh tràn giao diện
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Nguyễn Văn A',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow
                            .ellipsis, // Ngăn tràn bằng cách cắt chữ
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
                  overflow: TextOverflow.ellipsis, // Ngăn tràn email
                ),
                SizedBox(height: 4),
                Text(
                  'Ngày tham gia: 01/01/2024',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  overflow: TextOverflow.ellipsis, // Ngăn tràn ngày tham gia
                ),
                SizedBox(height: 4),
                Text(
                  'Địa chỉ: 123 Đường ABC, Thành phố XYZ',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  overflow: TextOverflow.ellipsis, // Ngăn tràn địa chỉ
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems() {
    return Column(
      children: [
        _buildMenuItem(Icons.card_giftcard, 'Voucher shop', () {
          // Handle navigation to "Voucher shop"
        }),
        _buildMenuItem(Icons.account_balance_wallet_outlined, 'Ví của tôi', () {
          // Handle navigation to "Ví của tôi"
        }),
        _buildMenuItem(Icons.settings_outlined, 'Cài đặt', () {
          // Handle navigation to "Cài đặt"
        }),
        _buildMenuItem(Icons.switch_account, 'Chuyển tư cách người dùng', () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => BottomNav()));
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

  Widget _buildLogoutButton() {
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
