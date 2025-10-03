import 'dart:io';

import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:settings_repository/settings_repository.dart';

part 'settings_event.dart';
part 'settings_state.dart';
part 'settings_bloc.freezed.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc({
    required SettingsRepository settingsRepository,
  }) : _settingsRepository = settingsRepository,
       super(const _Initial()) {
    on<_Started>(_onStarted);
    on<_QrCodeUpdated>(_onQrCodeUpdated);
  }

  final SettingsRepository _settingsRepository;

  Future<void> _onStarted(
    _Started event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(status: SettingsStatus.loading));
    try {
      final settings = await _settingsRepository.getSettings();
      emit(
        state.copyWith(
          status: SettingsStatus.success,
          settings: settings,
        ),
      );
    } on ResponseException catch (e) {
      emit(
        state.copyWith(
          status: SettingsStatus.failure,
          errorMessage: e.message,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: SettingsStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onQrCodeUpdated(
    _QrCodeUpdated event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(updateStatus: SettingUpdateStatus.loading));
    try {
      final updatedSetting = await _settingsRepository.updateQrSetting(
        event.file,
        event.qrSetting,
      );

      final updatedSettings = state.settings.map((setting) {
        return setting.id == updatedSetting.id ? updatedSetting : setting;
      }).toList();

      emit(
        state.copyWith(
          updateStatus: SettingUpdateStatus.success,
          settings: updatedSettings,
        ),
      );
    } on ResponseException catch (e) {
      emit(
        state.copyWith(
          updateStatus: SettingUpdateStatus.failure,
          errorMessage: e.message,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          updateStatus: SettingUpdateStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
