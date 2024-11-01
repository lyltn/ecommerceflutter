import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommercettl/pages/admin/adminhome.dart';
import 'package:ecommercettl/pages/authen/forgot_pw.dart';
import 'package:ecommercettl/pages/client/shopbottomnav.dart';
import 'package:ecommercettl/pages/customer/bottomnav.dart';
import 'package:ecommercettl/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import trang chính

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _rememberMe = false;
  bool _isLoading = false; // Flag to indicate loading state
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscured = true; // Trạng thái để ẩn/hiện mật khẩu
  UserService _userService = UserService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Start loading
      });

      try {
        // Sign in with Firebase
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        SharedPreferences prefs = await SharedPreferences.getInstance();

        // Check user role after login
        String uid = userCredential.user!.uid;
        DocumentSnapshot userDoc =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();

        if (userDoc.exists) {
          String role = userDoc['role'];
          if (role == 'ADMIN') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AdminHome()),
            );
          } else if (role == 'CUSTOMER') {
            await prefs.setString('cusId', userCredential.user!.uid);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => BottomNav()),
            );
          } else if (role == 'USER') {
            await prefs.setString('shopId', uid);
            if (!mounted) return;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const BottomnavShop()),
            );
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Đăng nhập thành công")),
          );
        } else {
          // User document not found
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Lỗi khi lấy thông tin người dùng.")),
          );
        }
      } on FirebaseAuthException catch (e) {
        // Handle FirebaseAuth exceptions
        String errorMessage;
        if (e.code == 'user-not-found') {
          errorMessage = 'Không tìm thấy người dùng với email này.';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Sai mật khẩu.';
        } else {
          errorMessage = 'Đăng nhập thất bại. Vui lòng thử lại.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      } finally {
        setState(() {
          _isLoading = false; // Stop loading
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: _isLoading
          ? Center(
              child:
                  CircularProgressIndicator()) // Show loading indicator if _isLoading is true
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Hàng cho Email
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 10), // Khoảng cách dưới 10px
                  child: Text(
                    'Email',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, // In đậm
                      fontSize: 16, // Kích thước chữ
                    ),
                  ),
                ),
                // TextFormField cho Email
                Container(
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30), // Bo tròn 30px
                      ),
                      hintText: 'Nhập email...', // Placeholder
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập email';
                      }
                      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                      if (!emailRegex.hasMatch(value)) {
                        return 'Email không hợp lệ';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20), // Khoảng cách giữa 2 hàng

                // Hàng cho Mật khẩu
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 10), // Khoảng cách dưới 10px
                  child: Text(
                    'Mật khẩu',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, // In đậm
                      fontSize: 16, // Kích thước chữ
                    ),
                  ),
                ),
                // TextFormField cho Mật khẩu
                TextFormField(
                  controller: _passwordController,
                  obscureText: _isObscured, // Ẩn ký tự khi nhập
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30), // Bo tròn 30px
                    ),
                    hintText: 'Mật khẩu', // Placeholder
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscured ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscured = !_isObscured; // Đảo ngược trạng thái
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập mật khẩu';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPasswordPage()),
                        );
                      },
                      child: Text('Quên mật khẩu'),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Color(0xFF15A362), // Thay đổi màu nền của nút ở đây
                      padding: EdgeInsets.symmetric(
                          vertical: 15), // Thay đổi độ cao của nút
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // Bo tròn nút
                      ),
                    ).copyWith(
                      // Thay đổi màu chữ
                      foregroundColor:
                          MaterialStateProperty.all(Colors.white), // Màu chữ
                    ),
                    onPressed: _login,
                    child: Text('Đăng nhập'),
                  ),
                ),
              ],
            ),
    );
  }
}
