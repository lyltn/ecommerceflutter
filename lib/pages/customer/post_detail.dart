import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecommercettl/models/PostModel.dart';
import 'package:ecommercettl/models/CommentModel.dart';
import 'package:ecommercettl/models/UserModel.dart';
import 'package:ecommercettl/services/auth_service.dart';
import 'package:intl/intl.dart';

class PostDetailPage extends StatelessWidget {
  final PostModel post;

  PostDetailPage({required this.post});

  final TextEditingController _commentController = TextEditingController();

  Future<void> _addComment(String content) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final comment = CommentModel(
        id: FirebaseFirestore.instance.collection('comments').doc().id,
        postId: post.id,
        userId: user.uid,
        content: content,
        createdDate: DateTime.now(),
      );
      await FirebaseFirestore.instance.collection('comments').doc(comment.id).set(comment.toMap());
    }
  }

  Future<void> _addReaction(String reaction) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final postRef = FirebaseFirestore.instance.collection('posts').doc(post.id);
      final postSnapshot = await postRef.get();
      if (postSnapshot.exists) {
        final post = PostModel.fromFirestore(postSnapshot);
        post.reactions[reaction] = (post.reactions[reaction] ?? 0) + 1;
        await postRef.update(post.toMap());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(post.imageUrls.first, fit: BoxFit.cover),
            SizedBox(height: 8),
            FutureBuilder<UserModel?>(
              future: AuthService().getUserProfile(post.userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error loading user data');
                } else if (snapshot.hasData && snapshot.data != null) {
                  UserModel user = snapshot.data!;
                  return Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: user.imgAvatar != null
                            ? NetworkImage(user.imgAvatar!)
                            : AssetImage('assets/default_avatar.png') as ImageProvider,
                      ),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.fullName ?? 'Guest',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            DateFormat('dd/MM/yyyy').format(post.createdDate),
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  );
                } else {
                  return Text('User not found');
                }
              },
            ),
            SizedBox(height: 8),
            Text(post.content, style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Row(
              children: [
                _buildReactionButton('like', Icons.thumb_up, post.reactions['like'] ?? 0),
                _buildReactionButton('love', Icons.favorite, post.reactions['love'] ?? 0),
                _buildReactionButton('haha', Icons.tag_faces, post.reactions['haha'] ?? 0),
                _buildReactionButton('wow', Icons.sentiment_very_satisfied, post.reactions['wow'] ?? 0),
                _buildReactionButton('sad', Icons.sentiment_dissatisfied, post.reactions['sad'] ?? 0),
                _buildReactionButton('angry', Icons.sentiment_very_dissatisfied, post.reactions['angry'] ?? 0),
              ],
            ),
            Divider(),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('comments')
                    .where('postId', isEqualTo: post.id)
                    .orderBy('createdDate', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final comments = snapshot.data!.docs.map((doc) => CommentModel.fromFirestore(doc)).toList();
                  return ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final comment = comments[index];
                      return FutureBuilder<UserModel?>(
                        future: AuthService().getUserProfile(comment.userId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error loading user data');
                          } else if (snapshot.hasData && snapshot.data != null) {
                            UserModel user = snapshot.data!;
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage: user.imgAvatar != null
                                    ? NetworkImage(user.imgAvatar!)
                                    : AssetImage('assets/default_avatar.png') as ImageProvider,
                              ),
                              title: Text(user.fullName ?? 'Guest'),
                              subtitle: Text(comment.content),
                              trailing: Text(DateFormat('dd/MM/yyyy').format(comment.createdDate)),
                            );
                          } else {
                            return Text('User not found');
                          }
                        },
                      );
                    },
                  );
                },
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: 'Add a comment...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      if (_commentController.text.isNotEmpty) {
                        _addComment(_commentController.text);
                        _commentController.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReactionButton(String reaction, IconData icon, int count) {
    return Row(
      children: [
        IconButton(
          icon: Icon(icon),
          onPressed: () => _addReaction(reaction),
        ),
        Text('$count'),
      ],
    );
  }
}