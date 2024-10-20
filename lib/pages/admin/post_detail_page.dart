import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PostDetailPage extends StatelessWidget {
  final DocumentSnapshot post;

  const PostDetailPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    // Extracting data from the passed post document
    Map<String, dynamic> data = post.data() as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(title: const Text('Post Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Post Title: ${data['postTitle']}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Image.network(data['postImgUrl']),
            const SizedBox(height: 10),
            Text('Post Link: ${data['postLink']}'),
            const SizedBox(height: 10),
            Text('Post Date: ${data['postDate'].toDate()}'),
            const SizedBox(height: 10),
            Text('Status: ${data['status']}'),
            const SizedBox(height: 10),
            Text('User ID: ${data['userId']}'),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
