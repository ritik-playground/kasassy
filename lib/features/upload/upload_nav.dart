import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kasassy/constants/widgets.dart';
import 'package:kasassy/data/models/user.dart';
import 'package:kasassy/features/app/bloc/app_bloc.dart';
import 'package:kasassy/features/upload/cubit/upload_cubit.dart';

class Upload extends StatefulWidget {
  const Upload({Key? key}) : super(key: key);

  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  TextEditingController captionController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  late XFile? pickedImage;

  @override
  Widget build(BuildContext context) {
    final _currentUserData = context.read<AppBloc>().state.currentUserData;
    return BlocConsumer<UploadCubit, UploadState>(
      listener: (context, state) {
        if (state.status == UploadStatus.reverse) {
          captionController.clear();
          locationController.clear();
          pickedImage = null;
        }
        if (state.status == UploadStatus.location) {
          locationController.text = state.currentUserLocationText!;
        }
      },
      builder: (context, state) {
        switch (state.status) {
          case UploadStatus.initial:
            return _uploadFrontPage();
          case UploadStatus.reverse:
            return _uploadFrontPage();
          case UploadStatus.uploading:
            return _uploadLoading(state);
          case UploadStatus.picked:
            return _uploadPickedUpState(
              currentState: state,
              currentUserData: _currentUserData!,
            );
          case UploadStatus.location:
            return _uploadPickedUpState(
              currentState: state,
              currentUserData: _currentUserData!,
            );
        }
      },
    );
  }

  Widget _uploadFrontPage() {
    return Center(
      child: OutlinedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
        ),
        onPressed: () => _selectImage(context),
        child: const Text(
          'Upload Image',
          style: TextStyle(
            fontSize: 22,
          ),
        ),
      ),
    );
  }

  Widget _uploadPickedUpState({
    required UserData currentUserData,
    required UploadState currentState,
  }) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.read<UploadCubit>().uploadBackButton();
          },
        ),
        title: const Text('Caption Post'),
        actions: [
          FlatButton(
            onPressed: () {
              context.read<UploadCubit>().uploadSave(
                    pickedImage: currentState.pickedImage!,
                    caption: captionController.text,
                    location: locationController.text,
                    username: currentUserData.username,
                    userId: currentUserData.uid,
                    avatarURL: currentUserData.uploadPhoto,
                  );
            },
            child: const Text(
              'Post',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 220,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(File(currentState.pickedImage!.path)),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage:
                  CachedNetworkImageProvider(currentUserData.uploadPhoto),
            ),
            title: SizedBox(
              width: 250,
              child: TextField(
                controller: captionController,
                decoration: const InputDecoration(
                  hintText: 'Write a caption...',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.pin_drop,
              color: Colors.orange,
              size: 35,
            ),
            title: SizedBox(
              width: 250,
              child: TextField(
                controller: locationController,
                decoration: const InputDecoration(
                  hintText: 'Where was this photo taken?',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Container(
            width: 200,
            height: 100,
            alignment: Alignment.center,
            child: RaisedButton.icon(
              onPressed: () {
                context
                    .read<UploadCubit>()
                    .uploadGetLocation(pickedImage: pickedImage!);
              },
              icon: const Icon(
                Icons.my_location,
                color: Colors.white,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              color: Colors.red,
              label: const Text(
                'Use Current Location',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _uploadLoading(UploadState currentState) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Uploading'),
      ),
      body: ListView(
        children: [
          Progress.linearProgress(),
          SizedBox(
            height: 220,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(
                        File(currentState.pickedImage!.path),
                      ),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10),
          ),
          const Center(
            child: Text('Uploading...'),
          ),
        ],
      ),
    );
  }

  Future<void> _selectImage(BuildContext parentContext) {
    return showDialog(
      context: parentContext,
      builder: (ctx) {
        return SimpleDialog(
          title: const Text('Create Post'),
          children: [
            SimpleDialogOption(
              onPressed: () => _handleTakePhoto(ctx: ctx),
              child: const Text('Photo with Camera'),
            ),
            SimpleDialogOption(
              onPressed: () => _handleChooseFromGallery(ctx: ctx),
              child: const Text('Image from Gallery'),
            ),
            SimpleDialogOption(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(ctx),
            )
          ],
        );
      },
    );
  }

  Future<void> _handleTakePhoto({required BuildContext ctx}) async {
    Navigator.pop(ctx);

    pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: 675,
      maxWidth: 960,
    );
    if (pickedImage != null) {
      await context.read<UploadCubit>().uploadPickUp(file: pickedImage!);
    } else {
      return;
    }
  }

  Future<void> _handleChooseFromGallery({required BuildContext ctx}) async {
    Navigator.pop(ctx);

    // ignore: deprecated_member_use
    pickedImage = await ImagePicker().pickImage(
      imageQuality: 80,
      source: ImageSource.gallery,
    );
    if (pickedImage != null) {
      await context.read<UploadCubit>().uploadPickUp(file: pickedImage!);
    } else {
      return;
    }
  }
}
