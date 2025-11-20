import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:samgyup_serve/shared/enums/loading_status.dart';

part 'users_action_event.dart';
part 'users_action_state.dart';
part 'users_action_bloc.freezed.dart';

class UsersActionBloc extends Bloc<UsersActionEvent, UsersActionState> {
  UsersActionBloc({
    required AuthenticationRepository authenticationRepository,
  }) : _authenticationRepository = authenticationRepository,
       super(const _Initial()) {
    on<_Deleted>(_onDeleted);
  }

  final AuthenticationRepository _authenticationRepository;

  FutureOr<void> _onDeleted(
    _Deleted event,
    Emitter<UsersActionState> emit,
  ) async {
    emit(state.copyWith(status: LoadingStatus.loading));
    try {
      await _authenticationRepository.deleteUser(event.userId);
      emit(
        state.copyWith(
          status: LoadingStatus.success,
          action: UserAction.delete,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: LoadingStatus.failure,
          action: UserAction.delete,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
