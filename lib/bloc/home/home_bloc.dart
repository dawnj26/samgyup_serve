import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_event.dart';
part 'home_state.dart';
part 'home_bloc.freezed.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const _Initial()) {
    on<_StatusChanged>(_onStatusChanged);
  }

  Future<void> _onStatusChanged(
    _StatusChanged event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: event.status));
  }
}
