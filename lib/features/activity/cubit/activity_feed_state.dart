part of 'activity_feed_cubit.dart';

abstract class ActivityFeedState extends Equatable {
  const ActivityFeedState();

  @override
  List<Object> get props => [];
}

class ActivityFeedInProgress extends ActivityFeedState {}

class ActivityFeedLoaded extends ActivityFeedState {
  const ActivityFeedLoaded(this.feedItemsData);

  final List<ActivityFeedItemData> feedItemsData;

  @override
  List<Object> get props => [feedItemsData];
}

class ActivityFeedEmpty extends ActivityFeedState {}
