import 'package:flutter/material.dart';
import '/models/post.dart';

class PostDetailPage extends StatelessWidget {
  final Post post;

  // Constructor to accept the Post object
  const PostDetailPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'User ID: ${post.userId}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Content:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(post.content),
              const SizedBox(height: 8),
              Text(
                'Created on: ${(post.createdDate)}',
                style: const TextStyle(color: Colors.grey),
              ),
              Text(
                'Last modified on: ${post.lastModifiedDate}',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              const Text(
                'Images:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              // Display the images
              post.imageUrls.isNotEmpty
                  ? Column(
                      children: post.imageUrls.map((url) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Image.network(
                            url,
                            fit: BoxFit.cover,
                            // width: double.infinity,
                            // height: 200, // Set a fixed height for the images
                          ),
                        );
                      }).toList(),
                    )
                  : const Text('No images available.'),
            ],
          ),
        ),
      ),
    );
  }
}
