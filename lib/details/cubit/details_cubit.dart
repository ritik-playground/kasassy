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
          DetailsInitial(),
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
      DetailsInProgress(),
    );
    try {
      final profilePictureUrl = await _storageRepository.uploadFile(
        profileImage: profileImage,
        usernamePath: 'profile_pictures/$username',
      );
      await _userDataRepository.saveUserDetails(
        currentUser: currentUser,
        profileImageURL: profilePictureUrl,
        age: age,
        username: username,
      );

      emit(
        DetailsSuccess(),
      );
    } catch (_, __) {
      emit(
        DetailsFailure(),
      );
    }
  }
}
