import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:samgyup_serve/shared/form/email.dart';
import 'package:samgyup_serve/shared/form/password.dart';

part 'login_event.dart';
part 'login_state.dart';
part 'login_bloc.freezed.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required AuthenticationRepository authenticationRepository,
  }) : _authenticationRepository = authenticationRepository,
       super(const LoginInitial()) {
    on<_EmailChanged>(_onEmailChanged);
    on<_PasswordChanged>(_onPasswordChanged);
    on<_Submitted>(_loginSubmitted);
  }

  final AuthenticationRepository _authenticationRepository;

  void _onEmailChanged(
    _EmailChanged event,
    Emitter<LoginState> emit,
  ) {
    final email = Email.dirty(event.email);
    emit(
      LoginDirty(
        email: email,
        password: state.password,
        isValid: Formz.validate([email, state.password]),
      ),
    );
  }

  void _onPasswordChanged(
    _PasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    final password = Password.dirty(event.password);
    emit(
      LoginDirty(
        email: state.email,
        password: password,
        isValid: Formz.validate([state.email, password]),
      ),
    );
  }

  Future<void> _loginSubmitted(
    _Submitted _,
    Emitter<LoginState> emit,
  ) async {
    final isValid = Formz.validate([state.email, state.password]);
    if (isValid) {
      await _handleLogin(emit);
    } else {
      emit(
        LoginDirty(
          email: Email.dirty(state.email.value),
          password: Password.dirty(state.password.value),
          isValid: isValid,
        ),
      );
    }
  }

  Future<void> _handleLogin(
    Emitter<LoginState> emit,
  ) async {
    emit(
      LoginLoading(
        email: state.email,
        password: state.password,
        isValid: state.isValid,
      ),
    );
    try {
      await _authenticationRepository.logInWithEmailAndPassword(
        email: state.email.value,
        password: state.password.value,
      );

      final user = await _authenticationRepository.currentUser;

      emit(
        LoginSuccess(
          email: state.email,
          password: state.password,
          isValid: state.isValid,
          user: user,
        ),
      );
    } on LogInWithEmailAndPasswordFailure catch (e) {
      emit(
        LoginFailure(
          email: state.email,
          password: state.password,
          message: e.message,
          isValid: state.isValid,
        ),
      );
    }
  }
}
