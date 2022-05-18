part of 'profile_cubit.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInProgress extends ProfileState {}

class ProfileLoaded extends ProfileState {
  const ProfileLoaded({
    required this.posts,
    required this.profileData,
    required this.currentUserData,
    required this.isProfileOwner,
  });

  final List<PostData> posts;
  final UserData profileData;
  final bool isProfileOwner;
  final UserData currentUserData;

  @override
  List<Object> get props => [
        profileData,
        posts,
        isProfileOwner,
        currentUserData,
      ];
}

class ProfileMessage extends ProfileState {
  const ProfileMessage({required this.chatId, required this.userChatData});

  final String chatId;
  final Map userChatData;

  @override
  List<Object> get props => [
        chatId,
        userChatData,
      ];
}
