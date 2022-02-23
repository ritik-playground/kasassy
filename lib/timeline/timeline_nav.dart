import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasassy/activity/activity_nav.dart';
import 'package:kasassy/activity/cubit/activity_feed_cubit.dart';
import 'package:kasassy/app/bloc/app_bloc.dart';
import 'package:kasassy/chat/chat.dart';
import 'package:kasassy/constants/widgets.dart';
import 'package:kasassy/search/cubit/search_cubit.dart';
import 'package:kasassy/search/search_nav.dart';
import 'package:kasassy/timeline/cubit/timeline_cubit.dart';
import 'package:kasassy/timeline/widgets/post_list.dart';

class Timeline extends StatelessWidget {
  const Timeline({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUserData =
        context.select((AppBloc bloc) => bloc.state.currentUserData)!;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kasassy',
          style: TextStyle(
            fontSize: 40,
            fontFamily: 'Italianno',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.of(context).push<void>(
                Search.route(
                  context.read<SearchCubit>(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.of(context).push<void>(
                ActivityFeed.route(
                  context.read<ActivityFeedCubit>(),
                ),
              );
            },
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .push<void>(Chat.route(currentUserData: currentUserData));
            },
            icon: const Icon(Icons.chat),
          )
        ],
      ),
      body: BlocBuilder<TimelineCubit, TimelineState>(
        builder: (context, state) {
          if (state is TimelineEmpty) {
            return const Center(
              child: Text('No Posts'),
            );
          }
          if (state is TimelineLoaded) {
            return PostList(posts: state.posts);
          } else {
            return Progress.circularProgress();
          }
        },
      ),
    );
  }
}
