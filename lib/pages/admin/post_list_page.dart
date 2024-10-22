import 'package:flutter/material.dart';
import '/models/post.dart';
import '/services/post_service.dart';
import 'components/add_post_page.dart';
import 'components/post_card.dart';
import 'post_detail_page.dart';

class PostListPage extends StatefulWidget {
  const PostListPage({super.key});

  @override
  State<PostListPage> createState() => _PostListPageState();
}

class _PostListPageState extends State<PostListPage> {
  final PostService postService = PostService();

  void _navigateToAddPostPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddPostPage(postService: postService),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
      ),
      body: StreamBuilder<List<Post>>(
        stream: postService.getPosts(), // Stream of posts
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading posts'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No posts available'));
          }

          final posts = snapshot.data!; // Get the posts

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];

              return PostCard(
                post: post, // Pass the post to the PostCard widget
                onDelete: () {
                  // Handle delete logic
                  postService.deletePost(post.id);
                },
                onTap: () {
                  // Navigate to post details page
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
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddPostPage(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
