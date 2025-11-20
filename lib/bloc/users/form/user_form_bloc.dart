import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:samgyup_serve/shared/form/email.dart';
import 'package:samgyup_serve/shared/form/name.dart';
import 'package:samgyup_serve/shared/form/password_input.dart';

part 'user_form_event.dart';
part 'user_form_state.dart';
part 'user_form_bloc.freezed.dart';

class UserFormBloc extends Bloc<UserFormEvent, UserFormState> {
  UserFormBloc({
    required AuthenticationRepository authenticationRepository,
    User? user,
  }) : _authenticationRepository = authenticationRepository,
       _user = user,
       super(
         user == null
             ? const _Initial()
             : _Initial(
                 name: Name.pure(user.name ?? ''),
                 email: Email.pure(user.email ?? ''),
               ),
       ) {
    on<_NameChanged>(_onNameChanged);
    on<_EmailChanged>(_onEmailChanged);
    on<_PasswordChanged>(_onPasswordChanged);
    on<_Submitted>(_onSubmitted);
  }

  final AuthenticationRepository _authenticationRepository;
  final User? _user;

  bool get isEditMode => _user != null;

  FutureOr<void> _onNameChanged(
    _NameChanged event,
    Emitter<UserFormState> emit,
  ) async {
    final name = Name.dirty(event.name);
    emit(
      state.copyWith(
        name: name,
      ),
    );
  }

  FutureOr<void> _onEmailChanged(
    _EmailChanged event,
    Emitter<UserFormState> emit,
  ) {
    final email = Email.dirty(event.email);
    emit(
      state.copyWith(
        email: email,
      ),
    );
  }

  FutureOr<void> _onPasswordChanged(
    _PasswordChanged event,
    Emitter<UserFormState> emit,
  ) {
    final password = PasswordInput.dirty(event.password);

    emit(
      state.copyWith(
        password: password,
      ),
    );
  }

  FutureOr<void> _onSubmitted(
    _Submitted event,
    Emitter<UserFormState> emit,
  ) async {
    final name = Name.dirty(state.name.value);
    final email = Email.dirty(state.email.value);
    final password = PasswordInput.dirty(state.password.value);

    //
    // ignore: omit_local_variable_types
    final List<FormzInput<dynamic, dynamic>> fields = !isEditMode
        ? [name, email, password]
        : [name, email];

    final isValid = Formz.validate(fields);

    if (!isValid) {
      emit(
        state.copyWith(
          name: name,
          email: email,
          password: password,
          status: FormzSubmissionStatus.initial,
        ),
      );
      return;
    }

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      if (isEditMode) {
        await _authenticationRepository.updateUser(
          User(id: _user!.id, name: name.value, email: email.value),
        );
      } else {
        await _authenticationRepository.createUser(
          email: email.value,
          password: password.value,
          name: name.value,
        );
      }
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
