import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:device_repository/device_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:samgyup_serve/data/models/device_data.dart';
import 'package:settings_repository/settings_repository.dart';
import 'package:table_repository/table_repository.dart';

part 'app_event.dart';
part 'app_state.dart';
part 'app_bloc.freezed.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({
    required AuthenticationRepository authenticationRepository,
    required DeviceRepository deviceRepository,
    required TableRepository tableRepository,
    required SettingsRepository settingsRepository,
  }) : _authenticationRepository = authenticationRepository,
       _deviceRepository = deviceRepository,
       _tableRepository = tableRepository,
       _settingsRepository = settingsRepository,
       super(
         _Initial(
           settings: Settings.empty(),
         ),
       ) {
    on<_Started>(_onStarted);
    on<_Logout>(_onLogout);
    on<_Login>(_onLogin);
    on<_CheckDevice>(_onCheckDevice);
    on<_GuestSessionStarted>(_onGuestSessionStarted);
    on<_SettingsChanged>(_onSettingsChanged);
  }

  final DeviceRepository _deviceRepository;
  final AuthenticationRepository _authenticationRepository;
  final TableRepository _tableRepository;
  final SettingsRepository _settingsRepository;

  Future<void> _onSettingsChanged(
    _SettingsChanged event,
    Emitter<AppState> emit,
  ) async {
    emit(
      state.copyWith(
        settings: event.settings,
      ),
    );
  }

  Future<void> _onCheckDevice(
    _CheckDevice event,
    Emitter<AppState> emit,
  ) async {
    emit(state.copyWith(status: AppStatus.loading));

    var deviceStatus = DeviceStatus.unregistered;
    final deviceData = await _getDeviceData();

    if (deviceData == null) {
      deviceStatus = DeviceStatus.unknown;
    } else if (deviceData.table != null) {
      deviceStatus = DeviceStatus.registered;
    }

    emit(
      state.copyWith(
        status: AppStatus.success,
        deviceStatus: deviceStatus,
        deviceData: deviceData,
      ),
    );
  }

  Future<void> _onStarted(_Started event, Emitter<AppState> emit) async {
    emit(state.copyWith(status: AppStatus.loading));

    var deviceStatus = DeviceStatus.unregistered;
    final deviceData = await _getDeviceData();

    if (deviceData == null) {
      deviceStatus = DeviceStatus.unknown;
    } else if (deviceData.table != null) {
      deviceStatus = DeviceStatus.registered;
    }

    try {
      final user = await _authenticationRepository.currentUser;
      final settings = await _settingsRepository.fetchSettings();

      if (user == User.empty()) {
        emit(
          state.copyWith(
            status: AppStatus.success,
            authStatus: AuthStatus.unauthenticated,
            deviceStatus: deviceStatus,
            deviceData: deviceData,
            settings: settings,
            user: null,
          ),
        );
      } else if (user.isGuest) {
        emit(
          state.copyWith(
            status: AppStatus.success,
            authStatus: AuthStatus.guest,
            deviceStatus: deviceStatus,
            settings: settings,
            deviceData: deviceData,
            user: user,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: AppStatus.success,
            authStatus: AuthStatus.authenticated,
            deviceStatus: deviceStatus,
            settings: settings,
            deviceData: deviceData,
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
          deviceData: deviceData,
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

  Future<void> _onGuestSessionStarted(
    _GuestSessionStarted event,
    Emitter<AppState> emit,
  ) async {
    if (state.authStatus == AuthStatus.guest ||
        state.authStatus == AuthStatus.authenticated) {
      return;
    }

    emit(state.copyWith(status: AppStatus.loading));

    await _authenticationRepository.createGuestSession();
    final user = await _authenticationRepository.currentUser;

    var deviceStatus = DeviceStatus.unregistered;
    final deviceData = await _getDeviceData();

    if (deviceData == null) {
      deviceStatus = DeviceStatus.unknown;
    } else if (deviceData.table != null) {
      deviceStatus = DeviceStatus.registered;
    }

    emit(
      state.copyWith(
        status: AppStatus.success,
        deviceStatus: deviceStatus,
        deviceData: deviceData,
        authStatus: AuthStatus.guest,
        user: user,
      ),
    );
  }

  Future<DeviceData?> _getDeviceData() async {
    Device? device;
    Table? table;

    try {
      device = await _deviceRepository.getDevice();
    } on ResponseException {
      device = await _deviceRepository.addDevice();
    } on DeviceNotSupported {
      return null;
    }

    if (device.tableId != null) {
      try {
        table = await _tableRepository.fetchTable(device.tableId!);
      } on ResponseException {
        table = null;
      }
    }

    return DeviceData(device: device, table: table);
  }
}
