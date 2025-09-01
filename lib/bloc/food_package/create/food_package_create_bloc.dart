import 'dart:io';

import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:package_repository/package_repository.dart';
import 'package:samgyup_serve/shared/form/inventory/description.dart';
import 'package:samgyup_serve/shared/form/name.dart';
import 'package:samgyup_serve/shared/form/price.dart';
import 'package:samgyup_serve/shared/form/time_limit.dart';

part 'food_package_create_bloc.freezed.dart';
part 'food_package_create_event.dart';
part 'food_package_create_state.dart';

class FoodPackageCreateBloc
    extends Bloc<FoodPackageCreateEvent, FoodPackageCreateState> {
  FoodPackageCreateBloc({
    required PackageRepository packageRepository,
  }) : _packageRepository = packageRepository,
       super(const FoodPackageCreateInitial()) {
    on<_NameChanged>(_onNameChanged);
    on<_DescriptionChanged>(_onDescriptionChanged);
    on<_PriceChanged>(_onPriceChanged);
    on<_TimeLimitChanged>(_onTimeLimitChanged);
    on<_ImageChanged>(_onImageChanged);
    on<_Submitted>(_onSubmitted);
  }

  final PackageRepository _packageRepository;

  void _onNameChanged(
    _NameChanged event,
    Emitter<FoodPackageCreateState> emit,
  ) {
    final name = Name.dirty(event.name);
    emit(
      FoodPackageCreateChanged(
        name: name,
        description: state.description,
        price: state.price,
        timeLimit: state.timeLimit,
        image: state.image,
      ),
    );
  }

  void _onDescriptionChanged(
    _DescriptionChanged event,
    Emitter<FoodPackageCreateState> emit,
  ) {
    final description = Description.dirty(event.description);
    emit(
      FoodPackageCreateChanged(
        name: state.name,
        description: description,
        price: state.price,
        timeLimit: state.timeLimit,
        image: state.image,
      ),
    );
  }

  void _onPriceChanged(
    _PriceChanged event,
    Emitter<FoodPackageCreateState> emit,
  ) {
    final price = Price.dirty(event.price);
    emit(
      FoodPackageCreateChanged(
        name: state.name,
        description: state.description,
        price: price,
        timeLimit: state.timeLimit,
        image: state.image,
      ),
    );
  }

  void _onTimeLimitChanged(
    _TimeLimitChanged event,
    Emitter<FoodPackageCreateState> emit,
  ) {
    final timeLimit = TimeLimit.dirty(event.timeLimit);
    emit(
      FoodPackageCreateChanged(
        name: state.name,
        description: state.description,
        price: state.price,
        timeLimit: timeLimit,
        image: state.image,
      ),
    );
  }

  void _onImageChanged(
    _ImageChanged event,
    Emitter<FoodPackageCreateState> emit,
  ) {
    emit(
      FoodPackageCreateChanged(
        name: state.name,
        description: state.description,
        price: state.price,
        timeLimit: state.timeLimit,
        image: event.image,
      ),
    );
  }

  Future<void> _onSubmitted(
    _Submitted event,
    Emitter<FoodPackageCreateState> emit,
  ) async {
    final name = Name.dirty(state.name.value);
    final description = Description.dirty(state.description.value);
    final price = Price.dirty(state.price.value);
    final timeLimit = TimeLimit.dirty(state.timeLimit.value);

    final isFormValid = Formz.validate([
      name,
      description,
      price,
      timeLimit,
    ]);

    if (!isFormValid) {
      return emit(
        FoodPackageCreateChanged(
          name: name,
          description: description,
          price: price,
          timeLimit: timeLimit,
          image: state.image,
        ),
      );
    }

    emit(
      FoodPackageCreateCreating(
        name: name,
        description: description,
        price: price,
        timeLimit: timeLimit,
        image: state.image,
      ),
    );

    try {
      final package = FoodPackage(
        name: name.value,
        description: description.value,
        price: double.parse(price.value),
        timeLimit: int.parse(timeLimit.value),
        createdAt: DateTime.now(),
        menuIds: [],
      );
      final newPackage = await _packageRepository.createPackage(
        package: package,
        image: state.image,
      );

      emit(FoodPackageCreateSuccess(foodPackage: newPackage));
    } on ResponseException catch (e) {
      emit(
        FoodPackageCreateFailure(
          errorMessage: e.message,
          name: name,
          description: description,
          price: price,
          timeLimit: timeLimit,
          image: state.image,
        ),
      );
    } on Exception catch (e) {
      emit(
        FoodPackageCreateFailure(
          errorMessage: e.toString(),
          name: name,
          description: description,
          price: price,
          timeLimit: timeLimit,
          image: state.image,
        ),
      );
    }
  }
}
