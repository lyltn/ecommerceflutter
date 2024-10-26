import 'package:flutter/material.dart';

class PostCard extends StatefulWidget {
  final String username;
  final String imageUrl;
  final String postText;
  final VoidCallback? onDelete; // Callback for delete action
  final VoidCallback? onTap;

  const PostCard({
    super.key,
    required this.username,
    required this.imageUrl,
    required this.postText,
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
                  Text(
                    widget.username,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
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
            Image.network(
              widget.imageUrl,
              fit: BoxFit.cover,
              height: 200,
              width: double.infinity,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.postText,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
