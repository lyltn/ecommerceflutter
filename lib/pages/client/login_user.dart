import 'package:flutter/material.dart';

class LoginUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                // Row for Logo at the top left corner
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      'images/logo-admin.png', // Make sure to have the logo image in the assets folder
                      height: 100, // Increased the height
                      width: 100,  // Increased the width
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // Title
                Text(
                  'Đăng nhập',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30),

                // Username field
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Tên tài khoản',
                    hintText: 'nhập username...',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),

                // Password field
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Mật Khẩu',
                    hintText: 'nhập mật khẩu...',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.visibility),
                  ),
                ),
                SizedBox(height: 10),

                // Remember me checkbox and forgot password
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value!;
                            });
                          },
                        ),
                        Text('Nhớ tôi'),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        // Forgot password action
                      },
                      child: Text('Quên mật khẩu'),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // Login button
                ElevatedButton(
                  onPressed: () {
                    // Login action
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 120.0),
                    child: Text('Đăng nhập', style: TextStyle(fontSize: 18)),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 30),

                // Social login buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Divider(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('Hoặc'),
                    ),
                    Expanded(
                      child: Divider(),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.account_circle, color: Colors.blue),
                      onPressed: () {
                        // Google login action
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.facebook, color: Colors.blueAccent),
                      onPressed: () {
                        // Facebook login action
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // Sign up link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Bạn chưa có tài khoản?'),
                    TextButton(
                      onPressed: () {
                        // Navigate to sign up page
                      },
                      child: Text('Đăng ký', style: TextStyle(color: Colors.green)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
