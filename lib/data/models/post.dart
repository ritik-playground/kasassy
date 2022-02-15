import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class PostData extends Equatable {
  const PostData({
    required this.postId,
    required this.ownerId,
    required this.location,
    required this.mediaURL,
    required this.avatarURL,
    required this.username,
    required this.caption,
    required this.likeCount,
    required this.likes,
  });

  factory PostData.fromFirestore(DocumentSnapshot documentSnapshot) {
    final data = documentSnapshot.data() as Map;
    final likes = data['likes'] as Map<String, dynamic>;
    return PostData(
      likeCount: getLikeCount(likes),
      avatarURL: data['avatarURL'] as String,
      username: data['username'] as String,
      postId: data['postId'] as String,
      ownerId: data['ownerId'] as String,
      location: data['location'] as String,
      mediaURL: data['mediaURL'] as String,
      caption: data['caption'] as String,
      likes: likes,
    );
  }

  final String postId;
  final String ownerId;
  final String username;
  final String avatarURL;
  final String location;
  final String mediaURL;
  final int likeCount;
  final String caption;
  final Map<String, dynamic> likes;

  static int getLikeCount(Map<String, dynamic>? likes) {
    return likes != null
        ? likes.values.where((dynamic val) => val == true).length
        : 0;
  }

  @override
  List<Object> get props => [
        postId,
        ownerId,
        location,
        mediaURL,
        username,
        avatarURL,
        caption,
        likes,
        likeCount
      ];
}
