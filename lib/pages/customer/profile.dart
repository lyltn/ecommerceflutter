import 'package:ecommercettl/models/CartModel.dart';
import 'package:ecommercettl/models/UserModel.dart';
import 'package:ecommercettl/pages/authen/auth_page.dart';
import 'package:ecommercettl/pages/authen/register_shop.dart';
import 'package:ecommercettl/pages/client/shopbottomnav.dart';
import 'package:ecommercettl/pages/customer/CartPage.dart';
import 'package:ecommercettl/pages/customer/chatbot.dart';
import 'package:ecommercettl/pages/customer/settings.dart';
import 'package:ecommercettl/pages/customer/update_profile.dart';
import 'package:ecommercettl/services/auth_service.dart';
import 'package:ecommercettl/services/customer_service.dart';
import 'package:ecommercettl/services/shop_service.dart';
import 'package:ecommercettl/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // Call this method to retrieve and store the userId asynchronously
  String? uid;
  late AuthService auth = AuthService();
  UserModel? userModel; 
  List<Cart>? cartList;


  @override
  void initState() {
    super.initState();
    getCurrentUserId();
    _loadUserProfile();
    
  }


  Future<void> getCurrentUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    CustomerService customerService = CustomerService();
    uid = prefs.getString('cusId');
    if (uid != null) {
      print('Cus ID profile: $uid');
      userModel = await customerService.getCustomerInfo(uid!);
      await fetchCart(uid!);
    } else {
      print('No user is signed in.');
    }
  }

  
  Future<void> fetchCart(String cusId) async {
    CustomerService customerService = CustomerService();
    if (cusId != null) {
      try {
        // Fetch the cart list based on the user's ID (uid)
        cartList = await customerService.fetchCartListByCusId(uid!);
        for (var item in cartList!) {
          print("cart number check  : ${item.shopId}, Size: ${item.color}, Price: ${item.size}, Userid:${item.cusId}");
        }

        print("Cart items fetched successfully: ${cartList!.length}");
      } catch (e) {
        print("Error fetching cart items: $e");
      }
    } else {
      print("User ID is null. Cannot fetch cart.");
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
        }),
        _buildMenuItem(Icons.account_balance_wallet_outlined, 'Ví của tôi', () {
          // Handle navigation to "Ví của tôi"
        }),
        _buildMenuItem(Icons.settings_outlined, 'Cài đặt', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Settings()),
          );
        }),
        _buildMenuItem(Icons.shopping_cart_outlined, 'Giỏ hàng', () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CartPage(cartList: cartList!, customer: userModel!,)),
          );
        }),
        _buildMenuItem(Icons.support_agent_outlined, 'Hỗ trợ người dùng', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CustomerChatbotPage()),
          );
        }),
        if (userModel?.role == 'CUSTOMER')
          _buildMenuItem(Icons.store_mall_directory_outlined, 'Đăng kí shop',
              () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegisterShopPage()),
            );
          }),
        if (userModel?.role != 'CUSTOMER')
          _buildMenuItem(
            Icons.store_mall_directory_outlined,
            'Chuyển sang shop',
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
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.remove('cusId');
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
