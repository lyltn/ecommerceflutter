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
  Future<void> sendImageSearchRequest(String base64ImageString) async {
    final url = Uri.parse('http://10.0.2.2:8000/image_search');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'base64_image_string': base64ImageString});
    try {
      final response = await http.post(url, headers: headers, body: body);
      print("ditconmeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee${jsonDecode(response.body)}");
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData);
      } else {
        print('Request failed with statusssssssssssssssssssss: ${response.statusCode}');
        print(response.body);
      }
    } catch (e) {
      print('Errorrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr: $e');
    }
  }
  @override
  void initState() {
    super.initState();
    print("base64:${widget.base64img}");
    sendImageSearchRequest(widget.base64img);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            child: SearchImageProduct(listProductId: ['TQBzWAlqo95MTHS6BjCE', 'p2uPlkLfXGysrhnfy1G6']),
          )
        ]
      ),
    );
  }
}