import 'package:flutter/material.dart';

class FilterAction extends StatelessWidget {
  const FilterAction({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
       children: [
        Text(
          'Lọc',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            ),
          
        ),
        Icon(
          Icons.filter_alt_rounded,
          color: Color(0xFF15A362),
        )
       ],
    );
  }
}