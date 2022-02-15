import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:kasassy/data/providers/_base_provider.dart';
import 'package:kasassy/data/providers/storage_provider.dart';

class StorageRepository {
  StorageRepository({
    BaseStorageProvider? baseStorageProvider,
  }) : _storageProvider = baseStorageProvider ?? StorageProvider();

  final BaseStorageProvider _storageProvider;

  Future<String> uploadFile({
    required File profileImage,
    required String usernamePath,
  }) =>
      _storageProvider.uploadProfileImage(
        profileImage: profileImage,
        usernamePath: usernamePath,
      );

  Future<String> uploadPost({
    required XFile postImage,
    required String usernamePath,
    required String postId,
  }) =>
      _storageProvider.uploadPostImage(
        postImage: postImage,
        usernamePath: usernamePath,
        postId: postId,
      );

  void dispose() {
    _storageProvider.dispose();
  }
}
