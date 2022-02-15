part of 'comment_cubit.dart';

abstract class CommentState extends Equatable {
  const CommentState();

  @override
  List<Object> get props => [];
}

class CommentInProgress extends CommentState {}

class CommentLoaded extends CommentState {
  const CommentLoaded({
    required this.postData,
    required this.commentsList,
    required this.currentUserData,
  });

  final PostData postData;
  final List<CommentData> commentsList;
  final UserData currentUserData;

  @override
  List<Object> get props => [
        postData,
        commentsList,
        currentUserData,
      ];
}
