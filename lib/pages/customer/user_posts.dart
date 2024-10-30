import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecommercettl/models/PostModel.dart';
import 'package:ecommercettl/models/UserModel.dart';
import 'package:ecommercettl/services/post_service.dart';
import 'package:ecommercettl/services/auth_service.dart';
import 'package:ecommercettl/pages/customer/post_detail.dart';
import 'package:ecommercettl/pages/customer/edit_post.dart';
import 'package:ecommercettl/pages/customer/create_post.dart';
import 'package:intl/intl.dart';

class UserPostsPage extends StatefulWidget {
  const UserPostsPage({super.key});

  @override
  State<UserPostsPage> createState() => _UserPostsPageState();
}

class _UserPostsPageState extends State<UserPostsPage> {
  final PostService _postService = PostService();
  final AuthService _authService = AuthService();
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  Future<UserModel?> _getUserData(String userId) async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (doc.exists) {
      return UserModel.fromFirestore(doc);
    }
    return null;
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
                                      user?.fullName ?? 'Guest',
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