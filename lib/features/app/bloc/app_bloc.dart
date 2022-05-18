import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kasassy/data/models/user.dart';
import 'package:kasassy/data/repositories/authentication_repository.dart';
import 'package:kasassy/data/repositories/database_repository.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({
    required AuthenticationRepository authenticationRepository,
    required DatabaseRepository userDataRepository,
  })  : _authenticationRepository = authenticationRepository,
        _userDataRepository = userDataRepository,
        super(const AppState.splashscreen()) {
    on<AppUserChanged>(_onUserChanged);
    on<AppLogoutRequested>(_onLogoutRequested);
    on<CheckProfileComplete>(_checkProfileComplete);
    userSubscription = _authenticationRepository.getCurrentUserStream().listen(
      (user) {
        add(AppUserChanged(user));
      },
    );
  }

  StreamSubscription<User?>? userSubscription;
  final DatabaseRepository _userDataRepository;
  final AuthenticationRepository _authenticationRepository;

  Future<void> _checkProfileComplete(
    CheckProfileComplete event,
    Emitter<AppState> emit,
  ) async {
    emit(
      const AppState.splashscreen(),
    );
    final isProfileComplete =
        await _userDataRepository.isProfileComplete(event.user);
    if (isProfileComplete != null) {
      emit(AppState.authenticated(isProfileComplete));
    } else {
      emit(AppState.halfauthenticated(event.user));
    }
  }

  void _onUserChanged(AppUserChanged event, Emitter<AppState> emit) {
    if (event.user != null) {
      add(
        CheckProfileComplete(event.user!),
      );
    } else {
      emit(
        const AppState.unauthenticated(),
      );
      userSubscription?.pause();
    }
  }

  void _onLogoutRequested(AppLogoutRequested event, Emitter<AppState> emit) {
    unawaited(_authenticationRepository.signOutUser());
  }

  @override
  Future<void> close() {
    userSubscription?.cancel();
    return super.close();
  }
}
