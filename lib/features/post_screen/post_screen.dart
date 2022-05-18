import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasassy/constants/widgets.dart';
import 'package:kasassy/data/repositories/database_repository.dart';
import 'package:kasassy/features/app/bloc/app_bloc.dart';
import 'package:kasassy/features/post_screen/cubit/post_screen_cubit.dart';
import 'package:kasassy/features/post_screen/widgets/post_parts.dart';

class PostScreen extends StatelessWidget {
  const PostScreen._({
    Key? key,
    required String postId,
  })  : _postId = postId,
        super(key: key);

  static Route route({required String postId}) {
    return MaterialPageRoute<void>(
      builder: (_) => PostScreen._(postId: postId),
    );
  }

  final String _postId;

  @override
  Widget build(BuildContext context) {
    final _currentUserData = context.read<AppBloc>().state.currentUserData;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Screen'),
      ),
      body: BlocProvider(
        create: (context) => PostScreenCubit(
          userDataRepository: context.read<DatabaseRepository>(),
        )..postScreenOpen(
            postId: _postId,
            currentUserData: _currentUserData!,
          ),
        child: BlocConsumer<PostScreenCubit, PostScreenState>(
          listener: (context, state) {
            if (state is PostScreenDeleted) {
              Navigator.of(context).pop();
            }
          },
          builder: (context, state) {
            if (state is PostScreenUpdated) {
              return const PostParts();
            }
            if (state is PostScreenDeleted) {
              return Container();
            } else {
              return Progress.circularProgress();
            }
          },
        ),
      ),
    );
  }
}
