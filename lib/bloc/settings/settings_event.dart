part of 'settings_bloc.dart';

@freezed
abstract class SettingsEvent with _$SettingsEvent {
  const factory SettingsEvent.nameChanged(String name) = _NameChanged;
  const factory SettingsEvent.logoChanged(PlatformFile? logo) = _LogoChanged;
  const factory SettingsEvent.qrChanged(PlatformFile? qr) = _QrChanged;
}
