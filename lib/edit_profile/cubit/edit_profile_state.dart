part of 'edit_profile_cubit.dart';

abstract class EditProfileState extends Equatable {
  const EditProfileState();

  @override
  List<Object> get props => [];
}

class EditProfileInProgress extends EditProfileState {}

class EditProfileLoaded extends EditProfileState {
  const EditProfileLoaded(this.profileData);

  final UserData profileData;

  @override
  List<Object> get props => [profileData];
}

class EditProfileSaved extends EditProfileState {}
