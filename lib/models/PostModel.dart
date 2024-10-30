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
  Map<String, int> reactions; // New field for reactions

  PostModel({
    required this.id,
    required this.userId,
    required this.content,
    required this.imageUrls,
    required this.link,
    this.status = true,
    required this.createdDate,
    required this.lastModifiedDate,
    this.reactions = const {}, // Initialize reactions
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
      'reactions': reactions, // Add reactions to map
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
      status: data['status'],
      createdDate: DateTime.parse(data['createdDate']),
      lastModifiedDate: DateTime.parse(data['lastModifiedDate']),
      reactions: Map<String, int>.from(data['reactions'] ?? {}), // Initialize reactions
    );
  }
}