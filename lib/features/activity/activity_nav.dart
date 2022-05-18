import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasassy/constants/widgets.dart';
import 'package:kasassy/features/activity/cubit/activity_feed_cubit.dart';
import 'package:kasassy/features/activity/widgets/notification.dart';

class ActivityFeed extends StatelessWidget {
  const ActivityFeed({Key? key}) : super(key: key);

  static Route route(ActivityFeedCubit cubit) {
    return MaterialPageRoute<void>(
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: const ActivityFeed(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Feed'),
      ),
      body: BlocBuilder<ActivityFeedCubit, ActivityFeedState>(
        builder: (context, state) {
          if (state is ActivityFeedLoaded) {
            return ActivityFeedItems(
              activityFeedItemsData: state.feedItemsData,
            );
          }
          if (state is ActivityFeedEmpty) {
            return const Center(
              child: Text('No Notifications'),
            );
          }
          return Progress.circularProgress();
        },
      ),
    );
  }
}
