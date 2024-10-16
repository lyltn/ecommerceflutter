import 'package:flutter/material.dart';

class PriceRangeButton extends StatelessWidget {
  final String range;
  final Function(String) onTap;

  const PriceRangeButton({
    Key? key,
    required this.range,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(range),
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            range,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}