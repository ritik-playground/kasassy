import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kasassy/data/models/comment.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentList extends StatelessWidget {
  const CommentList({
    Key? key,
    required this.commentsList,
  }) : super(key: key);

  final List<CommentData> commentsList;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        reverse: true,
        itemCount: commentsList.length,
        itemBuilder: (context, index) {
          return CommentItem(
            commentData: commentsList[index],
          );
        },
      ),
    );
  }
}

class CommentItem extends StatelessWidget {
  const CommentItem({
    Key? key,
    required this.commentData,
  }) : super(key: key);

  final CommentData commentData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          trailing: Text(
            timeago.format(
              commentData.timestamp.toDate(),
            ),
            style: const TextStyle(fontSize: 12),
          ),
          title: Text(
            commentData.comment,
          ),
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(
              commentData.avatarURL,
            ),
          ),
          subtitle: Text(commentData.username),
        ),
        const Divider(),
      ],
    );
  }
}
