import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post.dart';

class PostService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add a new post
  Future<void> addPost(Post post) {
    return _db.collection('posts').add(post.toMap());
  }

  // Get all posts
  Stream<List<Post>> getPosts() {
    return _db
        .collection('posts')
        .orderBy('createdDate',
            descending: true) // Order by createdDate in descending order
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Post.fromFirestore(doc)).toList();
    });
  }

  // Update a post
  Future<void> updatePost(Post post) {
    // Update the lastModifiedDate to the current time
    post.lastModifiedDate = DateTime.now();
    return _db.collection('posts').doc(post.id).update(post.toMap());
  }

  // Delete a post
  Future<void> deletePost(String id) {
    return _db.collection('posts').doc(id).delete();
  }

  // Get a specific post by ID
  Future<Post?> getPostById(String id) async {
    DocumentSnapshot doc = await _db.collection('posts').doc(id).get();
    if (doc.exists) {
      return Post.fromFirestore(doc);
    }
    return null; // Return null if the post does not exist
  }
}
