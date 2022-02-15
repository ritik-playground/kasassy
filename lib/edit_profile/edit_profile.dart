import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasassy/app/bloc/app_bloc.dart';
import 'package:kasassy/constants/widgets.dart';
import 'package:kasassy/data/models/user.dart';
import 'package:kasassy/data/repositories/database_repository.dart';
import 'package:kasassy/edit_profile/cubit/edit_profile_cubit.dart';

class EditProfile extends StatelessWidget {
  const EditProfile._({Key? key, required UserData profileData})
      : _profileData = profileData,
        super(key: key);

  static Route route({required UserData profileData}) {
    return MaterialPageRoute<void>(
      builder: (_) => EditProfile._(
        profileData: profileData,
      ),
    );
  }

  final UserData _profileData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: BlocProvider(
        create: (context) => EditProfileCubit(
          userDataRepository: context.read<DatabaseRepository>(),
        )..editProfileLaunch(
            _profileData,
          ),
        child: const EditProfileView(),
      ),
    );
  }
}

class EditProfileView extends StatefulWidget {
  const EditProfileView({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfileView> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  bool _nameValid = true;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditProfileCubit, EditProfileState>(
      listener: (context, state) {
        if (state is EditProfileLoaded) {
          nameController.text = state.profileData.name;
          bioController.text = state.profileData.bio;
        }
        if (state is EditProfileSaved) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        if (state is EditProfileLoaded) {
          return ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 16,
                      bottom: 8,
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: CachedNetworkImageProvider(
                        state.profileData.uploadPhoto,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Padding(
                              padding: EdgeInsets.only(top: 12),
                              child: Text(
                                'Display Name',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            TextField(
                              controller: nameController,
                              decoration: InputDecoration(
                                hintText: 'Update Display Name',
                                errorText: _nameValid
                                    ? null
                                    : 'Display Name too short',
                              ),
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Padding(
                              padding: EdgeInsets.only(top: 12),
                              child: Text(
                                'Bio',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            TextField(
                              maxLength: 100,
                              controller: bioController,
                              decoration: const InputDecoration(
                                hintText: 'Update Bio',
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  FlatButton(
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      setState(
                        () {
                          nameController.text.trim().length < 3 ||
                                  nameController.text.isEmpty
                              ? _nameValid = false
                              : _nameValid = true;
                        },
                      );
                      if (_nameValid) {
                        context.read<EditProfileCubit>().editProfileSave(
                              profileId: state.profileData.uid,
                              name: nameController.text,
                              bio: bioController.text,
                            );
                      }
                    },
                    child: Text(
                      'Update Profile',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                        context.read<AppBloc>().add(
                              AppLogoutRequested(),
                            );
                      },
                      child: const Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        } else {
          return Progress.circularProgress();
        }
      },
    );
  }
}
