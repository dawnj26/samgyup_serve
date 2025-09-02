import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'food_package_edit_bloc.freezed.dart';
part 'food_package_edit_event.dart';
part 'food_package_edit_state.dart';

class FoodPackageEditBloc
    extends Bloc<FoodPackageEditEvent, FoodPackageEditState> {
  FoodPackageEditBloc() : super(const FoodPackageEditState.initial()) {
    on<FoodPackageEditEvent>((event, emit) {
      // TODO(edit): implement event handler
    });
  }
}
