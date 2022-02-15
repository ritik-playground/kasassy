import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:kasassy/data/repositories/authentication_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authenticationRepository)
      : super(
          const LoginState(),
        );

  final AuthenticationRepository _authenticationRepository;

  Future<void> logInWithGoogle() async {
    emit(
      state.copyWith(status: FormzStatus.submissionInProgress),
    );
    try {
      await _authenticationRepository.signInWithGoogle();
      emit(
        state.copyWith(status: FormzStatus.submissionSuccess),
      );
    } on Exception {
      emit(
        state.copyWith(status: FormzStatus.submissionFailure),
      );
    } catch (e) {
      emit(
        state.copyWith(status: FormzStatus.pure),
      );
    }
  }
}
