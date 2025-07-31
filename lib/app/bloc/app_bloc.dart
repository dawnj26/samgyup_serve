import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_event.dart';
part 'app_state.dart';
part 'app_bloc.freezed.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({
    required AuthenticationRepository authenticationRepository,
  }) : _authenticationRepository = authenticationRepository,
       super(const Initial()) {
    on<_Started>(_onStarted);
  }

  final AuthenticationRepository _authenticationRepository;

  Future<void> _onStarted(_Started event, Emitter<AppState> emit) async {
    return emit.onEach(
      _authenticationRepository.user,
      onData: (user) {
        emit(Authenticated(user: user));
      },
      onError: (error, stackTrace) {
        emit(
          Unauthenticated(
            errorMessage: error.toString(),
          ),
        );
      },
    );
  }
}
