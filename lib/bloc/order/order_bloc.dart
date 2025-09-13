import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:table_repository/table_repository.dart';

part 'order_event.dart';
part 'order_state.dart';
part 'order_bloc.freezed.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc({
    required TableRepository tableRepository,
    required String tableId,
  }) : _repo = tableRepository,
       _tableId = tableId,
       super(
         _Initial(
           table: Table(
             number: -1,
             capacity: -1,
             status: TableStatus.available,
           ),
         ),
       ) {
    on<_Started>(_onStarted);
  }

  final TableRepository _repo;
  final String _tableId;

  Future<void> _onStarted(_Started event, Emitter<OrderState> emit) async {
    emit(state.copyWith(status: OrderStatus.loading));

    try {
      final table = await _repo.fetchTable(_tableId);
      emit(
        state.copyWith(
          status: OrderStatus.success,
          table: table,
        ),
      );
    } on ResponseException catch (e) {
      emit(
        state.copyWith(
          status: OrderStatus.failure,
          errorMessage: e.message,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: OrderStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
