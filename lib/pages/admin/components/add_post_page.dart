import 'package:flutter/material.dart';
import '/services/post_service.dart';
import '/services/image_service.dart';
import '/models/post.dart';

class AddPostPage extends StatefulWidget {
  final PostService postService;

  const AddPostPage({super.key, required this.postService});

  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final TextEditingController contentController = TextEditingController();
  final TextEditingController userIdController = TextEditingController();
  final List<String> imageUrls = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Post'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () async {
              // Create new post
              final newPost = Post(
                id: '',
                userId: userIdController.text,
                content: contentController.text,
                imageUrls: imageUrls,
                link: '',
                createdDate: DateTime.now(),
                lastModifiedDate: DateTime.now(),
              );

              // Add the post to Firestore
              await widget.postService.addPost(newPost);
              if (context.mounted) {
                Navigator.of(context).pop(); // Go back to the post list page
              }
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: userIdController,
              decoration: const InputDecoration(labelText: 'User ID'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(labelText: 'Content'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final ImageService imageService = ImageService();
                List<String> uploadedImageUrls =
                    await imageService.uploadImages();
                setState(() {
                  imageUrls.addAll(uploadedImageUrls); // Update selected images
                });
              },
              child: const Text('Upload Images'),
            ),
            ElevatedButton(
              onPressed: () async {
                final ImageService imageService = ImageService();
                String? capturedImageUrl = await imageService.captureImage();
                if (capturedImageUrl != null) {
                  setState(() {
                    imageUrls.add(capturedImageUrl); // Update captured image
                  });
                }
              },
              child: const Text('Capture Image'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Selected Images:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (imageUrls.isNotEmpty)
              Column(
                children: imageUrls.map((url) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Image.network(
                      url,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      // height: 100,
                    ),
                  );
                }).toList(),
              )
            else
              const Text('No images selected.'),
          ],
        ),
      ),
    );
  }
}
