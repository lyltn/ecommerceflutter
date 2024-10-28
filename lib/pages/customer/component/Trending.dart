import 'package:flutter/material.dart';

class Trending extends StatelessWidget {
  final String lastDate;

  const Trending({Key? key, required this.lastDate}) : super(key: key);

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
                'Trending Products',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),

              Row(
                children: [
                  Icon(
                    Icons.calendar_month_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                  SizedBox(width: 4),
                  Text(
                    lastDate,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Right column: contains the "View all" button
          ElevatedButton(
            onPressed: () {
              // Add your "View all" action here
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'View all',
                  style: TextStyle(
                    color: Color(0xFF4CAF50),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  Icons.arrow_forward,
                  color: Color(0xFF4CAF50),
                  size: 18,
                ),
              ],
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Color(0xFF4CAF50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }
}
