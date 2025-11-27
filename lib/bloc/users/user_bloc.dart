import 'dart:async';

import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:samgyup_serve/shared/enums/loading_status.dart';

part 'user_event.dart';
part 'user_state.dart';
part 'user_bloc.freezed.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc({
    required AuthenticationRepository authenticationRepository,
  }) : _authenticationRepository = authenticationRepository,
       super(
         _Initial(
           user: User.empty(),
         ),
       ) {
    on<_Started>(_onStarted);
  }

  final AuthenticationRepository _authenticationRepository;

  FutureOr<void> _onStarted(_Started event, Emitter<UserState> emit) async {
    emit(state.copyWith(status: LoadingStatus.loading));

    try {
      final user = await _authenticationRepository.fetchUserById(event.userId);

      emit(
        state.copyWith(
          user: user,
          status: LoadingStatus.success,
        ),
      );
    } on ResponseException catch (e) {
      emit(
        state.copyWith(
          status: LoadingStatus.failure,
          errorMessage: e.message,
        ),
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
