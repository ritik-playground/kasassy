import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image/image.dart' as image;
import 'package:image_picker/image_picker.dart';
import 'package:kasassy/data/providers/_base_provider.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class StorageProvider extends BaseStorageProvider {
  StorageProvider({
    FirebaseStorage? firebaseStorage,
  }) : _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance;

  final FirebaseStorage _firebaseStorage;

  @override
  Future<String> uploadProfileImage({
    required File profileImage,
    required String usernamePath,
  }) async {
    try {
      final currentTimestamp = DateTime.now();
      final fileName = basename(profileImage.path);
      final currentTime = currentTimestamp.millisecondsSinceEpoch;
      final uploadTask = await _firebaseStorage
          .ref()
          // ignore: unnecessary_string_escapes
          .child('$usernamePath/$currentTime\_$fileName')
          .putFile(profileImage);
      final profileImageURL = await uploadTask.ref.getDownloadURL();
      return profileImageURL;
    } on Exception {
      throw UploadProfileImage();
    }
  }

  @override
  Future<String> uploadPostImage({
    required XFile postImage,
    required String usernamePath,
    required String postId,
  }) async {
    try {
      final temporaryDirectory = await getTemporaryDirectory().then(
        (value) => value.path,
      );
      final imageFile = image.decodeImage(
        File(postImage.path).readAsBytesSync(),
      );

      final compressedImageFile = File('$temporaryDirectory/image_$postId.jpg')
        ..writeAsBytesSync(
          image.encodeJpg(imageFile!, quality: 80),
        );
      final uploadTask = await _firebaseStorage
          .ref()
          .child('$usernamePath/post_$postId.jpg')
          .putFile(compressedImageFile);
      final postImageURL = await uploadTask.ref.getDownloadURL();
      return postImageURL;
    } on Exception {
      throw UploadPostImage();
    }
  }

  @override
  void dispose() {}
}

class UploadProfileImage implements Exception {}

class UploadPostImage implements Exception {}
