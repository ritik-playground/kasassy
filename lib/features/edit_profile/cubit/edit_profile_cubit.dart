import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kasassy/data/models/user.dart';
import 'package:kasassy/data/repositories/database_repository.dart';

part 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit({required DatabaseRepository userDataRepository})
      : _userDataRepository = userDataRepository,
        super(
          EditProfileInProgress(),
        );

  final DatabaseRepository _userDataRepository;

  Future<void> editProfileLaunch(UserData profileData) async {
    await Future<void>.delayed(
      const Duration(microseconds: 1),
    );
    emit(
      EditProfileLoaded(profileData),
    );
  }

  Future<void> editProfileSave({
    required String profileId,
    required String name,
    required String bio,
  }) async {
    emit(
      EditProfileInProgress(),
    );
    await _userDataRepository.updateProfileData(
      currentUserId: profileId,
      name: name,
      bio: bio,
    );
    emit(
      EditProfileSaved(),
    );
  }
}
