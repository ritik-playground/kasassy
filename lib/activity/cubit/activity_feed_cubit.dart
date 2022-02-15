import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kasassy/data/models/notification.dart';
import 'package:kasassy/data/repositories/authentication_repository.dart';
import 'package:kasassy/data/repositories/database_repository.dart';

part 'activity_feed_state.dart';

class ActivityFeedCubit extends Cubit<ActivityFeedState> {
  ActivityFeedCubit({
    required DatabaseRepository userDataRepository,
    required AuthenticationRepository authenticationRepository,
  })  : _userDataRepository = userDataRepository,
        _authenticationRepository = authenticationRepository,
        super(
          ActivityFeedInProgress(),
        );

  final DatabaseRepository _userDataRepository;
  final AuthenticationRepository _authenticationRepository;
  StreamSubscription? _feedItemsDataSubscription;

  Future<void> activityLaunch() async {
    final currentUserData = _authenticationRepository.getCurrentUser();
    final feedItemsDataStream =
        _userDataRepository.getActivityFeed(currentUserData!.uid);
    await _feedItemsDataSubscription?.cancel();
    _feedItemsDataSubscription = feedItemsDataStream.listen(
      (feedItemsData) {
        if (feedItemsData.isEmpty) {
          emit(
            ActivityFeedEmpty(),
          );
        } else {
          emit(
            ActivityFeedLoaded(feedItemsData),
          );
        }
      },
    );
  }

  @override
  Future<void> close() {
    _feedItemsDataSubscription?.cancel();
    return super.close();
  }
}
