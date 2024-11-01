import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecommercettl/models/UserModel.dart';
import 'package:ecommercettl/models/PostModel.dart';
import 'package:ecommercettl/services/auth_service.dart';
import 'package:ecommercettl/services/post_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:ecommercettl/pages/customer/update_profile.dart';
import 'package:ecommercettl/pages/customer/user_posts.dart';
import 'package:ecommercettl/pages/customer/post_detail.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final PostService _postService = PostService();
  final AuthService _authService = AuthService();
  UserModel? userModel;
  File? _image;
  String searchQuery = '';
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    try {
      userModel = await _authService.getUserProfile(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      print('Error fetching user profile: $e');
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_image != null) {
      // Upload image to Firebase Storage and get the download URL
      String imageUrl = await _postService.uploadImage(_image!);

      // Create a new post with the image URL
      PostModel newPost = PostModel(
        id: FirebaseFirestore.instance.collection('posts').doc().id,
        userId: FirebaseAuth.instance.currentUser!.uid,
        content: '',
        imageUrls: [imageUrl],
        link: '',
        status: true,
        createdDate: DateTime.now(),
        lastModifiedDate: DateTime.now(),
      );

      // Save the post to Firestore
      await _postService.createPost(newPost);

      // Clear the selected image
      setState(() {
        _image = null;
      });
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 3), () {
      setState(() {
        searchQuery = query;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bài Viết'),
        backgroundColor: const Color(0xFF15A362),
      ),
      body: Column(
        children: [
          if (userModel != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Navigate to user posts page
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => UserPostsPage()),
                          );
                        },
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: userModel!.imgAvatar != null
                              ? NetworkImage(userModel!.imgAvatar!)
                              : AssetImage('assets/default_avatar.png') as ImageProvider,
                        ),
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userModel!.username ?? 'Guest',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Container(
                            width: 200,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: 'Tìm kiếm',
                                labelStyle: TextStyle(color: const Color.fromARGB(255, 206, 206, 206)),
                                border: InputBorder.none,
                                prefixIcon: Icon(Icons.search, size: 20),
                                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                              ),
                              onChanged: _onSearchChanged,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          Expanded(
            child: StreamBuilder<List<PostModel>>(
              stream: _postService.getPosts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Không có bài viết nào.'));
                }

                List<PostModel> posts = snapshot.data!;
                if (searchQuery.isNotEmpty) {
                  posts = posts.where((post) => post.content.contains(searchQuery)).toList();
                }
                if (posts.isEmpty) {
                  return Center(child: Text('Không có bài viết nào.'));
                }
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    PostModel post = posts[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PostDetailPage(
                              post: post,
                              posts: posts,
                              initialIndex: index,
                            ),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: FutureBuilder<void>(
                          future: Future.value(), // Replace with your actual future
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
                            } else {
                              return Image.network(
                                post.imageUrls.first,
                                fit: BoxFit.cover,
                                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress.expectedTotalBytes != null
                                            ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                            : null,
                                      ),
                                    );
                                  }
                                },
                                errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                  return Center(child: Text('Error loading image'));
                                },
                              );
                            }
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
