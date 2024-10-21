import 'package:flutter/material.dart';

class Post extends StatefulWidget {
  const Post({super.key});

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  @override
  Widget build(BuildContext context) {
  return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // hides back button
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 20,
      ),
      body: Column(
        children: [
          // Profile Info
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/profile_picture.png'), // Replace with your image asset
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
                        )
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
          ),

          // Menu Items
          ListTile(
            leading: Icon(Icons.shopping_bag_outlined),
            title: Text('Đơn hàng của tôi'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Handle navigation to "Đơn hàng của tôi"
            },
          ),
          ListTile(
            leading: Icon(Icons.account_balance_wallet_outlined),
            title: Text('Ví của tôi'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Handle navigation to "Ví của tôi"
            },
          ),
          ListTile(
            leading: Icon(Icons.settings_outlined),
            title: Text('Cài đặt'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Handle navigation to "Cài đặt"
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart_outlined),
            title: Text('Giỏ hàng'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Handle navigation to "Giỏ hàng"
            },
          ),

          Spacer(),

          // Log Out Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                // Handle log out
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
          ),
          SizedBox(height: 20),
        ],
      ),
      // BottomNavigationBar component
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 4, // Set this to the profile tab index
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.delivery_dining),
            label: 'Delivery',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
      ),
    );
  }
}
