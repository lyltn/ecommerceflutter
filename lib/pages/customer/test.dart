import 'package:flutter/material.dart';

class HomeTest extends StatefulWidget {
  @override
  _HomeTestState createState() => _HomeTestState();
}

class _HomeTestState extends State<HomeTest> {
  List<String> categories = ['Thời trang nam', 'Thời trang nam', 'Thời trang nam', 'Thời trang nam'];
  List<String> priceRanges = ['0-100k', '100k-200k', '200k-300k'];
  bool showAllCategories = false;
  bool showAllPriceRanges = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: Text(
          'Bộ lọc tìm kiếm',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                Text('Theo danh mục', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ...categories.take(showAllCategories ? categories.length : 4).map((category) => 
                      Chip(
                        label: Text(category),
                        backgroundColor: Colors.grey[200],
                      )
                    ),
                  ],
                ),
                if (categories.length > 4)
                  TextButton(
                    child: Text(showAllCategories ? 'Thu gọn' : 'Xem thêm'),
                    onPressed: () => setState(() => showAllCategories = !showAllCategories),
                  ),
                Divider(),
                Text('Khoảng giá (đ)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'TỐI THIỂU',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text('-'),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'TỐI ĐA',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ...priceRanges.take(showAllPriceRanges ? priceRanges.length : 3).map((range) => 
                      Chip(
                        label: Text(range),
                        backgroundColor: Colors.grey[200],
                      )
                    ),
                  ],
                ),
                if (priceRanges.length > 3)
                  TextButton(
                    child: Text(showAllPriceRanges ? 'Thu gọn' : 'Xem thêm'),
                    onPressed: () => setState(() => showAllPriceRanges = !showAllPriceRanges),
                  ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    child: Text('Thiết lập lại'),
                    onPressed: () {
                      // Reset logic here
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.green),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    child: Text('Áp dụng'),
                    onPressed: () {
                      // Apply filter logic here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.green,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(.60),
        selectedFontSize: 14,
        unselectedFontSize: 14,
        items: [
          BottomNavigationBarItem(
            label: 'Trang chủ',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Danh mục',
            icon: Icon(Icons.list),
          ),
          BottomNavigationBarItem(
            label: 'Giao hàng',
            icon: Icon(Icons.local_shipping),
          ),
          BottomNavigationBarItem(
            label: 'Cá nhân',
            icon: Icon(Icons.person),
          ),
        ],
      ),
    );
  }
}
