import 'package:ecommercettl/pages/customer/component/PhotoGallery.dart';
import 'package:ecommercettl/pages/customer/component/ProductReview.dart';
import 'package:flutter/material.dart';

class Productdetail extends StatefulWidget {
  const Productdetail({super.key});

  @override
  State<Productdetail> createState() => ProductdetailState();
}

class ProductdetailState extends State<Productdetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack( // Use Stack to layer widgets
          children: [
            SingleChildScrollView(
              // Wrap content in SingleChildScrollView
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0), // Add 5px padding
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.8,
                              decoration: BoxDecoration(
                                // You can set decoration properties here
                                color: Colors.white, // Background color
                              ),
                              child: PhotoGallery(), // Assuming PhotoGallery is the intended widget to display
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 0,
                        bottom: 0,
                        right: 0,
                        left: 15,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'đ',
                                style: TextStyle(
                                  fontSize: 26,
                                  color: Colors.red,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.red,
                                ),
                              ),
                              Text(
                                '223.479',
                                style: TextStyle(
                                  fontSize: 32,
                                  color: Colors.red,
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              const Text(
                                'MORSELA chính hãng - Áo thun croptop nữ kiểu tay ngắn xẻ tà NOTE phong cách dân gian đương đại',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              Divider(
                                color: Colors.black,
                                thickness: 0.5,
                                indent: 0,
                                endIndent: 0,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.verified_user_outlined,
                                    color: Color(0xFF015A362),
                                  ),
                                  Expanded( // Add Expanded here to prevent overflow
                                    child: Text(
                                      'Đổi ý miễn phí 15 ngày - Chính hãng 100% - .... ',
                                      style: TextStyle(fontSize: 16),
                                      overflow: TextOverflow.ellipsis, // Avoid text overflow
                                    ),
                                  ),
                                ],
                              ),
                              Divider(
                                color: Colors.black,
                                thickness: 0.5,
                                indent: 0,
                                endIndent: 0,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    ProductReview()
                  ],
                ),
              ),
            ),
            // Positioned buttons at the bottom
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(10.0),
                color: Colors.white, // Background color for buttons
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded( // Use Expanded to control width
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white, // White background
                          foregroundColor: Color(0xFF15A362), // Blue text
                          side: BorderSide(color: Color(0xFF15A362)), // Blue border
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero, // No border radius
                          ),
                        ),
                        onPressed: () {
                          // Action for button 1
                        },
                        child: Text('Button 1'),
                      ),
                    ),
                    SizedBox(width: 10), // Add space between buttons
                    Expanded( // Use Expanded to control width
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF15A362), // Blue background
                          foregroundColor: Colors.white, // White text
                          side: BorderSide(color: Color(0xFF15A362)), // Blue border
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero, // No border radius
                          ),
                        ),
                        onPressed: () {
                          // Action for button 2
                        },
                        child: Text('Button 2'),
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
