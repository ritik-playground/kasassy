import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kasassy/data/models/conversation.dart';
import 'package:kasassy/data/repositories/database_repository.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit({
    required DatabaseRepository userDataRepository,
  })  : _userDataRepository = userDataRepository,
        super(
          ChatInProgress(),
        );

  final DatabaseRepository _userDataRepository;
  StreamSubscription? _conversationList;

  Future<void> openChat(String currentUserId) async {
    final conversationListData =
        _userDataRepository.getConversationList(currentUserId);
    await _conversationList?.cancel();
    _conversationList = conversationListData.listen(
      (event) {
        if (event.isEmpty) {
          emit(
            ChatEmpty(),
          );
        } else {
          emit(
            ChatLoaded(event),
          );
        }
      },
    );
  }

  @override
  Future<void> close() {
    _conversationList?.cancel();
    return super.close();
  }
}
