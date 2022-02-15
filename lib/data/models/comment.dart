import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class CommentData extends Equatable {
  const CommentData({
    required this.username,
    required this.userId,
    required this.avatarURL,
    required this.comment,
    required this.timestamp,
  });

  factory CommentData.fromFirestore(DocumentSnapshot documentSnapshot) {
    final data = documentSnapshot.data() as Map;
    return CommentData(
      username: data['username'] as String,
      userId: data['userId'] as String,
      comment: data['comment'] as String,
      timestamp: data['timestamp'] as Timestamp,
      avatarURL: data['avatarURL'] as String,
    );
  }

  final String username;
  final String userId;
  final String avatarURL;
  final String comment;
  final Timestamp timestamp;

  @override
  List<Object> get props => [username, userId, avatarURL, comment, timestamp];
}
