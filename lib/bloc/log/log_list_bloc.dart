import 'dart:async';

import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:log_repository/log_repository.dart';
import 'package:samgyup_serve/shared/enums/loading_status.dart';
import 'package:samgyup_serve/shared/stream.dart';

part 'log_list_event.dart';
part 'log_list_state.dart';
part 'log_list_bloc.freezed.dart';

class LogListBloc extends Bloc<LogListEvent, LogListState> {
  LogListBloc()
    : _logRepository = LogRepository.instance,
      super(const _Initial()) {
    on<_Started>(_onStarted);
    on<_LoadMore>(
      _onLoadMore,
      transformer: throttleDroppable(const Duration(milliseconds: 500)),
    );
    on<_Refresh>(_onRefresh);
    on<_FilterByAction>(_onFilterByAction);
  }

  final LogRepository _logRepository;
  final int _pageSize = 10;

  FutureOr<void> _onStarted(_Started event, Emitter<LogListState> emit) async {
    emit(state.copyWith(status: LoadingStatus.loading));

    try {
      final logs = await _logRepository.fetchLogs(
        limit: _pageSize,
        action: state.action,
      );

      emit(
        state.copyWith(
          logs: logs,
          hasReachedMax: logs.length < _pageSize,
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

  FutureOr<void> _onLoadMore(
    _LoadMore event,
    Emitter<LogListState> emit,
  ) async {
    if (state.hasReachedMax) return;

    try {
      final lastDocId = state.logs.isNotEmpty ? state.logs.last.id : null;
      final logs = await _logRepository.fetchLogs(
        limit: _pageSize,
        action: state.action,
        lastId: lastDocId,
      );

      emit(
        state.copyWith(
          logs: [...state.logs, ...logs],
          hasReachedMax: logs.length < _pageSize,
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

  FutureOr<void> _onRefresh(_Refresh event, Emitter<LogListState> emit) {
    add(const LogListEvent.started());
  }

  FutureOr<void> _onFilterByAction(
    _FilterByAction event,
    Emitter<LogListState> emit,
  ) {
    emit(
      state.copyWith(
        action: event.action,
      ),
    );
    add(const LogListEvent.started());
  }
}
