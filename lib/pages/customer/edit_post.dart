import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:ecommercettl/models/PostModel.dart';
import 'package:ecommercettl/services/post_service.dart';

class EditPostPage extends StatefulWidget {
  final PostModel post;

  EditPostPage({required this.post});

  @override
  _EditPostPageState createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {
  final PostService _postService = PostService();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File? _image;

  @override
  void initState() {
    super.initState();
    _contentController.text = widget.post.content;
    _linkController.text = widget.post.link;
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _updatePost() async {
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
                  Text('Updating post...'),
                ],
              ),
            ),
          );
        },
      );

      String? imageUrl;
      if (_image != null) {
        // Upload image to Firebase Storage and get the download URL
        imageUrl = await _postService.uploadImage(_image!);
      }

      // Update the post with the new content and image URL
      PostModel updatedPost = PostModel(
        id: widget.post.id,
        userId: widget.post.userId,
        content: _contentController.text,
        imageUrls: imageUrl != null ? [imageUrl] : widget.post.imageUrls,
        link: _linkController.text,
        status: widget.post.status,
        createdDate: widget.post.createdDate,
        lastModifiedDate: DateTime.now(),
        likeCount: widget.post.likeCount,
        dislikeCount: widget.post.dislikeCount,
      );

      // Save the updated post to Firestore
      await _postService.updatePost(updatedPost);

      // Hide loading spinner
      Navigator.pop(context);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Post updated successfully!')),
      );

      // Navigate back to the previous screen
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Post'),
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
              SizedBox(height: 16),
              _image != null
                  ? Image.file(_image!)
                  : widget.post.imageUrls.isNotEmpty
                      ? Image.network(widget.post.imageUrls.first)
                      : Text('No image selected.'),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Pick Image'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _updatePost,
                child: Text('Update Post'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}