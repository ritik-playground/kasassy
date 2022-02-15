import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kasassy/data/repositories/database_repository.dart';
import 'package:kasassy/data/repositories/device_repository.dart';
import 'package:kasassy/data/repositories/storage_repository.dart';
import 'package:uuid/uuid.dart';

part 'upload_state.dart';

class UploadCubit extends Cubit<UploadState> {
  UploadCubit({
    required StorageRepository storageRepository,
    required DatabaseRepository userDataRepository,
    required DeviceRepository deviceRepository,
  })  : _deviceRepository = deviceRepository,
        _storageRepository = storageRepository,
        _userDataRepository = userDataRepository,
        super(
          const UploadState.initial(),
        );

  final DeviceRepository _deviceRepository;
  final StorageRepository _storageRepository;
  final DatabaseRepository _userDataRepository;

  Future<void> uploadPickUp({required XFile file}) async {
    emit(UploadState.picked(file));
  }

  Future<void> uploadBackButton() async {
    emit(const UploadState.reverse());
  }

  Future<void> uploadGetLocation({required XFile pickedImage}) async {
    final currentUserLocationText = await _deviceRepository.getuserLocation();
    emit(
      UploadState.pickedWithLocation(
        currentUserLocationText: currentUserLocationText,
        pickedImage: pickedImage,
      ),
    );
  }

  Future<void> uploadSave({
    required XFile pickedImage,
    required String location,
    required String caption,
    required String username,
    required String userId,
    required String avatarURL,
  }) async {
    emit(UploadState.uploading(pickedImage: pickedImage));
    final postId = const Uuid().v4();
    final mediaUrl = await _storageRepository.uploadPost(
      postImage: pickedImage,
      usernamePath: 'posts/$username',
      postId: postId,
    );
    await _userDataRepository.uploadPostData(
      mediaUrl: mediaUrl,
      location: location,
      description: caption,
      currentUserId: userId,
      postId: postId,
      avatarURL: avatarURL,
      username: username,
    );
    emit(const UploadState.reverse());
  }
}
