import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasassy/comment/cubit/comment_cubit.dart';
import 'package:kasassy/comment/widgets/comment_add.dart';
import 'package:kasassy/comment/widgets/comment_list.dart';
import 'package:kasassy/constants/widgets.dart';
import 'package:kasassy/data/models/post.dart';
import 'package:kasassy/data/models/user.dart';
import 'package:kasassy/data/repositories/database_repository.dart';

class Comment extends StatelessWidget {
  const Comment({
    Key? key,
    required PostData postData,
    required UserData currentUserData,
  })  : _postData = postData,
        _currentUserData = currentUserData,
        super(key: key);

  static Route route({
    required PostData postData,
    required UserData currentUserData,
  }) {
    return MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (_) => Comment(
        postData: postData,
        currentUserData: currentUserData,
      ),
    );
  }

  final PostData _postData;
  final UserData _currentUserData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
      ),
      body: BlocProvider<CommentCubit>(
        create: (context) => CommentCubit(
          userDataRepository: context.read<DatabaseRepository>(),
        )..commentLaunch(
            postData: _postData,
            currentUserData: _currentUserData,
          ),
        child: const CommentView(),
      ),
    );
  }
}

class CommentView extends StatelessWidget {
  const CommentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentCubit, CommentState>(
      builder: (context, state) {
        if (state is CommentLoaded) {
          return Column(
            children: <Widget>[
              CommentList(
                commentsList: state.commentsList,
              ),
              const Divider(),
              const CommentAdd(),
            ],
          );
        } else {
          return Progress.circularProgress();
        }
      },
    );
  }
}
