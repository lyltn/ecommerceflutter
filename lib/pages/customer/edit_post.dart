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
  List<File> _newImages = [];
  List<String> _imageUrls = [];

  @override
  void initState() {
    super.initState();
    _contentController.text = widget.post.content;
    _linkController.text = widget.post.link;
    _imageUrls = List.from(widget.post.imageUrls);
  }

  Future<void> _pickImages() async {
    final pickedFiles = await ImagePicker().pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _newImages.addAll(pickedFiles.map((pickedFile) => File(pickedFile.path)).toList());
      });
    }
  }

  Future<void> _updatePost() async {
    if (_formKey.currentState!.validate()) {
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
                  Text('Đang cập nhật bài viết...'),
                ],
              ),
            ),
          );
        },
      );

      List<String> updatedImageUrls = List.from(_imageUrls);
      for (File image in _newImages) {
        String imageUrl = await _postService.uploadImage(image);
        updatedImageUrls.add(imageUrl);
      }

      PostModel updatedPost = PostModel(
        id: widget.post.id,
        userId: widget.post.userId,
        content: _contentController.text,
        imageUrls: updatedImageUrls,
        link: _linkController.text,
        status: widget.post.status,
        createdDate: widget.post.createdDate,
        lastModifiedDate: DateTime.now(),
        likeCount: widget.post.likeCount,
        dislikeCount: widget.post.dislikeCount,
      );

      await _postService.updatePost(updatedPost);
      Navigator.pop(context); // Hide loading spinner

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cập nhật bài viết thành công.')),
      );

      Navigator.pop(context, true); // Navigate back
    }
  }

  void _removeImage(int index) {
    setState(() {
      _imageUrls.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chỉnh sửa bài viết'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: _contentController,
                    maxLines: 4, // Allow multiple lines for content
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF15A362)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      labelText: 'Nội dung',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập nội dung';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              SizedBox(height: 16),
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: _linkController,
                    decoration: InputDecoration(
                      labelText: 'Link',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF15A362)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      if (_imageUrls.isNotEmpty)
                        Column(
                          children: _imageUrls.asMap().entries.map((entry) {
                            int index = entry.key;
                            String imageUrl = entry.value;
                            return Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                    height: 200,
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _removeImage(index),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        )
                      else
                        Text('Không có ảnh nào được chọn', style: TextStyle(color: Colors.grey)),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _pickImages,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          backgroundColor: Color(0xFF15A362),
                          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                        ),
                        child: Text('Chọn ảnh', style: TextStyle(fontSize: 16, color: Colors.white)),
                      ),
                      if (_newImages.isNotEmpty)
                        Column(
                          children: _newImages.map((image) {
                            return Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(
                                    image,
                                    fit: BoxFit.cover,
                                    height: 200,
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        _newImages.remove(image);
                                      });
                                    },
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _updatePost,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: Color(0xFF15A362),
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text('Cập nhật bài viết', style: TextStyle(fontSize: 16, color: Colors.white),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}