// edit_post.dart
import 'package:flutter/material.dart';
import 'package:ecommercettl/models/PostModel.dart';
import 'package:ecommercettl/services/post_service.dart';

class EditPostPage extends StatefulWidget {
  final PostModel post;

  EditPostPage({required this.post});

  @override
  _EditPostPageState createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {
  final _formKey = GlobalKey<FormState>();
  final PostService _postService = PostService();
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(text: widget.post.content);
  }

  Future<void> _updatePost() async {
    if (_formKey.currentState!.validate()) {
      widget.post.content = _contentController.text;
      await _postService.updatePost(widget.post);
      Navigator.pop(context);
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
              ElevatedButton(
                onPressed: _updatePost,
                child: Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}