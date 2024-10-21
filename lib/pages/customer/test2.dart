import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductImageDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Images'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Testproducts').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          List<String> imageUrls = [];

          // Duyệt qua từng document và lấy danh sách imageUrls
          snapshot.data!.docs.forEach((doc) {
            List<dynamic> urls = doc['imageUrls'];
            imageUrls.addAll(urls.cast<String>());
          });

          return _buildGridView(imageUrls);
        },
      ),
    );
  }

  // Tạo GridView để hiển thị ảnh
  Widget _buildGridView(List<String> imageUrls) {
    if (imageUrls.isNotEmpty) {
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Hiển thị 3 ảnh mỗi hàng
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
        ),
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return Image.network(
            imageUrls[index],
            fit: BoxFit.cover,
          );
        },
      );
    } else {
      return Center(child: Text('No images available'));
    }
  }
}
