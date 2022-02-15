import 'package:flutter/material.dart';
import 'package:kasassy/data/models/conversation.dart';
import 'package:kasassy/data/models/user.dart';
import 'package:kasassy/message/message.dart';

class ConversationList extends StatelessWidget {
  const ConversationList({
    Key? key,
    required this.currentUserData,
    required this.conversationList,
  }) : super(key: key);

  final UserData currentUserData;
  final List<ConversationData> conversationList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: conversationList.length,
      itemBuilder: (context, index) {
        return ConversationItem(
          conversationItem: conversationList[index],
          currentUserData: currentUserData,
        );
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
  late Map userMemberData;

  @override
  void initState() {
    widget.conversationItem.members.forEach(
      (dynamic key, dynamic value) {
        if (key != widget.currentUserData.uid) {
          userMemberData = value as Map;
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).push<void>(
          Message.route(
            chatId: widget.conversationItem.id,
            userChatData: userMemberData,
          ),
        );
      },
      title: Text(
        userMemberData['username'] as String,
      ),
      leading: Hero(
        tag: widget.conversationItem.id,
        child: CircleAvatar(
          backgroundImage: NetworkImage(
            userMemberData['profilePicture'] as String,
          ),
        ),
      ),
      subtitle: Text(
        // ignore: lines_longer_than_80_chars
        '${widget.conversationItem.sentBy} : ${widget.conversationItem.recentText}',
      ),
    );
  }
}
