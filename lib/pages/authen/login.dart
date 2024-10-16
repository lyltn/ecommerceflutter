import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState(); // Tạo trạng thái tương ứng
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscured = true; // Trạng thái để ẩn/hiện mật khẩu
  bool _rememberMe = true;

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
              
              // Thêm Text "Đăng nhập" ở đây
              Center(
                child: Text(
                  'Đăng nhập',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20), // Khoảng cách giữa tiêu đề và form

              Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Căn chỉnh tiêu đề về phía trái
                children: <Widget>[
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
                  // TextField cho Tên tài khoản
                  Container(
                    child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30), // Bo tròn 30px
                      ),
                      hintText: 'Nhập username...',// Placeholder
                    ),
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
                  // TextField cho Mật khẩu
                  TextField(
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
                  ),
                ],
              ),

               Row(
               mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Checkbox(
                    value: _rememberMe, // Giá trị của checkbox
                    onChanged: (value) {
                      setState(() {
                        _rememberMe = value!; // Cập nhật trạng thái khi checkbox được click
                      });
                    },
                  ),
                  Text('Nhớ tôi'),
                    ],
                  ),// Tạo khoảng cách giữa checkbox và text "Quên mật khẩu?"
                  TextButton(
                    onPressed: () {},
                    child: Text('Quên mật khẩu?'),
                  ),
                ],
              ),
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
                onPressed: () {},
                child: Text('Đăng nhập'),
              ),
              ),
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 50),
                child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Divider(
                  color: Colors.black,
                  thickness: 1.0,
                  height: 10.0, // Chiều cao xung quanh Divider
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('Hoặc'),
              ),
              Expanded(
                child: Divider(
                  color: Colors.black,
                  thickness: 1.0,
                  height: 10.0,
                ),
              ),
            ],
          ),
              ),
        
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.facebook),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.facebook),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Bạn chưa có tài khoản?'),
                  TextButton(
                    onPressed: () {},
                    child: Text('Đăng ký'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      )
    );
  }
}
