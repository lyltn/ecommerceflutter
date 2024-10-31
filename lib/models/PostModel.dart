import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String id;
  String userId;
  String content;
  List<String> imageUrls;
  String link;
  bool status;
  DateTime createdDate;
  DateTime lastModifiedDate;
  int likeCount;
  int dislikeCount; // Change loveCount to dislikeCount

  PostModel({
    required this.id,
    required this.userId,
    required this.content,
    required this.imageUrls,
    required this.link,
    this.status = true,
    required this.createdDate,
    required this.lastModifiedDate,
    this.likeCount = 0,
    this.dislikeCount = 0, // Change loveCount to dislikeCount
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'content': content,
      'imageUrls': imageUrls,
      'link': link,
      'status': status,
      'createdDate': createdDate.toIso8601String(),
      'lastModifiedDate': lastModifiedDate.toIso8601String(),
      'likeCount': likeCount,
      'dislikeCount': dislikeCount, // Change loveCount to dislikeCount
    };
  }

  factory PostModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PostModel(
      id: doc.id,
      userId: data['userId'],
      content: data['content'],
      imageUrls: List<String>.from(data['imageUrls']),
      link: data['link'],
      status: data['status'] ?? true,
      createdDate: DateTime.parse(data['createdDate']),
      lastModifiedDate: DateTime.parse(data['lastModifiedDate']),
      likeCount: data['likeCount'] ?? 0,
      dislikeCount: data['dislikeCount'] ?? 0, // Change loveCount to dislikeCount
    );
  }
}