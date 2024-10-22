import 'package:flutter/material.dart';
import '/services/post_service.dart';
import '/services/image_service.dart'; // Import your ImageService
import '/models/post.dart'; // Import your Post model

class PostDialog extends StatefulWidget {
  final PostService postService;

  const PostDialog({super.key, required this.postService});

  @override
  _PostDialogState createState() => _PostDialogState();
}

class _PostDialogState extends State<PostDialog> {
  final TextEditingController contentController = TextEditingController();
  final TextEditingController userIdController = TextEditingController();
  final List<String> imageUrls = [];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Post'),
      content: SingleChildScrollView(
        // Wrap in SingleChildScrollView for scrolling
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: userIdController,
              decoration: const InputDecoration(labelText: 'User ID'),
            ),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(labelText: 'Content'),
            ),
            ElevatedButton(
              onPressed: () async {
                final ImageService imageService = ImageService();
                List<String> uploadedImageUrls =
                    await imageService.uploadImages();
                setState(() {
                  imageUrls.addAll(uploadedImageUrls); // Update the state
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
                    imageUrls.add(capturedImageUrl); // Update the state
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
              // Column(
              //   children: imageUrls.map((url) {
              //     return Padding(
              //       padding: const EdgeInsets.symmetric(vertical: 4.0),
              //       child: Image.network(
              //         url,
              //         fit: BoxFit.cover,
              //         width: double.infinity,
              //         height: 100, // Fixed height for thumbnail
              //       ),
              //     );
              //   }).toList(),
              // )
              ListView.builder(
                itemCount: imageUrls.length,
                itemBuilder: (context, index) {
                  final url = imageUrls[index];
                  return ListTile(
                    title: Text(url),
                  );
                },
              )
            else
              const Text('No images selected.'),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            final newPost = Post(
              id: '', // Firestore will generate this
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
              Navigator.of(context).pop(); // Close the dialog
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
