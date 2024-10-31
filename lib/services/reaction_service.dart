import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommercettl/models/ReactionModel.dart';

class ReactionService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Get reactions for a post
  Stream<List<ReactionModel>> getReactions(String postId) {
    return _db
        .collection('posts')
        .doc(postId)
        .collection('reactions')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => ReactionModel.fromFirestore(doc)).toList();
    });
  }

  // Add or update a reaction
  Future<void> addOrUpdateReaction(String postId, ReactionModel reaction) async {
    final reactionRef = _db
        .collection('posts')
        .doc(postId)
        .collection('reactions')
        .doc(reaction.userId);

    final reactionSnapshot = await reactionRef.get();

    if (reactionSnapshot.exists) {
      // Update existing reaction
      await reactionRef.update(reaction.toMap());
    } else {
      // Add new reaction
      await reactionRef.set(reaction.toMap());
    }
  }

  // Get a user's reaction for a post
  Future<ReactionModel?> getUserReaction(String postId, String userId) async {
    final reactionRef = _db
        .collection('posts')
        .doc(postId)
        .collection('reactions')
        .doc(userId);

    final reactionSnapshot = await reactionRef.get();

    if (reactionSnapshot.exists) {
      return ReactionModel.fromFirestore(reactionSnapshot);
    } else {
      return null;
    }
  }
}