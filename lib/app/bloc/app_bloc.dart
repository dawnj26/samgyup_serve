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
    on<_Login>(_onLogin);
  }

  final AuthenticationRepository _authenticationRepository;

  Future<void> _onStarted(_Started event, Emitter<AppState> emit) async {
    if (state is Authenticated) return;

    try {
      final user = await _authenticationRepository.currentUser;

      if (user == User.empty()) {
        emit(const Unauthenticated());
      } else {
        emit(Authenticated(user: user));
      }
    } on Exception catch (_) {
      emit(const Unauthenticated());
    }
  }

  void _onLogin(_Login event, Emitter<AppState> emit) {
    if (state is Authenticated) return;
    emit(Authenticated(user: event.user));
  }

  Future<void> _onLogout(_Logout event, Emitter<AppState> emit) async {
    if (state is Unauthenticated || state is Unauthenticating) return;

    emit(Unauthenticating(user: (state as Authenticated).user));
    await Future<void>.delayed(const Duration(milliseconds: 500));

    try {
      await _authenticationRepository.logOut();

      emit(const Unauthenticated());
    } on Exception catch (_) {
      emit(const Unauthenticated());
    }
  }
}
