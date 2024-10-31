import 'package:cloud_firestore/cloud_firestore.dart';

class ReactionModel {
  String id;
  String postId;
  String userId;
  String type; // "like", "love", etc.
  DateTime createdDate;

  ReactionModel({
    required this.id,
    required this.postId,
    required this.userId,
    required this.type,
    required this.createdDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'userId': userId,
      'type': type,
      'createdDate': createdDate.toIso8601String(),
    };
  }

  factory ReactionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ReactionModel(
      id: doc.id,
      postId: data['postId'],
      userId: data['userId'],
      type: data['type'],
      createdDate: DateTime.parse(data['createdDate']),
    );
  }
}