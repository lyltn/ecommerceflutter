import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommercettl/models/UserModel.dart';
import 'package:ecommercettl/pages/authen/auth_page.dart';
import 'package:ecommercettl/pages/client/voucher_list.dart';
import 'package:ecommercettl/pages/customer/bottomnav.dart';
import 'package:ecommercettl/pages/customer/update_profile.dart';
import 'package:ecommercettl/services/auth_service.dart';
import 'package:ecommercettl/services/shop_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileShop extends StatefulWidget {
  const ProfileShop({super.key});

  @override
  State<ProfileShop> createState() => _ProfileShopState();
}

class _ProfileShopState extends State<ProfileShop> {
  UserModel? userModel;
  String? uid;
  late AuthService auth = AuthService();

  Future<void> _loadUserProfile() async {
    try {
      userModel =
          await auth.getUserProfile(FirebaseAuth.instance.currentUser!.uid);
      setState(() {}); // Update the UI once the data is fetched
    } catch (e) {
      print('Error fetching user profile: $e');
    }
  }

  // Load data when navigating to the page
  Future<void> _navigateToUpdateProfile() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UpdateProfilePage()),
    );
    _loadUserProfile(); // Reload profile after returning from update page
  }

  @override
  void initState() {
    super.initState();
    _loadUserProfile();

    // Anonymous async function inside initState
    () async {
      uid = await ShopService.getCurrentUserId();
      print('User ID: $uid');
      setState(() {}); // Update UI if necessary
    }();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: userModel == null
          ? Center(child: CircularProgressIndicator())
          : _buildBody(),
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
          GestureDetector(
            onTap: () => _navigateToUpdateProfile(),
            child: CircleAvatar(
              radius: 30,
              backgroundImage: userModel?.imgAvatar != null
                  ? NetworkImage(userModel!.imgAvatar)
                  : AssetImage('assets/default_avatar.png') as ImageProvider,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('shopRequests')
                  .where('uid', isEqualTo: uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;
                if (docs.isEmpty) {
                  return Text("No shop requests found.");
                }

                var data = docs[0].data() as Map<String, dynamic>;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            data['shopName'] ?? 'Unknown Shop',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
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
                      data['e-mail'] ?? 'Unknown Email',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      data['submittedAt']?.toString() ?? 'Unknown Date',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      userModel!.address ?? 'Unknown Address',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                );
              },
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
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VoucherManagementScreen()));
        }),
        _buildMenuItem(Icons.account_balance_wallet_outlined, 'Ví TTL', () {
          // Handle navigation to "My Wallet"
        }),
        _buildMenuItem(Icons.settings_outlined, 'Cài đặt', () {
          // Handle navigation to "Settings"
        }),
        _buildMenuItem(Icons.switch_account, 'chuyển trang khách hàng', () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BottomNav()),
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
