import 'package:ecommercettl/pages/admin/adminleftnav.dart';

import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: LeftNavigation(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 2,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: AppBar(
            title: Text(
              'THỐNG KÊ SÀN',
              style: TextStyle(color: Colors.black),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 1,
            actions: [
              IconButton(
                icon: Icon(Icons.notifications, color: Colors.black),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoCard("75", "Người dùng", Colors.green),
                _buildInfoCard("250", "Đơn hàng", Colors.green),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCircularIndicator("Đặt hàng", 0.81, Colors.green),
                _buildCircularIndicator("Thêm giỏ hàng", 0.22, Colors.green),
                _buildCircularIndicator("Tạo blog", 0.62, Colors.green),
              ],
            ),
            SizedBox(height: 16),
            _buildAnalyticsSection(),
            SizedBox(height: 16),
            _buildBarChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String value, String label, Color color) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(Icons.insert_chart, color: color, size: 32),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(label, style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularIndicator(String label, double percentage, Color color) {
    return Expanded(
      child: Column(
        children: [
          CircularPercentIndicator(
            radius: 50.0,
            lineWidth: 8.0,
            percent: percentage,
            center: Text("${(percentage * 100).round()}%"),
            progressColor: color,
            backgroundColor: Colors.grey[300]!,
          ),
          SizedBox(height: 8),
          Text(label, style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildAnalyticsSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildAnalyticsItem("Views", "39.7k", Colors.green),
          _buildAnalyticsItem("New Members", "5.8k", Colors.green),
          _buildAnalyticsItem("Avg Time", "250.1", Colors.green),
          _buildAnalyticsItem("Total Visits", "150k", Colors.green),
        ],
      ),
    );
  }

  Widget _buildAnalyticsItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ],
    );
  }

  Widget _buildBarChart() {
    // Giả lập dữ liệu cho từng ngày trong tuần
    List<double> data = [15.0, 8.0, 12.0, 10.0, 17.0, 5.0, 14.0];
    List<String> days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(data.length, (index) {
        return Column(
          mainAxisAlignment:
              MainAxisAlignment.end, // Đảm bảo các cột nằm dưới cùng
          children: [
            SizedBox(
              height: 150, // Chiều cao cố định cho biểu đồ
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: data[index] * 10, // Chiều cao của từng cột
                  width: 20,
                  color: Colors.green,
                ),
              ),
            ),
            SizedBox(height: 4),
            Text(days[index], style: TextStyle(color: Colors.black)),
          ],
        );
      }),
    );
  }
}
