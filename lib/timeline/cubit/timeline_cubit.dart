import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kasassy/data/models/post.dart';
import 'package:kasassy/data/repositories/database_repository.dart';

part 'timeline_state.dart';

class TimelineCubit extends Cubit<TimelineState> {
  TimelineCubit({
    required DatabaseRepository userDataRepository,
  })  : _userDataRepository = userDataRepository,
        super(TimelineInProgress());

  final DatabaseRepository _userDataRepository;
  StreamSubscription? _timelinePostsStream;

  Future<void> launchTimeline() async {
    final timelinePosts = _userDataRepository.getTimeline();
    await _timelinePostsStream?.cancel();
    _timelinePostsStream = timelinePosts.listen(
      (event) {
        emit(
          TimelineLoaded(event),
        );
      },
    );
  }

  Future<void> updateTimeline({required List<PostData> posts}) async {
    if (posts.isEmpty) {
      emit(TimelineEmpty());
    } else {
      emit(TimelineLoaded(posts));
    }
  }

  @override
  Future<void> close() {
    _timelinePostsStream?.cancel();
    return super.close();
  }
}
