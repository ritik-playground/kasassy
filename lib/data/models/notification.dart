import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ActivityFeedItemData extends Equatable {
  const ActivityFeedItemData({
    required this.username,
    required this.userId,
    required this.typeActivity,
    required this.mediaURL,
    required this.postId,
    required this.userProfileImage,
    required this.commentData,
    required this.timestamp,
  });

  factory ActivityFeedItemData.fromFirestore(
    QueryDocumentSnapshot queryDocumentSnapshot,
  ) {
    final data = queryDocumentSnapshot.data() as Map;
    return ActivityFeedItemData(
      username: data['username'] as String,
      userId: data['userId'] as String,
      typeActivity: data['type'] as String,
      postId: data['postId'] as String,
      userProfileImage: data['userProfileImage'] as String,
      commentData: data['commentData'] as String,
      timestamp: data['timestamp'] as Timestamp,
      mediaURL: data['mediaURL'] as String,
    );
  }

  final String username;
  final String userId;
  final String typeActivity;
  final String mediaURL;
  final String postId;
  final String userProfileImage;
  final String commentData;
  final Timestamp timestamp;

  @override
  List<Object> get props => [
        username,
        userId,
        typeActivity,
        mediaURL,
        postId,
        userProfileImage,
        commentData,
        timestamp,
      ];
}
