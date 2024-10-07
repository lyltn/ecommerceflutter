import 'package:ecommercettl/pages/shopaddproduct.dart';
import 'package:ecommercettl/pages/shopaddsize.dart';
import 'package:ecommercettl/pages/shopbottomnav.dart';
import 'package:ecommercettl/widget/widget_support.dart';
import 'package:flutter/material.dart';

class ShopListProduct extends StatefulWidget {
  const ShopListProduct({super.key});

  @override
  State<ShopListProduct> createState() => _ShopListProductState();
}

class _ShopListProductState extends State<ShopListProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách sản phẩm', style: AppWiget.boldTextFeildStyle()),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 1.0, left: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: const Icon(Icons.search_outlined),
                      contentPadding: const EdgeInsets.symmetric(vertical: 5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20.0),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BottomnavShop()));
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF15A362), // Background color
                      shape: BoxShape.circle, // Makes the background circular
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(Icons.home_outlined, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),

            // Product List
            Expanded(
              child: ListView(
                children: [
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      leading: Image.asset(
                        'images/dress.png', // Replace with actual image
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: const Text(
                        'Áo sơ mi tay phồng phong cách hàn quốc',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: const Row(
                        children: [
                          Text(
                            '150,000 VND',
                            style: TextStyle(color: Colors.green),
                          ),
                          SizedBox(width: 10.0),
                          Icon(Icons.star, color: Colors.yellow, size: 16),
                          Text('4.5'),
                        ],
                      ),
                      trailing: PopupMenuButton(
                        icon: const Icon(Icons.more_vert), // Trigger icon
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            child: Icon(Icons.edit_outlined,
                                color: Colors.green), // Pencil icon
                          ),
                          const PopupMenuItem(
                            child: Icon(Icons.delete_outline,
                                color: Colors.red), // Trash bin icon
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Add more product items here...
                ],
              ),
            ),
            const SizedBox(height: 20.0),

            // Add Product Button
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ShopAddProduct()));
              },
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Container(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(
                              color: Colors.green, // Đặt màu viền
                              width: 2.0, // Độ dày của viền
                            ),
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ShopAddProduct()));
                          },
                          child: const Text(
                            'Thêm sản phẩm +',
                            style: TextStyle(
                              color: Colors.green,
                              fontFamily: 'Roboto',
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Container(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(
                              color: Colors.green, // Đặt màu viền
                              width: 2.0, // Độ dày của viền
                            ),
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ShopAddSize()));
                          },
                          child: const Text(
                            'Thêm phân loại +',
                            style: TextStyle(
                              color: Colors.green,
                              fontFamily: 'Roboto',
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
