import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kasassy/data/models/post.dart';
import 'package:kasassy/data/models/user.dart';
import 'package:kasassy/data/repositories/database_repository.dart';
import 'package:rxdart/rxdart.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({required DatabaseRepository userDataRepository})
      : _userDataRepository = userDataRepository,
        super(ProfileInProgress());

  final DatabaseRepository _userDataRepository;
  StreamSubscription? _profileDataSubscription;

  Future<void> profileLaunch({
    required String profileId,
    required UserData currentUserData,
  }) async {
    final profileData = _userDataRepository.getProfile(profileId: profileId);
    final profilePosts =
        _userDataRepository.getProfilePosts(profileId: profileId);
    final isProfileOwner = profileId == currentUserData.uid;
    await _profileDataSubscription?.cancel();
    _profileDataSubscription = Rx.combineLatest2(
      profileData,
      profilePosts,
      (
        UserData profile,
        List<PostData> profilePosts,
      ) {
        emit(
          ProfileLoaded(
            posts: profilePosts,
            profileData: profile,
            currentUserData: currentUserData,
            isProfileOwner: isProfileOwner,
          ),
        );
      },
    ).listen(
      (event) {
        // ignore: avoid_print
        print('Profile Updated');
      },
    );
  }

  Future<void> openMessage({
    required UserData currentUserData,
    required UserData profileData,
  }) async {
    final chatId = await _userDataRepository.openMessageScreen(
      profileData: profileData,
      currentUserData: currentUserData,
    );
    final userChatData = {
      'username': profileData.username,
      'profilePicture': profileData.uploadPhoto,
      'id': profileData.uid,
    };
    emit(
      ProfileMessage(chatId: chatId, userChatData: userChatData),
    );
  }

  @override
  Future<void> close() {
    _profileDataSubscription?.cancel();
    return super.close();
  }
}
