import 'dart:convert';
import 'dart:io';

import 'package:ecommercettl/pages/customer/ImageSearchPage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
                  suffixIcon: GestureDetector(
                    onTap: () async {
                      final picker = ImagePicker();
                      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        // Read the image as bytes
                        final bytes = await File(pickedFile.path).readAsBytes();
                        // Convert bytes to base64 string
                        final base64Image = base64Encode(bytes);

                        // Navigate to ImageSearchPage with the base64 image
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ImageSearchPage(base64img: base64Image),
                          ),
                        );
                      }
                    },
                    child: Icon(Icons.photo_camera, color: Colors.black),
                  ),
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
