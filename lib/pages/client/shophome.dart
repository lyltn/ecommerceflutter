import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class HomeShop extends StatefulWidget {
  const HomeShop({Key? key}) : super(key: key);

  @override
  State<HomeShop> createState() => _HomeShopState();
}

class _HomeShopState extends State<HomeShop> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'THỐNG KÊ SHOP',
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Thông tin tổng quan về đơn hàng và doanh thu
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: _buildInfoCard("250", "Đơn hàng", Colors.green)),
                const SizedBox(width: 16),
                Expanded(
                    child: _buildInfoCard(
                        "75,000 VNĐ", "Doanh thu", Colors.green)),
              ],
            ),
            const SizedBox(height: 16),
            // Vòng tròn phần trăm cho đặt hàng và bỏ giỏ hàng
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: _buildCircularIndicator(
                        "Đặt hàng", 0.81, Colors.green)),
                const SizedBox(width: 16),
                Expanded(
                    child: _buildCircularIndicator(
                        "Bỏ giỏ hàng", 0.22, Colors.red)),
              ],
            ),
            const SizedBox(height: 16),
            // Phần thống kê chi tiết
            _buildAnalyticsSection(),
            const SizedBox(height: 16),

            const SizedBox(height: 16),
            // Biểu đồ cột
            _buildBarChart(),
          ],
        ),
      ),
    );
  }

  // Widget hiển thị thẻ thông tin
  Widget _buildInfoCard(String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.shopping_cart, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }

  // Widget hiển thị vòng tròn phần trăm
  Widget _buildCircularIndicator(String label, double percentage, Color color) {
    return Column(
      children: [
        CircularPercentIndicator(
          radius: 50.0,
          lineWidth: 8.0,
          percent: percentage,
          center: Text("${(percentage * 100).round()}%"),
          progressColor: color,
          backgroundColor: Colors.grey[300]!,
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(color: Colors.grey[600])),
      ],
    );
  }

  // Widget hiển thị thông tin thống kê chi tiết
  Widget _buildAnalyticsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
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
          _buildAnalyticsItem("Đơn hôm nay", "25", Colors.green),
          _buildAnalyticsItem("Khách hàng mới", "15", Colors.green),
          _buildAnalyticsItem("h TB", "5.5", Colors.green),
          _buildAnalyticsItem("Tổng lượt truy cập", "300", Colors.green),
        ],
      ),
    );
  }

  // Widget tạo mục thống kê chi tiết nhỏ
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

// CustomPainter cho biểu đồ chấm chấm
