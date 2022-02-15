import 'package:firebase_auth/firebase_auth.dart';
import 'package:kasassy/data/providers/_base_provider.dart';
import 'package:kasassy/data/providers/authentication_provider.dart';

class AuthenticationRepository {
  AuthenticationRepository({
    BaseAuthenticationProvider? baseAuthenticationProvider,
  }) : _authenticationProvider =
            baseAuthenticationProvider ?? AuthenticationProvider();

  final BaseAuthenticationProvider _authenticationProvider;

  Future<void> signInWithGoogle() => _authenticationProvider.signInWithGoogle();

  Future<void> signOutUser() => _authenticationProvider.signOutUser();

  Stream<User?> getCurrentUserStream() => _authenticationProvider.user();

  User? getCurrentUser() => _authenticationProvider.currentUser;

  void dispose() {
    _authenticationProvider.dispose();
  }
}
