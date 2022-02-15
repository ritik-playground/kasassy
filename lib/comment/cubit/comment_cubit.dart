import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kasassy/data/models/comment.dart';
import 'package:kasassy/data/models/post.dart';
import 'package:kasassy/data/models/user.dart';
import 'package:kasassy/data/repositories/database_repository.dart';

part 'comment_state.dart';

class CommentCubit extends Cubit<CommentState> {
  CommentCubit({
    required DatabaseRepository userDataRepository,
  })  : _userDataRepository = userDataRepository,
        super(CommentInProgress());

  final DatabaseRepository _userDataRepository;
  StreamSubscription? _commentDataSubscription;

  Future<void> commentLaunch({
    required PostData postData,
    required UserData currentUserData,
  }) async {
    final commentsData = _userDataRepository.getComments(postData.postId);
    await _commentDataSubscription?.cancel();
    _commentDataSubscription = commentsData.listen(
      (commentsList) {
        emit(
          CommentLoaded(
            postData: postData,
            commentsList: commentsList,
            currentUserData: currentUserData,
          ),
        );
      },
    );
  }

  Future<void> commentAdd({
    required UserData currentUserData,
    required PostData postData,
    required String textComment,
  }) async {
    await _userDataRepository.addComment(
      currentUserData: currentUserData,
      postData: postData,
      textComment: textComment,
    );
  }

  @override
  Future<void> close() {
    _commentDataSubscription?.cancel();
    return super.close();
  }
}
