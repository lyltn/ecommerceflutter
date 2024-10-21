import 'package:flutter/material.dart';
import 'login.dart'; // Import trang đăng nhập
import 'register.dart'; // Import trang đăng ký

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _isLogin = true; // Trạng thái để kiểm tra đang ở trang đăng nhập hay đăng ký

  void _toggleAuthMode() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: <Widget>[
                    Image.asset(
                      'images/logo-admin.png', // Đường dẫn tới hình ảnh
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(width: 10), // Khoảng cách giữa logo và text
                    Text(
                      'TTL',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                
                // Thêm Text "Đăng nhập" hoặc "Đăng ký" ở đây
                Center(
                  child: Text(
                    _isLogin ? 'Đăng nhập' : 'Đăng ký',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20), // Khoảng cách giữa tiêu đề và form

                // Hiển thị trang đăng nhập hoặc đăng ký
                _isLogin ? LoginPage() : RegisterPage(),

                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_isLogin ? 'Bạn chưa có tài khoản?' : 'Bạn đã có tài khoản?'),
                    TextButton(
                      onPressed: _toggleAuthMode,
                      child: Text(_isLogin ? 'Đăng ký' : 'Đăng nhập'),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Center(
                  child: SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}