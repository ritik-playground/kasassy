import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kasassy/data/models/post.dart';
import 'package:kasassy/data/models/user.dart';
import 'package:kasassy/data/repositories/database_repository.dart';

part 'post_widget_state.dart';

class PostWidgetCubit extends Cubit<PostWidgetState> {
  PostWidgetCubit({
    required DatabaseRepository userDataRepository,
  })  : _userDataRepository = userDataRepository,
        super(
          PostWidgetInitial(),
        );

  final DatabaseRepository _userDataRepository;

  Future<void> postDelete({
    required String ownerId,
    required String postId,
  }) async {
    await _userDataRepository.handleDeletePost(
      ownerId: ownerId,
      postId: postId,
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
}
