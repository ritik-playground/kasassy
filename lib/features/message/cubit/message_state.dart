part of 'message_cubit.dart';

abstract class MessageState extends Equatable {
  const MessageState();

  @override
  List<Object> get props => [];
}

class MessageInProgress extends MessageState {}

class MessageLoaded extends MessageState {
  const MessageLoaded(this.messageList);

  final List<MessageData> messageList;

  @override
  List<Object> get props => [messageList];
}
