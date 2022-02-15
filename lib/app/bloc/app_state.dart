part of 'app_bloc.dart';

enum AppStatus {
  authenticated,
  unauthenticated,
  halfauthenticated,
  splashscreen,
}

class AppState extends Equatable {
  const AppState._({
    this.status = AppStatus.splashscreen,
    this.currentUser,
    this.currentUserData,
  });

  const AppState.splashscreen() : this._();

  const AppState.authenticated(UserData userData)
      : this._(status: AppStatus.authenticated, currentUserData: userData);

  const AppState.halfauthenticated(User user)
      : this._(status: AppStatus.halfauthenticated, currentUser: user);

  const AppState.unauthenticated() : this._(status: AppStatus.unauthenticated);

  final User? currentUser;
  final UserData? currentUserData;
  final AppStatus status;

  @override
  List<Object?> get props => [
        currentUser,
        currentUserData,
        status,
      ];
}
