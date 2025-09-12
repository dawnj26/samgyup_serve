import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:device_repository/device_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_event.dart';
part 'app_state.dart';
part 'app_bloc.freezed.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({
    required AuthenticationRepository authenticationRepository,
    required DeviceRepository deviceRepository,
  }) : _authenticationRepository = authenticationRepository,
       _deviceRepository = deviceRepository,
       super(const _Initial()) {
    on<_Started>(_onStarted);
    on<_Logout>(_onLogout);
    on<_Login>(_onLogin);
  }

  final DeviceRepository _deviceRepository;
  final AuthenticationRepository _authenticationRepository;

  Future<void> _onStarted(_Started event, Emitter<AppState> emit) async {
    emit(state.copyWith(status: AppStatus.loading));

    var deviceStatus = DeviceStatus.unregistered;
    Device? device;

    try {
      device = await _deviceRepository.getDevice();
    } on ResponseException {
      device = await _deviceRepository.addDevice();
    } on DeviceNotSupported {
      deviceStatus = DeviceStatus.unknown;
    }

    if (device != null && device.tableId != null) {
      deviceStatus = DeviceStatus.registered;
    }

    try {
      final user = await _authenticationRepository.currentUser;

      if (user == User.empty()) {
        emit(
          state.copyWith(
            status: AppStatus.success,
            authStatus: AuthStatus.unauthenticated,
            deviceStatus: deviceStatus,
            device: device,
            user: null,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: AppStatus.success,
            authStatus: AuthStatus.authenticated,
            deviceStatus: deviceStatus,
            device: device,
            user: user,
          ),
        );
      }
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: AppStatus.failure,
          authStatus: AuthStatus.unauthenticated,
          deviceStatus: deviceStatus,
          device: device,
          errorMessage: e.toString(),
          user: null,
        ),
      );
    }
  }

  Future<void> _onLogin(_Login event, Emitter<AppState> emit) async {
    emit(
      state.copyWith(
        authStatus: AuthStatus.authenticated,
        user: event.user,
      ),
    );
  }

  Future<void> _onLogout(_Logout event, Emitter<AppState> emit) async {
    if (state.authStatus == AuthStatus.unauthenticated ||
        state.authStatus == AuthStatus.unauthenticating) {
      return;
    }

    emit(
      state.copyWith(
        authStatus: AuthStatus.unauthenticating,
      ),
    );
    await Future<void>.delayed(const Duration(milliseconds: 500));

    await _authenticationRepository.logOut();

    emit(
      state.copyWith(
        authStatus: AuthStatus.unauthenticated,
        user: null,
      ),
    );
  }
}
