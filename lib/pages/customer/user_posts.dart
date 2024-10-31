import 'package:ecommercettl/models/CommentModel.dart';
import 'package:ecommercettl/models/ReactionModel.dart';
import 'package:ecommercettl/pages/customer/create_post.dart';
import 'package:ecommercettl/pages/customer/edit_post.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecommercettl/models/PostModel.dart';
import 'package:ecommercettl/models/UserModel.dart';
import 'package:ecommercettl/services/post_service.dart';
import 'package:ecommercettl/services/auth_service.dart';
import 'package:ecommercettl/services/comment_service.dart';
import 'package:ecommercettl/services/reaction_service.dart';
import 'package:intl/intl.dart';

class UserPostsPage extends StatefulWidget {
  const UserPostsPage({super.key});

  @override
  State<UserPostsPage> createState() => _UserPostsPageState();
}

class _UserPostsPageState extends State<UserPostsPage> {
  final PostService _postService = PostService();
  final AuthService _authService = AuthService();
  final CommentService _commentService = CommentService();
  final ReactionService _reactionService = ReactionService();
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  Future<UserModel?> _getUserData(String userId) async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (doc.exists) {
      return UserModel.fromFirestore(doc);
    }
    return null;
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
              // Update the local post model
            } else if (reactionType == 'dislike') {
              // Update the local post model
            }
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
              // Update the local post model
            } else if (currentReaction.type == 'dislike') {
              // Update the local post model
            }
            if (reactionType == 'like') {
              // Update the local post model
            } else if (reactionType == 'dislike') {
              // Update the local post model
            }
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
            // Update the local post model
          } else if (reactionType == 'dislike') {
            // Update the local post model
          }
        });
      }
    }
  }

  Widget _buildReactionButton(String postId, String reactionType, IconData icon, int count) {
    return Row(
      children: [
        IconButton(
          icon: Icon(icon),
          onPressed: () async {
            await _addOrUpdateReaction(postId, reactionType);
          },
        ),
        Text('$count'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bài viết của tôi'),
        actions: [
          TextButton(
            onPressed: () async {
              bool? result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreatePostPage()),
              );
              if (result == true) {
                setState(() {});
              }
            },
            child: Text(
              'Thêm bài viết',
              style: TextStyle(color: Colors.black),
            ),
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<PostModel>>(
        stream: _postService.getPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Không có bài viết nào.'));
          }

          List<PostModel> posts = snapshot.data!.where((post) => post.userId == userId).toList();
          if (posts.isEmpty) {
            return Center(child: Text('Không có bài viết nào.'));
          }

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              PostModel post = posts[index];
              return FutureBuilder<UserModel?>(
                future: _getUserData(post.userId),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (userSnapshot.hasError) {
                    return Center(child: Text('Error: ${userSnapshot.error}'));
                  } else if (!userSnapshot.hasData) {
                    return Center(child: Text('Không tìm thấy thông tin người dùng.'));
                  }

                  UserModel? user = userSnapshot.data;
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: user?.imgAvatar != null
                                    ? NetworkImage(user!.imgAvatar!)
                                    : AssetImage('assets/default_avatar.png') as ImageProvider,
                                radius: 25,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user?.username ?? 'Guest',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      DateFormat('dd/MM/yyyy').format(post.createdDate),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuButton<String>(
                                onSelected: (value) async {
                                  if (value == 'edit') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => EditPostPage(post: post)),
                                    );
                                  } else if (value == 'delete') {
                                    await _postService.deletePost(post.id);
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
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          if (post.imageUrls.isNotEmpty)
                            Image.network(
                              post.imageUrls.first,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 200,
                            ),
                          SizedBox(height: 10),
                          Text(post.content),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              _buildReactionButton(post.id, 'like', Icons.thumb_up, post.likeCount),
                              _buildReactionButton(post.id, 'dislike', Icons.thumb_down, post.dislikeCount),
                            ],
                          ),
                          Divider(),
                          StreamBuilder<List<CommentModel>>(
                            stream: _commentService.getComments(post.id),
                            builder: (context, commentSnapshot) {
                              if (!commentSnapshot.hasData) {
                                return Center(child: CircularProgressIndicator());
                              }
                              final comments = commentSnapshot.data!;
                              if (comments.length <= 2) {
                                return Column(
                                  children: comments.map((comment) {
                                    return FutureBuilder<UserModel?>(
                                      future: _authService.getUserProfile(comment.userId),
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
                                            trailing: Text(DateFormat('dd/MM/yyyy').format(comment.createdDate)),
                                          );
                                        } else {
                                          return Text('User not found');
                                        }
                                      },
                                    );
                                  }).toList(),
                                );
                              } else {
                                return Column(
                                  children: [
                                    ...comments.take(2).map((comment) {
                                      return FutureBuilder<UserModel?>(
                                        future: _authService.getUserProfile(comment.userId),
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
                                              trailing: Text(DateFormat('dd/MM/yyyy').format(comment.createdDate)),
                                            );
                                          } else {
                                            return Text('User not found');
                                          }
                                        },
                                      );
                                    }).toList(),
                                    TextButton(
                                      onPressed: () {
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return ListView.builder(
                                              itemCount: comments.length,
                                              itemBuilder: (context, index) {
                                                final comment = comments[index];
                                                return FutureBuilder<UserModel?>(
                                                  future: _authService.getUserProfile(comment.userId),
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
                                        );
                                      },
                                      child: Text('Xem thêm bình luận'),
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}