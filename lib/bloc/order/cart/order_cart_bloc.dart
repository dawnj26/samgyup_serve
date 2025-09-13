import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_cart_event.dart';
part 'order_cart_state.dart';
part 'order_cart_bloc.freezed.dart';

class OrderCartBloc extends Bloc<OrderCartEvent, OrderCartState> {
  OrderCartBloc() : super(_Initial()) {
    on<OrderCartEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
