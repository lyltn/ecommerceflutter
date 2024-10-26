import 'package:ecommercettl/pages/admin/post_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommercettl/services/post_services.dart';
import 'Components/post_card.dart';

class PostListPage extends StatefulWidget {
  const PostListPage({super.key});

  @override
  State<PostListPage> createState() => _PostListPageState();
}

class _PostListPageState extends State<PostListPage> {
  final PostService postService = PostService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posts')),
      body: StreamBuilder<QuerySnapshot>(
        stream: postService
            .getPostsStream(), // Make sure this stream is implemented in PostService
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            List<DocumentSnapshot> postList = snapshot.data!.docs;

            return ListView.builder(
              itemCount: postList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot post = postList[index];
                Map<String, dynamic> data =
                    post.data() as Map<String, dynamic>;

                String username = data['userId'];
                // String imageUrl =
                //     data['postImgUrl'] != null && data['postImgUrl'].isNotEmpty
                //         ? data['postImgUrl'][0] // Get the first image
                //         : ''; // Default or placeholder image
                String imageUrl = data['postImgUrl'];
                String postText = data['postTitle'];

                return PostCard(
                  username: username,
                  imageUrl: imageUrl,
                  postText: postText,
                  onDelete: () {
                    postService.deletePost(post
                        .id); // Call your delete method from PostService
                  },
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PostDetailPage(post: post),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return const Center(child: Text('No posts found'));
          }
        },
      ),
    );
  }
}
