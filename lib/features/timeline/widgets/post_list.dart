import 'package:flutter/material.dart';
import 'package:kasassy/data/models/post.dart';
import 'package:kasassy/features/post_widget/post_widget.dart';

class PostList extends StatelessWidget {
  const PostList({Key? key, required this.posts}) : super(key: key);

  final List<PostData> posts;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (BuildContext context, int index) {
        return PostWidget(
          postData: posts[index],
        );
      },
    );
  }
}
