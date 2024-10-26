import 'package:ecommercettl/main.dart';
import 'package:ecommercettl/models/adminModel.dart';
import 'package:ecommercettl/pages/admin/adminhome.dart';
import 'package:ecommercettl/pages/admin/update_profile.dart';
import 'package:ecommercettl/pages/authen/auth_page.dart';
import 'package:ecommercettl/services/auth_service.dart';
import 'package:ecommercettl/services/shop_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LeftNavigation extends StatefulWidget {
  const LeftNavigation({super.key});

  @override
  _LeftNavigationState createState() => _LeftNavigationState();
}

class _LeftNavigationState extends State<LeftNavigation> {
  String? uid;
  late AuthService auth;
  AdminModel? adminModel;

  @override
  void initState() {
    super.initState();
    auth = AuthService();
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
      adminModel =
          (await auth.getadminProfile(FirebaseAuth.instance.currentUser!.uid));
      setState(() {}); // Update the UI once the data is fetched
    } catch (e) {
      print('Error fetching user profile: $e');
    }
  }

  // load data when navigating to the update profile page
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
    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            GestureDetector(
              onTap: () {
                navigation();
              },
              child: UserAccountsDrawerHeader(
                accountName: Row(
                  children: [
                    Text(
                      adminModel?.username ?? 'Guest',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Icon(
                      Icons.edit,
                      color: Colors.green,
                      size: 16,
                    ),
                  ],
                ),
                accountEmail: Text(
                  adminModel?.email ?? '',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: adminModel?.imgAvatar != null
                      ? NetworkImage(adminModel!.imgAvatar)
                      : const AssetImage('images/imageProduct.png')
                          as ImageProvider,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home_rounded),
              title: const Text('Trang chủ'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminHome()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Quản lý người dùng'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.card_giftcard),
              title: const Text('Quản lý voucher'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.article),
              title: const Text('Quản lý bài đăng'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text('Đăng xuất'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AuthPage()),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
