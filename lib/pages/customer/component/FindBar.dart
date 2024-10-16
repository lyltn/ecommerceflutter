import 'package:flutter/material.dart';

class Findbar extends StatefulWidget {
  final bool isEnabled;
  final String? searchQuery;
  final Function()? onTap;

  const Findbar({
    Key? key,
    this.isEnabled = true,
    this.searchQuery,
    this.onTap,
  }) : super(key: key);

  @override
  _FindbarState createState() => _FindbarState();
}

class _FindbarState extends State<Findbar> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.searchQuery);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[200],
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.7),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: _controller,
                enabled: widget.isEnabled,
                style: TextStyle(
                  color: widget.isEnabled ? Colors.black : Colors.black, // Ensure text color stays black
                ),
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm...',
                  hintStyle: TextStyle(color: Colors.grey), // Customize hint text color
                  prefixIcon: Icon(Icons.search, color: Colors.black),
                  suffixIcon: Icon(Icons.mic, color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.transparent,
                ),
                onSubmitted: (String searchQuery) {
                  if (searchQuery.isNotEmpty) {
                    Navigator.pushNamed(context, '/searchProduct', arguments: searchQuery);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
