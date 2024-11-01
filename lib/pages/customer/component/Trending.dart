import 'package:flutter/material.dart';

class Trending extends StatelessWidget {

  const Trending({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Color(0xFF4CAF50),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left column: contains two rows
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // First row: Deal of the Day text
              Text(
                'Tất cả sản phẩm',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
            ],
          ),
        ],
      ),
    );
  }
}
