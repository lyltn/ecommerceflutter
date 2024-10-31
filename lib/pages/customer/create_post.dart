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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
    if (_formKey.currentState!.validate()) {
      // Show loading spinner
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 16),
                  Text('Creating post...'),
                ],
              ),
            ),
          );
        },
      );

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
        likeCount: 0,
        dislikeCount: 0,
      );

      // Save the post to Firestore
      await _postService.createPost(newPost);

      // Hide loading spinner
      Navigator.pop(context);

      // Clear the selected image and text fields
      setState(() {
        _image = null;
        _contentController.clear();
        _linkController.clear();
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Post created successfully!')),
      );

      // Navigate back to the previous screen
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _contentController,
                decoration: InputDecoration(labelText: 'Content'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter content';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _linkController,
                decoration: InputDecoration(labelText: 'Link'),
              ),
              SizedBox(height: 16),
              _image != null
                  ? Image.file(_image!)
                  : Text('No image selected.'),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Pick Image'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _createPost,
                child: Text('Create Post'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}