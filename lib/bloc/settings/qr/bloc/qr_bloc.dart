import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:settings_repository/settings_repository.dart';

part 'qr_event.dart';
part 'qr_state.dart';
part 'qr_bloc.freezed.dart';

class QrBloc extends Bloc<QrEvent, QrState> {
  QrBloc({
    required SettingsRepository settingsRepository,
  }) : _settingsRepository = settingsRepository,
       super(const _Initial()) {
    on<_Started>(_onStarted);
  }

  final SettingsRepository _settingsRepository;

  Future<void> _onStarted(
    _Started event,
    Emitter<QrState> emit,
  ) async {
    emit(state.copyWith(status: QrStatus.loading));
    try {
      final setting = await _settingsRepository.getQrFileId();

      if (setting != null) {
        emit(
          state.copyWith(
            status: QrStatus.success,
            fileId: setting,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: QrStatus.failure,
            errorMessage: 'QR code not found',
          ),
        );
      }
    } on ResponseException catch (e) {
      emit(
        state.copyWith(
          status: QrStatus.failure,
          errorMessage: e.message,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: QrStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
