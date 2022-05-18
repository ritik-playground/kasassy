import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:kasassy/data/repositories/authentication_repository.dart';
import 'package:kasassy/features/app/bloc/app_bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({
    required AuthenticationRepository authenticationRepository,
    required AppBloc appBloc,
  })  : _authenticationRepository = authenticationRepository,
        _appBloc = appBloc,
        super(
          const LoginState(),
        );

  final AuthenticationRepository _authenticationRepository;
  final AppBloc _appBloc;

  Future<void> logInWithGoogle() async {
    emit(
      state.copyWith(status: FormzStatus.submissionInProgress),
    );
    try {
      await _authenticationRepository.signInWithGoogle();
      emit(
        state.copyWith(status: FormzStatus.submissionSuccess),
      );
      _appBloc.userSubscription?.resume();
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
