import 'package:cloud_firestore/cloud_firestore.dart';

class PostService {
  final CollectionReference posts =
      FirebaseFirestore.instance.collection('posts');

//   Create--by zungcao
  Future<void> addPost(dynamic status, dynamic postTitle, dynamic postImgUrl,
      dynamic postLink, dynamic userId) {
    return posts.add({
      'postTitle': postTitle,
      'postImgUrl': postImgUrl,
      'postDate': Timestamp.now(),
      'postLink': postLink,
      'userId': userId,
      'status': status,
    });
  }

//   Read--by zungcao
  Stream<QuerySnapshot> getPostsStream() {
    final postsStream =
    posts.orderBy('postDate', descending: true).snapshots();
    return postsStream;
  }

//   Delete--by zungcao
  Future<void> deletePost(String docId) {
    return posts.doc(docId).delete();
  }
}
