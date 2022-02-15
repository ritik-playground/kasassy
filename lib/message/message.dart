import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasassy/app/bloc/app_bloc.dart';
import 'package:kasassy/constants/widgets.dart';
import 'package:kasassy/data/repositories/database_repository.dart';
import 'package:kasassy/message/cubit/message_cubit.dart';

// ignore: must_be_immutable
class Message extends StatelessWidget {
  Message._({
    Key? key,
    required String chatId,
    required Map userChatData,
  })  : _userChatData = userChatData,
        _chatId = chatId,
        super(key: key);

  static Route route({
    required String chatId,
    required Map userChatData,
  }) {
    return MaterialPageRoute<void>(
      builder: (_) => BlocProvider(
        create: (context) => MessageCubit(
          userDataRepository: context.read<DatabaseRepository>(),
        )..openMessage(chatId),
        child: Message._(
          chatId: chatId,
          userChatData: userChatData,
        ),
      ),
    );
  }

  TextEditingController messageController = TextEditingController();
  final String _chatId;
  final Map _userChatData;

  @override
  Widget build(BuildContext context) {
    final _currentUserData = context.read<AppBloc>().state.currentUserData;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _userChatData['username'] as String,
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: Hero(
            tag: _chatId,
            child: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(
                _userChatData['profilePicture'] as String,
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<MessageCubit, MessageState>(
        builder: (context, state) {
          if (state is MessageLoaded) {
            return Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    reverse: true,
                    itemCount: state.messageList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment:
                              state.messageList[index].username ==
                                      _currentUserData?.username
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              state.messageList[index].username,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                            Material(
                              borderRadius: state.messageList[index].username ==
                                      _currentUserData?.username
                                  ? const BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      bottomLeft: Radius.circular(30),
                                      bottomRight: Radius.circular(30),
                                    )
                                  : const BorderRadius.only(
                                      bottomLeft: Radius.circular(30),
                                      bottomRight: Radius.circular(30),
                                      topRight: Radius.circular(30),
                                    ),
                              elevation: 5,
                              color: state.messageList[index].username ==
                                      _currentUserData?.username
                                  ? Colors.lightBlueAccent
                                  : Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 20,
                                ),
                                child: Text(
                                  state.messageList[index].messageText,
                                  style: TextStyle(
                                    color: state.messageList[index].username ==
                                            _currentUserData?.username
                                        ? Colors.white
                                        : Colors.black54,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const Divider(
                  color: Colors.blue,
                  thickness: 1,
                ),
                ListTile(
                  title: TextField(
                    controller: messageController,
                    decoration:
                        const InputDecoration(labelText: 'Write a message...'),
                  ),
                  trailing: OutlineButton(
                    onPressed: () {
                      if (messageController.text.isNotEmpty) {
                        context.read<MessageCubit>().sendMessage(
                              chatId: _chatId,
                              currentUserData: _currentUserData!,
                              messageText: messageController.text,
                            );
                        messageController.clear();
                      }
                    },
                    child: const Text('Send'),
                  ),
                ),
              ],
            );
          } else {
            return Progress.circularProgress();
          }
        },
      ),
    );
  }
}
