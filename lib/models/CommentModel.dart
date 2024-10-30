import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  String id;
  String postId;
  String userId;
  String content;
  DateTime createdDate;

  CommentModel({
    required this.id,
    required this.postId,
    required this.userId,
    required this.content,
    required this.createdDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'userId': userId,
      'content': content,
      'createdDate': createdDate.toIso8601String(),
    };
  }

  factory CommentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CommentModel(
      id: doc.id,
      postId: data['postId'],
      userId: data['userId'],
      content: data['content'],
      createdDate: DateTime.parse(data['createdDate']),
    );
  }
}