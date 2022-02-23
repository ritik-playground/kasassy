import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kasassy/app/bloc/app_bloc.dart';
import 'package:kasassy/constants/assets.dart';
import 'package:kasassy/data/repositories/database_repository.dart';
import 'package:kasassy/data/repositories/storage_repository.dart';
import 'package:kasassy/details/cubit/details_cubit.dart';
import 'package:kasassy/details/widgets/log_out_button.dart';
import 'package:numberpicker/numberpicker.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage._({Key? key}) : super(key: key);

  static Page route() {
    return const MaterialPage<void>(
      child: DetailsPage._(),
    );
  }

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> with WidgetsBindingObserver {
  XFile? profileImageFile = XFile(Images.placeholderImage);
  ImageProvider profileImage = Image.asset(Images.placeholderImage).image;

  int age = 18;

  final TextEditingController usernameController = TextEditingController();

  bool isOpenKeyboard = false;

  @override
  Widget build(BuildContext context) {
    final currentUser =
        context.select((AppBloc bloc) => bloc.state.currentUser)!;
    return BlocProvider<DetailsCubit>(
      create: (_) => DetailsCubit(
        context.read<DatabaseRepository>(),
        context.read<StorageRepository>(),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: BlocListener<DetailsCubit, DetailsState>(
          listener: (context, state) {
            if (state.status == DetailsStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error!),
                ),
              );
            }
            if (state.status == DetailsStatus.success) {
              context.read<AppBloc>().add(
                    CheckProfileComplete(
                      currentUser,
                    ),
                  );
            }
          },
          child: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              FocusScope.of(context).requestFocus(
                FocusNode(),
              );
            },
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _buildProfilePictureWidget(),
                  Column(
                    children: [
                      const Text(
                        'How old are you?',
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      _buildAgePicker(),
                    ],
                  ),
                  Column(
                    children: [
                      const Text(
                        'Choose a username',
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                      _buildUsernameWidget()
                    ],
                  ),
                  _buildSaveButtonWidget(),
                  const LogOutButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePictureWidget() {
    return GestureDetector(
      onTap: pickImage,
      child: CircleAvatar(
        backgroundImage: profileImage,
        backgroundColor: Colors.white,
        radius: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Icon(
              Icons.camera,
              color: Colors.black,
              size: 15,
            ),
            Text(
              'Set Profile Picture',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 10),
            )
          ],
        ),
      ),
    );
  }

  Future pickImage() async {
    profileImageFile =
        await ImagePicker().pickImage(source: ImageSource.gallery) as XFile;
    setState(() {
      profileImage = Image.file(File(profileImageFile!.path)).image;
    });
  }

  Widget _buildAgePicker() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        NumberPicker(
          axis: Axis.horizontal,
          value: age,
          minValue: 15,
          maxValue: 50,
          onChanged: (num value) {
            setState(() {
              age = value as int;
            });
          },
        ),
        const SizedBox(
          width: 10,
        ),
        const Text(
          'Years',
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
        )
      ],
    );
  }

  Widget _buildUsernameWidget() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      width: 120,
      child: TextField(
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 14,
        ),
        controller: usernameController,
        decoration: InputDecoration(
          hintText: '@username',
          hintStyle: TextStyle(color: Theme.of(context).hintColor),
          contentPadding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 0.1,
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 0.1,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButtonWidget() {
    return BlocBuilder<DetailsCubit, DetailsState>(
      builder: (context, state) {
        final currentUser =
            context.select((AppBloc bloc) => bloc.state.currentUser)!;
        if (state.status == DetailsStatus.loading) {
          return const CircularProgressIndicator(
            strokeWidth: 2,
          );
        }
        if (state.status == DetailsStatus.success) {
          return const Text('Saved');
        } else {
          return FloatingActionButton(
            onPressed: () => {
              if (usernameController.text.isNotEmpty)
                {
                  FocusScope.of(context).requestFocus(
                    FocusNode(),
                  ),
                  context.read<DetailsCubit>().saveProfile(
                        age: age,
                        currentUser: currentUser,
                        profileImage: File(profileImageFile!.path),
                        username: usernameController.text,
                      ),
                }
              else
                {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(
                        content: Text('Please Fill all the Details'),
                      ),
                    ),
                }
            },
            elevation: 0,
            backgroundColor: Colors.black,
            child: Icon(
              Icons.done,
              color: Theme.of(context).colorScheme.secondary,
            ),
          );
        }
      },
    );
  }
}
