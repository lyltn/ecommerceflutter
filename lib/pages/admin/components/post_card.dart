import 'package:flutter/material.dart';
import '/models/post.dart'; // Assuming you have a Post model defined

class PostCard extends StatefulWidget {
  final Post post; // Post model to pass data
  final VoidCallback? onDelete; // Callback for delete action
  final VoidCallback? onTap; // Callback for onTap event

  const PostCard({
    super.key,
    required this.post,
    required this.onDelete,
    required this.onTap,
  });

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _isConfirmingDelete = false; // State to track delete confirmation

  void _toggleDeleteConfirmation() {
    setState(() {
      _isConfirmingDelete =
      !_isConfirmingDelete; // Toggle the confirmation state
    });
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        margin: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    child: Icon(Icons.person, color: Colors.grey[600]),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      post.userId, // User ID from the post
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Conditional rendering of delete button or confirmation icons
                  if (_isConfirmingDelete)
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check, color: Colors.green),
                          onPressed: () {
                            widget.onDelete!(); // Confirm delete action
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed:
                          _toggleDeleteConfirmation, // Cancel delete action
                        ),
                      ],
                    )
                  else
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed:
                      _toggleDeleteConfirmation, // Show confirmation options
                    ),
                ],
              ),
            ),
            if (post.imageUrls.isNotEmpty)
              SizedBox(
                height: 200, // Limit height of the images
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: post.imageUrls.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(
                        post.imageUrls[index],
                        fit: BoxFit.contain,
                        width: 150, // Set fixed width for each image
                        height: 200,
                      ),
                    );
                  },
                ),
              )
            else
              Container(
                height: 200,
                color: Colors.grey[300],
                child: const Center(
                  child: Text('No images available'),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                post.content, // Post content
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (post.link.isNotEmpty) // Only show if link is available
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Link: ${post.link}',
                  style: const TextStyle(color: Colors.blue),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Text(
                'Created on: ${post.createdDate}',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
