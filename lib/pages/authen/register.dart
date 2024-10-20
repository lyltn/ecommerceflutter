import 'package:ecommercettl/pages/client/shopbottomnav.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isObscured = true; // Trạng thái để ẩn/hiện mật khẩu
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập email';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Email không hợp lệ';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập số điện thoại';
    }
    final phoneRegex = RegExp(r'^\d{10,11}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Số điện thoại không hợp lệ';
    }
    return null;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        // Lưu thông tin người dùng vào Firestore
        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'username': _usernameController.text,
          'phone': _phoneController.text,
          'address': _addressController.text,
          'email': _emailController.text,
          'dob': _dobController.text,
        });

        // Đăng ký thành công, đăng nhập và chuyển hướng đến trang chính
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomnavShop()),
        );

        // Hiển thị thông báo đăng ký thành công
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đăng ký thành công và đã đăng nhập')),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('Mật khẩu quá yếu.');
        } else if (e.code == 'email-already-in-use') {
          print('Email đã được sử dụng.');
        }
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Hàng cho Tên tài khoản
          Padding(
            padding: const EdgeInsets.only(bottom: 10), // Khoảng cách dưới 10px
            child: Text(
              'Tên tài khoản',
              style: TextStyle(
                fontWeight: FontWeight.bold, // In đậm
                fontSize: 16, // Kích thước chữ
              ),
            ),
          ),
          // TextFormField cho Tên tài khoản
          Container(
            child: TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30), // Bo tròn 30px
                ),
                hintText: 'Nhập username...',// Placeholder
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập tên tài khoản';
                }
                return null;
              },
            ),
          ),
          SizedBox(height: 20), // Khoảng cách giữa 2 hàng

          // Hàng cho Mật khẩu
          Padding(
            padding: const EdgeInsets.only(bottom: 10), // Khoảng cách dưới 10px
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
          SizedBox(height: 20), // Khoảng cách giữa 2 hàng

          // Hàng cho Số điện thoại
          Padding(
            padding: const EdgeInsets.only(bottom: 10), // Khoảng cách dưới 10px
            child: Text(
              'Số điện thoại',
              style: TextStyle(
                fontWeight: FontWeight.bold, // In đậm
                fontSize: 16, // Kích thước chữ
              ),
            ),
          ),
          // TextFormField cho Số điện thoại
          TextFormField(
            controller: _phoneController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30), // Bo tròn 30px
              ),
              hintText: 'Nhập số điện thoại...', // Placeholder
            ),
            validator: _validatePhone,
          ),
          SizedBox(height: 20), // Khoảng cách giữa 2 hàng

          // Hàng cho Địa chỉ
          Padding(
            padding: const EdgeInsets.only(bottom: 10), // Khoảng cách dưới 10px
            child: Text(
              'Địa chỉ',
              style: TextStyle(
                fontWeight: FontWeight.bold, // In đậm
                fontSize: 16, // Kích thước chữ
              ),
            ),
          ),
          // TextFormField cho Địa chỉ
          TextFormField(
            controller: _addressController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30), // Bo tròn 30px
              ),
              hintText: 'Nhập địa chỉ...', // Placeholder
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập địa chỉ';
              }
              return null;
            },
          ),
          SizedBox(height: 20), // Khoảng cách giữa 2 hàng

          // Hàng cho Email
          Padding(
            padding: const EdgeInsets.only(bottom: 10), // Khoảng cách dưới 10px
            child: Text(
              'Email',
              style: TextStyle(
                fontWeight: FontWeight.bold, // In đậm
                fontSize: 16, // Kích thước chữ
              ),
            ),
          ),
          // TextFormField cho Email
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30), // Bo tròn 30px
              ),
              hintText: 'Nhập email...', // Placeholder
            ),
            validator: _validateEmail,
          ),
          SizedBox(height: 20), // Khoảng cách giữa 2 hàng

          // Hàng cho Ngày sinh
          Padding(
            padding: const EdgeInsets.only(bottom: 10), // Khoảng cách dưới 10px
            child: Text(
              'Ngày sinh',
              style: TextStyle(
                fontWeight: FontWeight.bold, // In đậm
                fontSize: 16, // Kích thước chữ
              ),
            ),
          ),
          // TextFormField cho Ngày sinh
          TextFormField(
            controller: _dobController,
            readOnly: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30), // Bo tròn 30px
              ),
              hintText: 'Nhập ngày sinh...', // Placeholder
              suffixIcon: IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: () => _selectDate(context),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập ngày sinh';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 40),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF15A362), // Thay đổi màu nền của nút ở đây
                padding: EdgeInsets.symmetric(vertical: 15), // Thay đổi độ cao của nút
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Bo tròn nút
                ),
              ).copyWith(
                // Thay đổi màu chữ
                foregroundColor: MaterialStateProperty.all(Colors.white), // Màu chữ
              ),
              onPressed: _register,
              child: Text('Đăng ký'),
            ),
          ),
        ],
      ),
    );
  }
}