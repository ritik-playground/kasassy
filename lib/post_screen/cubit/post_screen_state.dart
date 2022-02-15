part of 'post_screen_cubit.dart';

abstract class PostScreenState extends Equatable {
  const PostScreenState();

  @override
  List<Object> get props => [];
}

class PostScreenInProgress extends PostScreenState {}

class PostScreenUpdated extends PostScreenState {
  const PostScreenUpdated({
    required this.postData,
    required this.isPostOwner,
    required this.isLiked,
    required this.currentUserData,
  });

  final PostData postData;
  final UserData currentUserData;
  final bool isPostOwner;
  final bool isLiked;

  @override
  List<Object> get props => [
        postData,
        isPostOwner,
        currentUserData,
        isLiked,
      ];
}

class PostScreenDeleted extends PostScreenState {}
