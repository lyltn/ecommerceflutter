import 'package:ecommercettl/models/CommentModel.dart';
import 'package:ecommercettl/models/ReactionModel.dart';
import 'package:ecommercettl/pages/customer/create_post.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecommercettl/models/PostModel.dart';
import 'package:ecommercettl/models/UserModel.dart';
import 'package:ecommercettl/services/auth_service.dart';
import 'package:ecommercettl/services/comment_service.dart';
import 'package:ecommercettl/services/reaction_service.dart';
import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ecommercettl/pages/customer/edit_post.dart'; // Import EditPostPage

class UserPostsPage extends StatefulWidget {
  const UserPostsPage({super.key});

  @override
  State<UserPostsPage> createState() => _UserPostsPageState();
}

class _UserPostsPageState extends State<UserPostsPage> {
  final AuthService _authService = AuthService();
  final CommentService _commentService = CommentService();
  final ReactionService _reactionService = ReactionService();
  String? userId;

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser?.uid;
  }

  Stream<List<PostModel>> _getUserPosts(String userId) {
    return FirebaseFirestore.instance
        .collection('posts')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => PostModel.fromFirestore(doc)).toList());
  }

  Future<void> _editPost(String postId, String newContent) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .update({'content': newContent});
  }

  Future<void> _deletePost(String postId) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bài viết của tôi'),
        actions: [
          TextButton.icon(
            label: Text('Thêm bài viết', style: TextStyle(color: Colors.white)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreatePostPage()),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Color(0xFF15A362), // Button background color
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Padding for the button
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30), // Rounded corners
              ),
            ),
          ),
        ],
      ),
      body: userId != null
          ? StreamBuilder<List<PostModel>>(
              stream: _getUserPosts(userId!),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: SpinKitFadingCircle(
                      color: Colors.deepPurple,
                      size: 50.0,
                    ),
                  );
                }
                final posts = snapshot.data!;
                if (posts.isEmpty) {
                  return Center(child: Text('Không có bài viết nào'));
                }
                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return PostCard(
                      post: post,
                      commentService: _commentService,
                      onEditPost: _editPost,
                      onDeletePost: _deletePost,
                    );
                  },
                );
              },
            )
          : Center(child: Text('User not logged in')),
    );
  }
}

class PostCard extends StatefulWidget {
  final PostModel post;
  final CommentService commentService;
  final Future<void> Function(String postId, String newContent) onEditPost;
  final Future<void> Function(String postId) onDeletePost;

  const PostCard({
    required this.post,
    required this.commentService,
    required this.onEditPost,
    required this.onDeletePost,
    Key? key,
  }) : super(key: key);

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int _currentImageIndex = 0;
  late Future<UserModel?> _userDataFuture;

  @override
  void initState() {
    super.initState();
    _userDataFuture = _fetchUserData(widget.post.userId);
  }

  Future<UserModel?> _fetchUserData(String userId) async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (doc.exists) {
      return UserModel.fromFirestore(doc);
    }
    return null;
  }

  Future<void> _editComment(String postId, String commentId, String newContent) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .update({'content': newContent});
  }

  Future<void> _deleteComment(String postId, String commentId) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<UserModel?>(
              future: _userDataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SpinKitFadingCircle(
                    color: Colors.deepPurple,
                    size: 50.0,
                  );
                } else if (snapshot.hasError) {
                  return Text('Error loading user data: ${snapshot.error}');
                } else if (snapshot.hasData && snapshot.data != null) {
                  UserModel user = snapshot.data!;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: user.imgAvatar.isNotEmpty
                                ? NetworkImage(user.imgAvatar)
                                : AssetImage('assets/default_avatar.png') as ImageProvider,
                          ),
                          SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.username.isNotEmpty ? user.username : 'Anonymous',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                DateFormat('dd/MM/yyyy').format(widget.post.createdDate),
                                style: TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.deepPurple),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditPostPage(post: widget.post),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              widget.onDeletePost(widget.post.id);
                            },
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
            Text(widget.post.content, style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Container(
              height: 200,
              child: Stack(
                children: [
                  PageView.builder(
                    itemCount: widget.post.imageUrls.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentImageIndex = index;
                      });
                    },
                    itemBuilder: (context, imageIndex) {
                      return _buildImage(widget.post.imageUrls[imageIndex]);
                    },
                  ),
                  _buildImageIndicators(widget.post.imageUrls.length),
                ],
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildReactionButton(widget.post.id, 'like', Icons.thumb_up, widget.post.likeCount),
                SizedBox(width: 16),
                _buildReactionButton(widget.post.id, 'dislike', Icons.thumb_down, widget.post.dislikeCount),
              ],
            ),
            Divider(),
            _buildCommentsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: Container(
              width: 50,
              height: 50,
              child: SpinKitFadingCircle(
                color: Colors.deepPurple,
                size: 50.0,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Center(child: Icon(Icons.error, color: Colors.red));
        },
      ),
    );
  }

  Widget _buildImageIndicators(int imageCount) {
    return Positioned(
      bottom: 16,
      left: 16,
      child: Row(
        children: List.generate(imageCount, (index) {
          return AnimatedContainer(
            duration: Duration(milliseconds: 300),
            margin: EdgeInsets.symmetric(horizontal: 4),
            height: 8,
            width: 8,
            decoration: BoxDecoration(
              color: _currentImageIndex == index ? const Color.fromARGB(255, 20, 155, 24) : Colors.grey,
              borderRadius: BorderRadius.circular(8),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildReactionButton(String postId, String reactionType, IconData icon, int count) {
    return GestureDetector(
      onTap: () {
        // Handle reaction logic here
        print('Reacted to post $postId with $reactionType');
        // Call your reaction service to handle this
      },
      child: Row(
        children: [
          Icon(icon, color: const Color.fromARGB(255, 129, 129, 129)),
          SizedBox(width: 4),
          Text(count.toString(), style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildCommentsSection() {
    return FutureBuilder<List<CommentModel>>(
      future: widget.commentService.fetchComments(widget.post.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SpinKitFadingCircle(
            color: Colors.deepPurple,
            size: 50.0,
          );
        } else if (snapshot.hasError) {
          return Text('Error loading comments: ${snapshot.error}');
        } else if (snapshot.hasData && snapshot.data != null) {
          final comments = snapshot.data!;
          return Column(
            children: comments.map((comment) {
              return FutureBuilder<UserModel?>(
                future: _fetchUserData(comment.userId),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return SpinKitFadingCircle(
                      color: Colors.deepPurple,
                      size: 50.0,
                    );
                  } else if (userSnapshot.hasError) {
                    return ListTile(
                      title: Text(comment.content),
                      subtitle: Text(DateFormat('dd/MM/yyyy').format(comment.createdDate)),
                      trailing: comment.userId == FirebaseAuth.instance.currentUser!.uid
                          ? IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _deleteComment(widget.post.id, comment.id);
                              },
                            )
                          : null,
                    );
                  } else if (userSnapshot.hasData && userSnapshot.data != null) {
                    UserModel user = userSnapshot.data!;
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: user.imgAvatar.isNotEmpty
                            ? NetworkImage(user.imgAvatar)
                            : AssetImage('assets/default_avatar.png') as ImageProvider,
                      ),
                      title: Text(user.username.isNotEmpty ? user.username : 'Anonymous'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(comment.content),
                          Text(DateFormat('dd/MM/yyyy').format(comment.createdDate)),
                        ],
                      ),
                      trailing: comment.userId == FirebaseAuth.instance.currentUser!.uid
                          ? IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _deleteComment(widget.post.id, comment.id);
                              },
                            )
                          : null,
                    );
                  }
                  return Container();
                },
              );
            }).toList(),
          );
        } else {
          return Text('No comments found.');
        }
      },
    );
  }
}