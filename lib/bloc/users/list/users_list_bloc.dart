import 'dart:async';

import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:samgyup_serve/shared/enums/loading_status.dart';

part 'users_list_event.dart';
part 'users_list_state.dart';
part 'users_list_bloc.freezed.dart';

class UsersListBloc extends Bloc<UsersListEvent, UsersListState> {
  UsersListBloc({
    required AuthenticationRepository authenticationRepository,
  }) : _authenticationRepository = authenticationRepository,
       super(const _Initial()) {
    on<_Started>(_onStarted);
  }

  final AuthenticationRepository _authenticationRepository;

  FutureOr<void> _onStarted(
    _Started event,
    Emitter<UsersListState> emit,
  ) async {
    emit(state.copyWith(status: LoadingStatus.loading));
    try {
      final users = await _authenticationRepository.fetchUsers();
      emit(
        state.copyWith(
          users: users,
          status: LoadingStatus.success,
        ),
      );
    } on ResponseException catch (e) {
      emit(
        state.copyWith(status: LoadingStatus.failure, errorMessage: e.message),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: LoadingStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
