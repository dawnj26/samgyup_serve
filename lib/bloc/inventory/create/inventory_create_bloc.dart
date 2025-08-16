import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'inventory_create_event.dart';
part 'inventory_create_state.dart';
part 'inventory_create_bloc.freezed.dart';

class InventoryCreateBloc
    extends Bloc<InventoryCreateEvent, InventoryCreateState> {
  InventoryCreateBloc() : super(const _Initial()) {
    on<InventoryCreateEvent>((event, emit) {
      // TODO(create): implement event handler
    });
  }
}
