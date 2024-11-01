import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommercettl/models/CommentModel.dart';

class CommentService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add a new comment
  Future<void> addComment(String postId, CommentModel comment) {
    return _db
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(comment.id)
        .set(comment.toMap());
  }

  // Update an existing comment
  Future<void> updateComment(String postId, CommentModel comment) {
    return _db
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(comment.id)
        .update(comment.toMap());
  }

  // Delete a comment
  Future<void> deleteComment(String postId, String commentId) {
    return _db
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .delete();
  }

  // Get comments for a post
  Stream<List<CommentModel>> getComments(String postId) {
    return _db
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('createdDate', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => CommentModel.fromFirestore(doc)).toList();
    });
  }
  Future<List<CommentModel>> fetchComments(String postId) async {
    try {
      final querySnapshot = await _db
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .orderBy('createdDate', descending: true) // Sort comments by creation date
          .get();

      return querySnapshot.docs
          .map((doc) => CommentModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      print("Error fetching comments: $e");
      return []; // Return an empty list in case of error
    }
  }
}