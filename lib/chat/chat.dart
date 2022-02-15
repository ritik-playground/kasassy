import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasassy/chat/cubit/chat_cubit.dart';
import 'package:kasassy/constants/widgets.dart';
import 'package:kasassy/data/models/conversation.dart';
import 'package:kasassy/data/models/user.dart';
import 'package:kasassy/data/repositories/database_repository.dart';
import 'package:kasassy/message/message.dart';

class Chat extends StatelessWidget {
  const Chat({
    Key? key,
    required UserData currentUserData,
  })  : _currentUserData = currentUserData,
        super(key: key);

  static Builder route({
    required UserData currentUserData,
  }) {
    return Builder(
      builder: (_) => Chat(
        currentUserData: currentUserData,
      ),
    );
  }

  final UserData _currentUserData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Chat'),
      ),
      body: BlocProvider<ChatCubit>(
        create: (context) => ChatCubit(
          userDataRepository: context.read<DatabaseRepository>(),
        )..openChat(
            _currentUserData.uid,
          ),
        child: ChatView(
          currentUserData: _currentUserData,
        ),
      ),
    );
  }
}

class ChatView extends StatelessWidget {
  const ChatView({Key? key, required this.currentUserData}) : super(key: key);

  final UserData currentUserData;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        if (state is ChatLoaded) {
          return ListView.builder(
            itemCount: state.conversationList.length,
            itemBuilder: (context, index) {
              return ConversationItem(
                conversationItem: state.conversationList[index],
                currentUserData: currentUserData,
              );
            },
          );
        }
        if (state is ChatEmpty) {
          return const Center(
            child: Text('Empty'),
          );
        }
        return Progress.circularProgress();
      },
    );
  }
}

class ConversationItem extends StatefulWidget {
  const ConversationItem({
    Key? key,
    required this.conversationItem,
    required this.currentUserData,
  }) : super(key: key);

  final ConversationData conversationItem;
  final UserData currentUserData;

  @override
  _ConversationItemState createState() => _ConversationItemState();
}

class _ConversationItemState extends State<ConversationItem> {
  late Map userChatData;
  @override
  void initState() {
    widget.conversationItem.members.forEach(
      (dynamic key, dynamic value) {
        if (key != widget.currentUserData.uid) {
          userChatData = value as Map;
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          onTap: () {
            Navigator.of(context).push<void>(
              Message.route(
                chatId: widget.conversationItem.id,
                userChatData: userChatData,
              ),
            );
          },
          title: Text(
            userChatData['username'] as String,
          ),
          leading: Image.network(
            userChatData['profilePicture'] as String,
          ),
          subtitle: Text(
            // ignore: lines_longer_than_80_chars
            '${widget.conversationItem.sentBy} : ${widget.conversationItem.recentText}',
          ),
        ),
        const Divider(),
      ],
    );
  }
}
