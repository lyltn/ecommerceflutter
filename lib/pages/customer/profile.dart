import 'package:ecommercettl/models/UserModel.dart';
import 'package:ecommercettl/pages/authen/auth_page.dart';
import 'package:ecommercettl/pages/authen/register_shop.dart';
import 'package:ecommercettl/pages/client/shopbottomnav.dart';
import 'package:ecommercettl/pages/customer/chatbot.dart';
import 'package:ecommercettl/pages/customer/update_profile.dart';
import 'package:ecommercettl/services/auth_service.dart';
import 'package:ecommercettl/services/shop_service.dart';
import 'package:ecommercettl/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // Call this method to retrieve and store the userId asynchronously

  String? uid;
  late AuthService auth = AuthService();
  UserModel? userModel; // Change to nullable

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    getCurrentUserId();
  }

  Future<void> getCurrentUserId() async {
    uid = await ShopService.getCurrentUserId();
    if (uid != null) {
      print('User ID: $uid');
    } else {
      print('No user is signed in.');
    }
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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: userModel == null
          ? Center(child: CircularProgressIndicator())
          : _buildBody(context),
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
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildProfileInfo(context),
          _buildMenuItems(context),
          SizedBox(height: 20), // Add space before the logout button
          _buildLogoutButton(context),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildProfileInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              navigation();
            },
            child: CircleAvatar(
              radius: 30,
              backgroundImage: userModel!.imgAvatar != null
                  ? NetworkImage(userModel!.imgAvatar)
                  : AssetImage('assets/default_avatar.png') as ImageProvider,
            ),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    userModel!.fullName ?? 'Guest',
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
                userModel!.email ?? '',
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
        _buildMenuItem(Icons.support_agent_outlined, 'Hỗ trợ người dùng', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CustomerChatbotPage()),
          );
        }),
        _buildMenuItem(Icons.store_mall_directory_outlined, 'Đăng kí shop', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegisterShopPage()),
          );
        }),
        _buildMenuItem(
          Icons.store_mall_directory_outlined,
          'chuyển sang shop',
          () {
            getCurrentUserId();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BottomnavShop()),
            );
          },
        ),
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
