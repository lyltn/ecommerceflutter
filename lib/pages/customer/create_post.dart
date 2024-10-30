import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:ecommercettl/models/PostModel.dart';
import 'package:ecommercettl/services/post_service.dart';

class CreatePostPage extends StatefulWidget {
  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final PostService _postService = PostService();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _createPost() async {
    if (_image != null && _contentController.text.isNotEmpty) {
      // Upload image to Firebase Storage and get the download URL
      String imageUrl = await _postService.uploadImage(_image!);

      // Create a new post with the image URL
      PostModel newPost = PostModel(
        id: FirebaseFirestore.instance.collection('posts').doc().id,
        userId: FirebaseAuth.instance.currentUser!.uid,
        content: _contentController.text,
        imageUrls: [imageUrl],
        link: _linkController.text,
        status: true,
        createdDate: DateTime.now(),
        lastModifiedDate: DateTime.now(),
      );

      // Save the post to Firestore
      await _postService.createPost(newPost);

      // Clear the selected image and text fields
      setState(() {
        _image = null;
        _contentController.clear();
        _linkController.clear();
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tạo bài viết thành công!')),
      );

      // Navigate back to the previous screen
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tạo bài viết'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Nội dung'),
            ),
            TextField(
              controller: _linkController,
              decoration: InputDecoration(labelText: 'Link'),
            ),
            SizedBox(height: 16),
            _image != null
                ? Image.file(_image!)
                : Text('Không có hình ảnh nào được chọn.'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Chọn ảnh'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _createPost,
              child: Text('Tạo bài viết'),
            ),
          ],
        ),
      ),
    );
  }
}