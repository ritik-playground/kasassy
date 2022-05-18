import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kasassy/data/repositories/database_repository.dart';
import 'package:kasassy/data/repositories/storage_repository.dart';
part 'details_state.dart';

class DetailsCubit extends Cubit<DetailsState> {
  DetailsCubit(
    this._userDataRepository,
    this._storageRepository,
  ) : super(
          const DetailsState(),
        );

  final StorageRepository _storageRepository;
  final DatabaseRepository _userDataRepository;

  Future<void> saveProfile({
    required File profileImage,
    required int age,
    required String username,
    required User currentUser,
  }) async {
    emit(
      const DetailsState(status: DetailsStatus.loading),
    );
    final isUsernameExist =
        await _userDataRepository.isUsernameExist(username: username);
    if (isUsernameExist) {
      emit(
        const DetailsState(
          status: DetailsStatus.failure,
          error: 'Username already exists. Please choose another one.',
        ),
      );
    } else {
      try {
        final profilePictureUrl = await _storageRepository.uploadFile(
          profileImage: profileImage,
          usernamePath: 'profile_pictures/$username',
        );
        await _userDataRepository.saveUserDetails(
          currentUser: currentUser,
          profileImageURL: profilePictureUrl,
          age: age,
          username: username.toLowerCase(),
        );

        emit(
          const DetailsState(status: DetailsStatus.success),
        );
      } catch (e) {
        emit(
          const DetailsState(
            error: 'Something went wrong',
            status: DetailsStatus.failure,
          ),
        );
      }
    }
  }
}
