part of 'upload_cubit.dart';

enum UploadStatus { initial, picked, location, uploading, reverse }

class UploadState extends Equatable {
  const UploadState._({
    this.pickedImage,
    this.currentUserLocationText,
    this.status = UploadStatus.initial,
  });

  const UploadState.initial() : this._();

  const UploadState.picked(XFile pickedImage)
      : this._(status: UploadStatus.picked, pickedImage: pickedImage);
  const UploadState.pickedWithLocation({
    required String currentUserLocationText,
    required XFile pickedImage,
  }) : this._(
          status: UploadStatus.location,
          currentUserLocationText: currentUserLocationText,
          pickedImage: pickedImage,
        );
  const UploadState.uploading({required XFile pickedImage})
      : this._(
          status: UploadStatus.uploading,
          pickedImage: pickedImage,
        );

  const UploadState.reverse() : this._(status: UploadStatus.reverse);

  final XFile? pickedImage;
  final UploadStatus status;
  final String? currentUserLocationText;

  @override
  List<Object?> get props => [pickedImage, status, currentUserLocationText];
}
