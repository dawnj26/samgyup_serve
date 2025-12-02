import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:log_repository/log_repository.dart';
import 'package:samgyup_serve/shared/enums/loading_status.dart';
import 'package:settings_repository/settings_repository.dart';

part 'settings_event.dart';
part 'settings_state.dart';
part 'settings_bloc.freezed.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc({
    required SettingsRepository settingsRepository,
    required Settings initialSettings,
  }) : _settingsRepository = settingsRepository,
       super(
         _Initial(
           settings: initialSettings,
         ),
       ) {
    on<_NameChanged>(_onNameChanged);
    on<_LogoChanged>(_onLogoChanged);
    on<_QrChanged>(_onQrChanged);
  }

  final SettingsRepository _settingsRepository;

  Future<void> _onNameChanged(
    _NameChanged event,
    Emitter<SettingsState> emit,
  ) async {
    final updatedSettings = state.settings.copyWith(
      businessName: event.name,
    );

    if (updatedSettings == state.settings) return;

    try {
      emit(
        state.copyWith(
          status: LoadingStatus.loading,
        ),
      );

      await _settingsRepository.updateSettings(updatedSettings);

      await LogRepository.instance.logAction(
        action: LogAction.update,
        message: 'Business name updated to ${event.name}',
        resourceId: updatedSettings.id,
      );

      emit(
        state.copyWith(
          status: LoadingStatus.success,
          settings: updatedSettings,
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

  Future<void> _onLogoChanged(
    _LogoChanged event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          status: LoadingStatus.loading,
        ),
      );
      final fileId = event.logo != null
          ? await _settingsRepository.uploadBusinessLogo(event.logo!)
          : null;
      final settings = await _settingsRepository.updateSettings(
        state.settings.copyWith(
          businessLogo: fileId,
        ),
      );

      await LogRepository.instance.logAction(
        action: LogAction.update,
        message: 'Business logo updated',
        resourceId: settings.id,
      );

      emit(
        state.copyWith(
          status: LoadingStatus.success,
          settings: settings,
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

  Future<void> _onQrChanged(
    _QrChanged event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          status: LoadingStatus.loading,
        ),
      );
      final fileId = event.qr != null
          ? await _settingsRepository.uploadBusinessLogo(event.qr!)
          : null;
      final settings = await _settingsRepository.updateSettings(
        state.settings.copyWith(
          qrCode: fileId,
        ),
      );

      await _settingsRepository.updateSettings(settings);

      await LogRepository.instance.logAction(
        action: LogAction.update,
        message: 'Business QR code updated',
        resourceId: settings.id,
      );

      emit(
        state.copyWith(
          status: LoadingStatus.success,
          settings: settings,
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
