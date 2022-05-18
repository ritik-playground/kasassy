import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kasassy/data/models/message.dart';

import 'package:kasassy/data/models/user.dart';
import 'package:kasassy/data/repositories/database_repository.dart';

part 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  MessageCubit({
    required DatabaseRepository userDataRepository,
  })  : _userDataRepository = userDataRepository,
        super(
          MessageInProgress(),
        );

  final DatabaseRepository _userDataRepository;
  StreamSubscription? messageSubscription;

  Future<void> openMessage(String chatId) async {
    final messagesSnapshot = _userDataRepository.getMessagesById(chatId);
    await messageSubscription?.cancel();
    messageSubscription = messagesSnapshot.listen(
      (event) {
        emit(
          MessageLoaded(event),
        );
      },
    );
  }

  Future<void> sendMessage({
    required String chatId,
    required UserData currentUserData,
    required String messageText,
  }) async {
    await _userDataRepository.sendMessage(
      messageText: messageText,
      currentuserData: currentUserData,
      chatId: chatId,
    );
  }

  @override
  Future<void> close() {
    messageSubscription?.cancel();
    return super.close();
  }
}
