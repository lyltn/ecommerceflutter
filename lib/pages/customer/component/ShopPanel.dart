import 'package:ecommercettl/pages/customer/shopdetail.dart';
import 'package:flutter/material.dart';

class ShopPanel extends StatelessWidget {
  final String shopImg;
  final String shopName;
  final String shopAddress;
  final int productCount;
  final String shopId;

  const ShopPanel({
    Key? key,
    required this.shopImg,
    required this.shopName,
    required this.shopAddress,
    required this.productCount,
    required this.shopId
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    print("shopidd at shoppanel : ${shopId}");
    return Card(
      margin: const EdgeInsets.all(3.0),
      color: Colors.grey[100],
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Display shop logo or placeholder if the image is empty
                shopImg.isNotEmpty
                    ? CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(shopImg),
                      )
                    : Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[300],
                        ),
                        child: const Center(
                          child: Text(
                            'Logo',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shopName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            shopAddress,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Add action for "Xem Shop" button
                  },
                  child: GestureDetector(
                      onTap: () {
                        print("Navigating to ShopDetailPage with shopId: $shopId and shopName: $shopName");
                        if (shopId != null && shopName.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ShopDetailPage(
                                shopName: shopName,
                                shopId: shopId,
                              ),
                            ),
                          );
                        } else {
                          print("Error: shopId or shopName is null or empty.");
                        }
                      },
                      child: const Text('Xem Shop')),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ShopStat(
                    label: 'sản phẩm',
                    value: productCount.toString()), // Fixed here
                const ShopStat(label: 'Đánh giá', value: '4.9'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ShopStat extends StatelessWidget {
  final String label;
  final String value;

  const ShopStat({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
