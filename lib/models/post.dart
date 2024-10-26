import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String id;
  String userId;
  String content;
  List<String> imageUrls;
  String link;
  bool status;
  DateTime createdDate;
  DateTime lastModifiedDate;

  Post({
    required this.id,
    required this.userId,
    required this.content,
    required this.imageUrls,
    required this.link,
    this.status = true,
    required this.createdDate,
    required this.lastModifiedDate,
  });

  // Convert a Post object into a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'content': content,
      'imageUrls': imageUrls,
      'link': link,
      'status': status,
      'createdDate': createdDate.toIso8601String(),
      'lastModifiedDate': lastModifiedDate.toIso8601String(),
    };
  }

  // Create a Post object from a Firestore document snapshot
  factory Post.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Post(
      id: doc.id,
      userId: data['userId'] ?? '',
      content: data['content'] ?? '',
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      link: data['link'] ?? '',
      status: data['status'] ?? true,
      createdDate: DateTime.parse(data['createdDate']),
      lastModifiedDate: DateTime.parse(data['lastModifiedDate']),
    );
  }
}
