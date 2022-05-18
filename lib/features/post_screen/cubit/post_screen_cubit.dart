import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kasassy/data/models/post.dart';
import 'package:kasassy/data/models/user.dart';
import 'package:kasassy/data/repositories/database_repository.dart';

part 'post_screen_state.dart';

class PostScreenCubit extends Cubit<PostScreenState> {
  PostScreenCubit({
    required DatabaseRepository userDataRepository,
  })  : _userDataRepository = userDataRepository,
        super(
          PostScreenInProgress(),
        );

  final DatabaseRepository _userDataRepository;
  StreamSubscription? _postDataSubscription;

  Future<void> postScreenOpen({
    required String postId,
    required UserData currentUserData,
  }) async {
    final getPostData = _userDataRepository.getPostData(postId);
    await _postDataSubscription?.cancel();
    _postDataSubscription = getPostData.listen(
      (postData) {
        final isPostOwner = currentUserData.uid == postData.ownerId;
        final isLiked = postData.likes[currentUserData.uid] == true;
        emit(
          PostScreenUpdated(
            postData: postData,
            isPostOwner: isPostOwner,
            currentUserData: currentUserData,
            isLiked: isLiked,
          ),
        );
      },
    );
  }

  Future<void> postDelete({
    required String ownerId,
    required String postId,
  }) async {
    emit(
      PostScreenInProgress(),
    );
    await _postDataSubscription?.cancel();
    await _userDataRepository.handleDeletePost(
      ownerId: ownerId,
      postId: postId,
    );
    emit(
      PostScreenDeleted(),
    );
  }

  Future<void> postLike({
    required PostData postData,
    required String mediaURL,
    required UserData currentUserData,
  }) async {
    await _userDataRepository.handleLikePost(
      ownerId: postData.ownerId,
      postId: postData.postId,
      mediaURL: mediaURL,
      currentUserData: currentUserData,
    );
  }

  Future<void> postDislike({
    required PostData postData,
    required UserData currentUserData,
  }) async {
    await _userDataRepository.handleDislikePost(
      ownerId: postData.ownerId,
      postId: postData.postId,
      currentUserData: currentUserData,
    );
  }

  @override
  Future<void> close() {
    _postDataSubscription?.cancel();
    return super.close();
  }
}
