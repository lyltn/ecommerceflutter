import 'package:ecommercettl/models/CommentModel.dart';
import 'package:ecommercettl/models/PostModel.dart';
import 'package:ecommercettl/models/ReactionModel.dart';
import 'package:ecommercettl/models/UserModel.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecommercettl/services/auth_service.dart';
import 'package:ecommercettl/services/comment_service.dart';
import 'package:ecommercettl/services/reaction_service.dart';
import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PostDetailPage extends StatefulWidget {
  final List<PostModel> posts;
  final int initialIndex;

  PostDetailPage(
      {required this.posts,
      required this.initialIndex,
      required PostModel post});

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  late final PageController _pageController;
  final CommentService _commentService = CommentService();
  final ReactionService _reactionService = ReactionService();
  ReactionModel? _userReaction;
  final TextEditingController _commentController = TextEditingController();
  int _currentImageIndex = 0;
  late String _currentPostId;
  late Future<UserModel?> _userProfileFuture;
  late Stream<DocumentSnapshot> _postStream;
  late Stream<List<CommentModel>> _commentsStream;
  bool _showAllComments = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
    _currentPostId = widget.posts[widget.initialIndex].id;
    _loadUserReaction(_currentPostId);
    _loadPostData(_currentPostId);
  }

  Future<void> _loadUserReaction(String postId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final reaction = await _reactionService.getUserReaction(postId, user.uid);
      setState(() => _userReaction = reaction);
    }
  }

  void _loadPostData(String postId) {
    _userProfileFuture =
        AuthService().getUserProfile(widget.posts[widget.initialIndex].userId);
    _postStream =
        FirebaseFirestore.instance.collection('posts').doc(postId).snapshots();
    _commentsStream = _commentService.getComments(postId);
  }

  Future<void> _addComment(String postId, String content) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final comment = CommentModel(
        id: FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc()
            .id,
        postId: postId,
        userId: user.uid,
        content: content,
        createdDate: DateTime.now(),
      );
      await _commentService.addComment(postId, comment);
    }
  }

  Future<void> _editComment(
      String postId, String commentId, String newContent) async {
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
          await reactionRef.delete();
          await _updateReactionCount(postId, reactionType, -1);
          setState(() => _userReaction = null);
        } else {
          await reactionRef.update({'type': reactionType});
          await _updateReactionCount(postId, currentReaction.type, -1);
          await _updateReactionCount(postId, reactionType, 1);
          setState(() {
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
        await reactionRef.set(ReactionModel(
          id: user.uid,
          postId: postId,
          userId: user.uid,
          type: reactionType,
          createdDate: DateTime.now(),
        ).toMap());
        await _updateReactionCount(postId, reactionType, 1);
        setState(() {
          _userReaction = ReactionModel(
            id: user.uid,
            postId: postId,
            userId: user.uid,
            type: reactionType,
            createdDate: DateTime.now(),
          );
        });
      }
    }
  }

  Future<void> _updateReactionCount(
      String postId, String reactionType, int change) async {
    final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);
    await postRef.update({
      reactionType == 'like' ? 'likeCount' : 'dislikeCount':
          FieldValue.increment(change),
    });
  }

  Future<UserModel?> _getUserData(String userId) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (doc.exists) {
      return UserModel.fromFirestore(doc);
    }
    return null;
  }

  String _formatDate(DateTime dateTime) {
    return DateFormat('hh:mm a, dd MMMM yyyy').format(dateTime);
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
          setState(() {
            _currentPostId = widget.posts[index].id;
            _loadUserReaction(_currentPostId);
            _loadPostData(_currentPostId);
          });
        },
        itemBuilder: (context, index) {
          final post = widget.posts[index];
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 700, // Image container height
                    child: Stack(
                      children: [
                        PageView.builder(
                          itemCount: post.imageUrls.length,
                          onPageChanged: (index) {
                            setState(() {
                              _currentImageIndex = index;
                            });
                          },
                          itemBuilder: (context, imageIndex) {
                            return _buildImage(post.imageUrls[imageIndex]);
                          },
                        ),
                        _buildImageIndicators(post.imageUrls.length),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),
                  FutureBuilder<UserModel?>(
                    future: _getUserData(post.userId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SpinKitFadingCircle(
                            color: Colors.blue, size: 50.0);
                      } else if (snapshot.hasError) {
                        return Text('Error loading user data');
                      } else if (snapshot.hasData && snapshot.data != null) {
                        UserModel user = snapshot.data!;
                        return Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: user.imgAvatar.isNotEmpty
                                  ? NetworkImage(user.imgAvatar)
                                  : AssetImage('assets/default_avatar.png')
                                      as ImageProvider,
                            ),
                            SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.username.isNotEmpty
                                      ? user.username
                                      : 'Anonymous',
                                  style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  DateFormat('dd/MM/yyyy')
                                      .format(post.createdDate),
                                  style:
                                      TextStyle(fontSize: 16, color: Colors.grey),
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
                  StreamBuilder<DocumentSnapshot>(
                    stream: _postStream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child:
                              SpinKitFadingCircle(color: Colors.blue, size: 50.0),
                        );
                      }
                      final postData = snapshot.data!;
                      final likeCount = postData['likeCount'] ?? 0;
                      final dislikeCount = postData['dislikeCount'] ?? 0;

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _buildReactionButton(
                              _currentPostId, 'like', Icons.thumb_up, likeCount),
                          SizedBox(width: 16),
                          _buildReactionButton(
                              _currentPostId, 'dislike', Icons.thumb_down, dislikeCount),
                        ],
                      );
                    },
                  ),
                  Divider(),
                  StreamBuilder<List<CommentModel>>(
                    stream: _commentsStream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: SpinKitFadingCircle(
                              color: Colors.blue, size: 50.0),
                        );
                      }
                      final comments = snapshot.data!;
                      final commentsToShow = _showAllComments
                          ? comments
                          : comments.take(2).toList();
                      return Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: commentsToShow.length,
                            itemBuilder: (context, index) {
                              final comment = commentsToShow[index];
                              return FutureBuilder<UserModel?>(
                                future: AuthService().getUserProfile(comment.userId),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: SpinKitFadingCircle(
                                          color: Colors.blue, size: 50.0),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Text('Error loading user data');
                                  } else if (snapshot.hasData &&
                                      snapshot.data != null) {
                                    UserModel user = snapshot.data!;
                                    return ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: user.imgAvatar.isNotEmpty
                                            ? NetworkImage(user.imgAvatar)
                                            : AssetImage('assets/default_avatar.png')
                                                as ImageProvider,
                                      ),
                                      title: Text(
                                        user.username.isNotEmpty
                                            ? user.username
                                            : 'Anonymous',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            comment.content,
                                            style: TextStyle(color: Colors.black),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            _formatDate(comment.createdDate),
                                            style: TextStyle(
                                                color: Colors.grey, fontSize: 12),
                                          ),
                                        ],
                                      ),
                                      trailing: comment.userId ==
                                              FirebaseAuth.instance.currentUser!.uid
                                          ? PopupMenuButton<String>(
                                              onSelected: (value) {
                                                if (value == 'edit') {
                                                  _showEditCommentDialog(comment);
                                                } else if (value == 'delete') {
                                                  _deleteComment(
                                                      _currentPostId, comment.id);
                                                }
                                              },
                                              itemBuilder: (context) => [
                                                PopupMenuItem(
                                                  value: 'edit',
                                                  child: Text('Edit'),
                                                ),
                                                PopupMenuItem(
                                                  value: 'delete',
                                                  child: Text('Delete'),
                                                ),
                                              ],
                                            )
                                          : null,
                                    );
                                  } else {
                                    return Text('User not found');
                                  }
                                },
                              );
                            },
                          ),
                          if (comments.length > 2 && !_showAllComments)
                          TextButton(
                          onPressed: () {
                            setState(() {
                            _showAllComments = true;
                            });
                          },
                          child: Text('Thêm'),
                          ),
                        if (comments.length > 2 && _showAllComments)
                          TextButton(
                          onPressed: () {
                            setState(() {
                            _showAllComments = false;
                            });
                          },
                          child: Text('Ẩn'),
                          ),
                        ],
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 5.0,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: _commentController,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                hintText: 'Viết bình luận ...',
                                hintStyle: TextStyle(color: Colors.grey),
                                filled: true,
                                fillColor: Colors.transparent,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 16.0),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.send, color: Colors.blue),
                          onPressed: () {
                            if (_commentController.text.isNotEmpty) {
                              _addComment(_currentPostId,
                                  _commentController.text);
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
        },
      ),
    );
  }

  void _showEditCommentDialog(CommentModel comment) {
    final TextEditingController _editCommentController =
        TextEditingController(text: comment.content);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Comment'),
          content: TextField(
            controller: _editCommentController,
            decoration: InputDecoration(hintText: 'Enter your comment'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _editComment(
                    _currentPostId, comment.id, _editCommentController.text);
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
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
                color: Colors.blue,
                size: 50.0,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Center(child: Icon(Icons.error));
        },
      ),
    );
  }

  Widget _buildImageIndicators(int imageCount) {
    return Positioned(
      bottom: 10,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          imageCount,
          (index) => Container(
            width: 8.0,
            height: 8.0,
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 3.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentImageIndex == index
                  ? const Color.fromARGB(
                      255, 20, 155, 24) // Active indicator color
                  : Colors.grey, // Inactive indicator color
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReactionButton(
      String postId, String reactionType, IconData icon, int count) {
    return GestureDetector(
      onTap: () => _addOrUpdateReaction(postId, reactionType),
      child: Row(
        children: [
          Icon(
            icon,
            color:
                _userReaction?.type == reactionType ? Colors.blue : Colors.grey,
          ),
          SizedBox(width: 4),
          Text(count.toString()),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _commentController.dispose();
    super.dispose();
  }
}