import 'package:flutter/material.dart';

class CheckoutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thanh toán'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button press
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Delivery Address
              Text('Địa chỉ nhận hàng'),
              // You can replace this with a more detailed address widget
              Text('Đào trung thành | (+84) 868991011'),
              Divider(),

              // Order Items
              // Replace with a ListView.builder for multiple items
              ListTile(
                leading: Image.asset('images/dress.png'),
                title: Text('Đầm hoa nhí trễ vai xinh ph...'),
                subtitle: Text('150.000đ'),
                trailing: Text('x1'),
              ),
              Divider(),

              // Order Summary
              Text('Tổng số tiền (1 sản phẩm)'),
              Text('162.030 đ', style: TextStyle(fontWeight: FontWeight.bold)),
              Divider(),

              // Payment Method
              Text('Phương thức thanh toán'),
              Text('Thanh toán khi nhận hàng'),
              Divider(),

              // Order Details
              Text('Chi tiết thanh toán'),
              // Add more detailed breakdown here
              
              Divider(),
              Text('Tổng thanh toán'),
              Text('162.030 đ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16.0),
        child: ElevatedButton(
          child: Text('Mua hàng (1)'),
          onPressed: () {
            // Handle purchase
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            minimumSize: Size(double.infinity, 50),
          ),
        ),
      ),
    );
  }
}