import 'package:flutter/material.dart';
import '/models/post.dart';
import '/services/post_service.dart';
import 'components/post_dialog.dart';
import 'post_detail_page.dart';

class PostListPage extends StatefulWidget {
  const PostListPage({super.key});

  @override
  State<PostListPage> createState() => _PostListPageState();
}

class _PostListPageState extends State<PostListPage> {
  final PostService postService = PostService();

  void _showAddPostDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return PostDialog(postService: postService);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Posts')),
      ),
      body: StreamBuilder<List<Post>>(
        stream: postService.getPosts(), // Fetch the posts stream directly
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final posts = snapshot.data ?? [];

          if (posts.isEmpty) {
            return const Center(child: Text('No posts available.'));
          }

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return ListTile(
                title: Text(post.content),
                subtitle: Text('Posted by: ${post.userId}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await postService
                        .deletePost(post.id); // Directly delete the post
                  },
                ),
                onTap: () {
                  // Navigate to post details or another page
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
          _showAddPostDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
