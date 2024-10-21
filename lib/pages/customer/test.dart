import 'dart:io';
import 'package:ecommercettl/pages/customer/test2.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';



class Test extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Upload Multiple Images',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProductImageUploader(),
    );
  }
}

class ProductImageUploader extends StatefulWidget {
  @override
  _ProductImageUploaderState createState() => _ProductImageUploaderState();
}

class _ProductImageUploaderState extends State<ProductImageUploader> {
  List<File> _images = [];
  final ImagePicker _picker = ImagePicker();
  List<String> imageUrls = [];

  // Chọn nhiều ảnh
  Future<void> pickImages() async {
    final List<XFile>? selectedImages = await _picker.pickMultiImage();
    if (selectedImages != null) {
      setState(() {
        _images = selectedImages.map((image) => File(image.path)).toList();
      });
    }
  }

  // Upload ảnh lên Firebase Storage và trả về URL của từng ảnh
  Future<void> uploadImages() async {
    List<String> uploadedUrls = [];
    for (var image in _images) {
      try {
        Reference storageRef = FirebaseStorage.instance
            .ref()
            .child('product_images/${DateTime.now().millisecondsSinceEpoch}_${image.path.split('/').last}');

        UploadTask uploadTask = storageRef.putFile(image);

        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();
        uploadedUrls.add(downloadUrl);
      } catch (e) {
        print('Error uploading image: $e');
      }
    }

    setState(() {
      imageUrls = uploadedUrls;
    });
  }

  // Lưu các URL ảnh vào Firestore
  Future<void> saveImageUrlsToFirestore() async {
    if (imageUrls.isNotEmpty) {
      await FirebaseFirestore.instance.collection('Testproducts').add({
        'imageUrls': imageUrls,
        'createdAt': FieldValue.serverTimestamp(),
      });
      print('Image URLs saved to Firestore!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Multiple Images'),
      ),
      body: Column(
        children: <Widget>[
          ElevatedButton(
            onPressed: pickImages,
            child: Text("Chọn ảnh"),
          ),
          SizedBox(height: 10),
          Expanded(
            child: _buildGridView(),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              await uploadImages();
              await saveImageUrlsToFirestore();
              print("Images uploaded and URLs saved!");
            },
            child: Text("Upload và lưu"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductImageDisplay(),
                ),
              );
            },
            child: Text("Xem"),
          ),
        ],
      ),
    );
  }

  // Hiển thị lưới ảnh đã chọn
  Widget _buildGridView() {
    if (_images.isNotEmpty) {
      return GridView.count(
        crossAxisCount: 3,
        children: List.generate(_images.length, (index) {
          return Image.file(
            _images[index],
            fit: BoxFit.cover,
          );
        }),
      );
    } else {
      return Center(child: Text('Chưa chọn ảnh'));
    }
  }
}
