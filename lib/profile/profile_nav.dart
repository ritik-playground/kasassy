import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasassy/app/bloc/app_bloc.dart';
import 'package:kasassy/constants/widgets.dart';
import 'package:kasassy/data/repositories/database_repository.dart';
import 'package:kasassy/message/message.dart';
import 'package:kasassy/profile/cubit/profile_cubit.dart';
import 'package:kasassy/profile/widgets/profile_parts.dart';

class Profile extends StatelessWidget {
  const Profile({
    Key? key,
    required String profileId,
  })  : _profileId = profileId,
        super(key: key);

  static Route route({
    required String profileId,
  }) {
    return MaterialPageRoute<void>(
      builder: (_) => Profile(profileId: profileId),
    );
  }

  final String _profileId;

  @override
  Widget build(BuildContext context) {
    final _currentUserData = context.read<AppBloc>().state.currentUserData;
    return Scaffold(
      body: BlocProvider<ProfileCubit>(
        create: (context) => ProfileCubit(
          userDataRepository: context.read<DatabaseRepository>(),
        )..profileLaunch(
            profileId: _profileId,
            currentUserData: _currentUserData!,
          ),
        child: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is ProfileMessage) {
              Navigator.of(context).push<void>(
                Message.route(
                  chatId: state.chatId,
                  userChatData: state.userChatData,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is ProfileLoaded) {
              return const ProfileParts();
            } else {
              return Progress.circularProgress();
            }
          },
        ),
      ),
    );
  }
}
