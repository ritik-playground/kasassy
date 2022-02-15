part of 'chat_cubit.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatInProgress extends ChatState {}

class ChatLoaded extends ChatState {
  const ChatLoaded(this.conversationList);

  final List<ConversationData> conversationList;

  @override
  List<Object> get props => [conversationList];
}

class ChatEmpty extends ChatState {}
