import 'package:ecommercettl/pages/customer/component/PhotoGallery.dart';
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
        child: Container(
          color: Colors.white,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0), // Add 5px padding
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: MediaQuery.of(context).size.height*0.8,
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
              Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
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
                    ],
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
            ],
          ),
        ),
      ),
    );
  }
}
