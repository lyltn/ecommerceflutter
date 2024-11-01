import 'package:ecommercettl/pages/customer/component/searchProductImg.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ImageSearchPage extends StatefulWidget {
  final String base64img;
  const ImageSearchPage({super.key, required this.base64img});

  @override
  State<ImageSearchPage> createState() => _ImageSearchPageState();
}

class _ImageSearchPageState extends State<ImageSearchPage> {
  List<String> productIds = [];

  Future<void> sendImageSearchRequest(String base64ImageString) async {
    final url = Uri.parse('http://127.0.0.1:8000/image_search');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'base64_image_string': base64ImageString});

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Ensure all IDs are converted to strings
        setState(() {
          productIds = List<String>.from(responseData['productDocId'].map((id) => id.toString()));
        });

        print("Product IDs: $productIds");
      } else {
        print('Request failed with status: ${response.statusCode}');
        print(response.body);
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    print("base64: ${widget.base64img}");
    sendImageSearchRequest(widget.base64img);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            child: productIds.isNotEmpty
                ? SearchImageProduct(listProductId: productIds)
                : Center(child: CircularProgressIndicator()), // Optional: show loading spinner
          ),
        ],
      ),
    );
  }
}