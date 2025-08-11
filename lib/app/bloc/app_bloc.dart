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
    on<_Logout>(_onLogout);
  }

  final AuthenticationRepository _authenticationRepository;

  Future<void> _onStarted(_Started event, Emitter<AppState> emit) async {
    return emit.onEach(
      _authenticationRepository.user,
      onData: (user) {
        if (user == User.empty()) {
          return emit(const Unauthenticated());
        }

        emit(Authenticated(user: user));
      },
      onError: addError,
    );
  }

  Future<void> _onLogout(_Logout event, Emitter<AppState> emit) async {
    if (state is Unauthenticated || state is Unauthenticating) return;

    emit(Unauthenticating(user: (state as Authenticated).user));
    await Future<void>.delayed(const Duration(milliseconds: 500));

    await _authenticationRepository.logOut();
  }
}
