import 'package:flutter/material.dart';

class ProductReview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and overall rating
          Row(
            children: [
              Text(
                'Đánh giá sản phẩm',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: [
              // Rating stars
              Icon(Icons.star, color: Colors.yellow, size: 20),
              Icon(Icons.star, color: Colors.yellow, size: 20),
              Icon(Icons.star, color: Colors.yellow, size: 20),
              Icon(Icons.star, color: Colors.yellow, size: 20),
              Icon(Icons.star_half, color: Colors.yellow, size: 20),
              SizedBox(width: 5),
              Text('4.9/5 (3.8k đánh giá)', style: TextStyle(fontSize: 16)),
            ],
          ),
          SizedBox(height: 10),

          // Review List
          Column(
            children: List.generate(2, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Column: User Info
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage(
                                'images/logoCus.png'), // User avatar
                            radius: 20,
                          ),
                          SizedBox(height: 5),
                          Text('Ngoc Ly',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.star, color: Colors.yellow, size: 14),
                              Icon(Icons.star, color: Colors.yellow, size: 14),
                              Icon(Icons.star, color: Colors.yellow, size: 14),
                              Icon(Icons.star, color: Colors.yellow, size: 14),
                              Icon(Icons.star, color: Colors.yellow, size: 14),
                              SizedBox(width: 5),
                              Text('4'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Right Column: Review Content
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Review comment without extra space
                            Text(
                              'Shop nhiệt tình, hỗ trợ mình kịp thời, vải đẹp, mặc lên form đẹp, sẽ ủng hộ tiếp ạ',
                              style: TextStyle(height: 1.2), // Set height to reduce spacing
                            ),
                            SizedBox(height: 5), // Reduce the gap between text and images
                            Row(
                              children: [
                                Image.asset(
                                  'images/dress.png',
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(width: 10),
                                Image.asset(
                                  'images/dress.png',
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ],
                            ),
                            
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
          Divider(
                            color: Colors.black,
                            thickness: 0.5,
                            indent: 0,
                            endIndent: 0,
                          ),
          // "See All" button placed directly below the last review
          Center(
            child: TextButton(
              onPressed: () {},
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Xem tất cả'),
                  Icon(Icons.arrow_right),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
