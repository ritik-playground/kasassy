import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ConversationData extends Equatable {
  const ConversationData({
    required this.members,
    required this.recentText,
    required this.sentBy,
    required this.id,
  });

  factory ConversationData.fromFirestore(
    QueryDocumentSnapshot queryDocumentSnapshot,
  ) {
    final data = queryDocumentSnapshot.data() as Map;
    return ConversationData(
      id: queryDocumentSnapshot.id,
      members: data['membersData'] as Map,
      recentText: data['recentMessage']['messageText'] as String,
      sentBy: data['recentMessage']['sentBy']['username'] as String,
    );
  }

  final Map members;
  final String recentText;
  final String sentBy;
  final String id;

  @override
  List<Object> get props => [members, recentText, sentBy, id];
}
