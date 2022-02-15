import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasassy/activity/activity_nav.dart';
import 'package:kasassy/activity/cubit/activity_feed_cubit.dart';
import 'package:kasassy/constants/widgets.dart';
import 'package:kasassy/search/cubit/search_cubit.dart';
import 'package:kasassy/search/search_nav.dart';
import 'package:kasassy/timeline/cubit/timeline_cubit.dart';
import 'package:kasassy/timeline/widgets/post_list.dart';

class Timeline extends StatelessWidget {
  const Timeline({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kasassy'),
        centerTitle: true,
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
