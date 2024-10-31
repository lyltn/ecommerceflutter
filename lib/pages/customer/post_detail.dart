import 'package:ecommercettl/models/CommentModel.dart';
import 'package:ecommercettl/models/PostModel.dart';
import 'package:ecommercettl/models/ReactionModel.dart';
import 'package:ecommercettl/models/UserModel.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecommercettl/services/auth_service.dart';
import 'package:ecommercettl/services/comment_service.dart';
import 'package:ecommercettl/services/post_service.dart';
import 'package:ecommercettl/services/reaction_service.dart';
import 'package:intl/intl.dart';

class PostDetailPage extends StatefulWidget {
  final List<PostModel> posts;
  final int initialIndex;

  PostDetailPage({required this.posts, required this.initialIndex, required PostModel post});

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  PageController _pageController;
  final CommentService _commentService = CommentService();
  final PostService _postService = PostService();
  final ReactionService _reactionService = ReactionService();
  ReactionModel? _userReaction;
  final TextEditingController _commentController = TextEditingController();

  _PostDetailPageState() : _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
    _loadUserReaction(widget.posts[widget.initialIndex].id);
  }

  Future<void> _loadUserReaction(String postId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final reaction = await _reactionService.getUserReaction(postId, user.uid);
      setState(() {
        _userReaction = reaction;
      });
    }
  }

  Future<void> _addComment(String postId, String content) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final comment = CommentModel(
        id: FirebaseFirestore.instance.collection('posts').doc(postId).collection('comments').doc().id,
        postId: postId,
        userId: user.uid,
        content: content,
        createdDate: DateTime.now(),
      );
      await _commentService.addComment(postId, comment);
    }
  }
  Future<void> _editComment(String postId, CommentModel comment, String newContent) async {
    final updatedComment = CommentModel(
      id: comment.id,
      postId: postId,
      userId: comment.userId,
      content: newContent,
      createdDate: comment.createdDate,
    );
    await _commentService.updateComment(postId, updatedComment);
  }
  Future<void> _deleteComment(String postId, String commentId) async {
    await _commentService.deleteComment(postId, commentId);
  }
  

  Future<void> _addOrUpdateReaction(String postId, String reactionType) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final reactionRef = FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('reactions')
          .doc(user.uid);

      final reactionSnapshot = await reactionRef.get();

      if (reactionSnapshot.exists) {
        final currentReaction = ReactionModel.fromFirestore(reactionSnapshot);

        if (currentReaction.type == reactionType) {
          // Remove the reaction if it is the same as the current reaction
          await reactionRef.delete();

          // Update the reaction count in Firestore
          final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);
          await postRef.update({
            if (reactionType == 'like') 'likeCount': FieldValue.increment(-1),
            if (reactionType == 'dislike') 'dislikeCount': FieldValue.increment(-1),
          });

          // Update the local state to reflect the removed reaction
          setState(() {
            if (reactionType == 'like') {
              widget.posts[widget.initialIndex].likeCount -= 1;
            } else if (reactionType == 'dislike') {
              widget.posts[widget.initialIndex].dislikeCount -= 1;
            }
            _userReaction = null;
          });
        } else {
          // Update the reaction if it is different from the current reaction
          await reactionRef.update({'type': reactionType});

          // Update the reaction count in Firestore
          final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);
          await postRef.update({
            if (currentReaction.type == 'like') 'likeCount': FieldValue.increment(-1),
            if (currentReaction.type == 'dislike') 'dislikeCount': FieldValue.increment(-1),
            if (reactionType == 'like') 'likeCount': FieldValue.increment(1),
            if (reactionType == 'dislike') 'dislikeCount': FieldValue.increment(1),
          });

          // Update the local state to reflect the new reaction
          setState(() {
            if (currentReaction.type == 'like') {
              widget.posts[widget.initialIndex].likeCount -= 1;
            } else if (currentReaction.type == 'dislike') {
              widget.posts[widget.initialIndex].dislikeCount -= 1;
            }
            if (reactionType == 'like') {
              widget.posts[widget.initialIndex].likeCount += 1;
            } else if (reactionType == 'dislike') {
              widget.posts[widget.initialIndex].dislikeCount += 1;
            }
            _userReaction = ReactionModel(
              id: user.uid,
              postId: postId,
              userId: user.uid,
              type: reactionType,
              createdDate: DateTime.now(),
            );
          });
        }
      } else {
        // Add a new reaction if no reaction exists
        final reaction = ReactionModel(
          id: user.uid,
          postId: postId,
          userId: user.uid,
          type: reactionType,
          createdDate: DateTime.now(),
        );

        await reactionRef.set(reaction.toMap());

        // Update the reaction count in Firestore
        final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);
        await postRef.update({
          if (reactionType == 'like') 'likeCount': FieldValue.increment(1),
          if (reactionType == 'dislike') 'dislikeCount': FieldValue.increment(1),
        });

        // Update the local state to reflect the new reaction
        setState(() {
          if (reactionType == 'like') {
            widget.posts[widget.initialIndex].likeCount += 1;
          } else if (reactionType == 'dislike') {
            widget.posts[widget.initialIndex].dislikeCount += 1;
          }
          _userReaction = reaction;
        });
      }
    }
  }

   void _showEditCommentDialog(String postId, CommentModel comment) {
    final TextEditingController _editCommentController = TextEditingController(text: comment.content);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Comment'),
          content: TextField(
            controller: _editCommentController,
            decoration: InputDecoration(hintText: 'Enter new comment'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await _editComment(postId, comment, _editCommentController.text);
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bài viết'),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.posts.length,
        onPageChanged: (index) {
          _loadUserReaction(widget.posts[index].id);
        },
        itemBuilder: (context, index) {
          final post = widget.posts[index];
          return Padding(
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
                                user.username ?? 'Guest',
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
                    _buildReactionButton(post.id, 'like', Icons.thumb_up, post.likeCount),
                    _buildReactionButton(post.id, 'dislike', Icons.thumb_down, post.dislikeCount),
                  ],
                ),
                Divider(),
                Expanded(
                  child: StreamBuilder<List<CommentModel>>(
                    stream: _commentService.getComments(post.id),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }
                      final comments = snapshot.data!;
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
                                  title: Text(user.username ?? 'Guest'),
                                  subtitle: Text(comment.content),
                                  trailing: comment.userId == FirebaseAuth.instance.currentUser!.uid
                                      ? PopupMenuButton<String>(
                                          onSelected: (value) async {
                                            if (value == 'edit') {
                                              _showEditCommentDialog(post.id, comment);
                                            } else if (value == 'delete') {
                                              await _deleteComment(post.id, comment.id);
                                            }
                                          },
                                          itemBuilder: (BuildContext context) {
                                            return {'edit', 'delete'}.map((String choice) {
                                              return PopupMenuItem<String>(
                                                value: choice,
                                                child: Text(choice == 'edit' ? 'Chỉnh sửa' : 'Xóa'),
                                              );
                                            }).toList();
                                          },
                                        )
                                      : null,
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
                            hintText: 'Thêm bình luận...',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {
                          if (_commentController.text.isNotEmpty) {
                            _addComment(post.id, _commentController.text);
                            _commentController.clear();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildReactionButton(String postId, String reactionType, IconData icon, int count) {
    return Row(
      children: [
        IconButton(
          icon: Icon(icon),
          color: _userReaction?.type == reactionType ? Colors.blue : Colors.grey,
          onPressed: () async {
            await _addOrUpdateReaction(postId, reactionType);
          },
        ),
        Text('$count'),
      ],
    );
  }
}