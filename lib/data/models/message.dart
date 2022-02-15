import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class MessageData extends Equatable {
  const MessageData({
    required this.messageText,
    required this.username,
    required this.profilePicture,
  });

  factory MessageData.fromFirestore(
    QueryDocumentSnapshot queryDocumentSnapshot,
  ) {
    final data = queryDocumentSnapshot.data() as Map;
    return MessageData(
      messageText: data['messageText'] as String,
      username: data['sentBy']['username'] as String,
      profilePicture: data['sentBy']['profile'] as String,
    );
  }

  final String messageText;
  final String username;
  final String profilePicture;

  @override
  List<Object> get props => [messageText, username, profilePicture];
}
