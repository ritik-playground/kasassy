part of 'timeline_cubit.dart';

abstract class TimelineState extends Equatable {
  const TimelineState();

  @override
  List<Object> get props => [];
}

class TimelineInProgress extends TimelineState {}

class TimelineLoaded extends TimelineState {
  const TimelineLoaded(this.posts);

  final List<PostData> posts;

  @override
  List<Object> get props => [posts];
}

class TimelineEmpty extends TimelineState {}
