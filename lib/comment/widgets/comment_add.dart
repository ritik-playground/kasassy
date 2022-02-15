import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasassy/comment/cubit/comment_cubit.dart';

class CommentAdd extends StatefulWidget {
  const CommentAdd({Key? key}) : super(key: key);

  @override
  _CommentAddState createState() => _CommentAddState();
}

class _CommentAddState extends State<CommentAdd> {
  TextEditingController commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentCubit, CommentState>(
      builder: (context, state) {
        if (state is CommentLoaded) {
          return ListTile(
            title: TextFormField(
              controller: commentController,
              decoration:
                  const InputDecoration(labelText: 'Write a comment...'),
            ),
            trailing: OutlineButton(
              onPressed: () {
                if (commentController.text.isNotEmpty) {
                  context.read<CommentCubit>().commentAdd(
                        postData: state.postData,
                        textComment: commentController.text,
                        currentUserData: state.currentUserData,
                      );
                  commentController.clear();
                }
              },
              borderSide: BorderSide.none,
              child: const Text('Post'),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
