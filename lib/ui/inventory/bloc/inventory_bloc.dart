import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'inventory_event.dart';
part 'inventory_state.dart';
part 'inventory_bloc.freezed.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  InventoryBloc() : super(_Initial()) {
    on<InventoryEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
