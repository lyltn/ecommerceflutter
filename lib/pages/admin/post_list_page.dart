import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommercettl/services/post_services.dart';
import 'package:flutter/material.dart';

import 'post_detail_page.dart';

class PostListPage extends StatefulWidget {
  const PostListPage({super.key});

  @override
  State<PostListPage> createState() => _PostListPage();
}

class _PostListPage extends State<PostListPage> {
  @override
  Widget build(BuildContext context) {
    final PostService postService = PostService();

    void troll(){

      postService.addPost(
        'published', // status: could be 'published', 'draft', etc.
        'Flutter for Beginners', // postTitle
        'https://scontent.fsgn2-7.fna.fbcdn.net/v/t1.15752-9/462553509_1083234890184825_8250204551693577170_n.jpg?_nc_cat=108&ccb=1-7&_nc_sid=9f807c&_nc_eui2=AeFbcnwX35yLGYzqW-jENC7IFCtZ-YsWcEAUK1n5ixZwQBQisL_ONV22NlhkGheU-X69s8Ysb7pVU2fL8khv2Zbb&_nc_ohc=ZKcAqFEetoYQ7kNvgEkex0r&_nc_zt=23&_nc_ht=scontent.fsgn2-7.fna&_nc_gid=AUxR3BJAwfKZIOvlESezXev&oh=03_Q7cD1QG35SlETMI3r6hQducN2Asuv3AUYrw4KeObJL9l7JJn2A&oe=673C6E4D', // postImgUrl
        'https://example.com/flutter-for-beginners', // postLink
        'user123', // userId (could be any user identifier or user ID)
      );

    }

    return Scaffold(
      appBar: AppBar(title: const Text('Post list')),
      floatingActionButton: FloatingActionButton(onPressed: troll),
      body: StreamBuilder<QuerySnapshot>(
        stream: postService.getPostsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (snapshot.hasData) {
            List postList = snapshot.data!.docs;

            return ListView.builder(
              itemCount: postList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = postList[index];
                Map<String, dynamic> data =
                document.data() as Map<String, dynamic>;

                return ListTile(
                  title: Text(data['postTitle']),
                  trailing: IconButton(
                    onPressed: () => postService.deletePost(document.id),
                    icon: const Icon(Icons.delete),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PostDetailPage(post: document),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return const Text('No posts found');
          }
        },
      ),
    );
  }
}

