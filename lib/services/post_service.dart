import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:ecommercettl/models/PostModel.dart';

class PostService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Get all posts
  Stream<List<PostModel>> getPosts() {
    return _db
        .collection('posts')
        .orderBy('createdDate', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => PostModel.fromFirestore(doc)).toList();
    });
  }

  // Create a new post
  Future<void> createPost(PostModel post) {
    return _db.collection('posts').doc(post.id).set(post.toMap());
  }

  // Update a post
  Future<void> updatePost(PostModel post) {
    post.lastModifiedDate = DateTime.now();
    return _db.collection('posts').doc(post.id).update(post.toMap());
  }

  // Delete a post
  Future<void> deletePost(String id) {
    return _db.collection('posts').doc(id).delete();
  }

  // Upload an image to Firebase Storage
  Future<String> uploadImage(File image) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageRef = _storage.ref().child('posts/$fileName');
    UploadTask uploadTask = storageRef.putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }
}