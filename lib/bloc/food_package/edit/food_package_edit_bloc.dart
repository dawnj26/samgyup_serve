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

part 'food_package_edit_bloc.freezed.dart';
part 'food_package_edit_event.dart';
part 'food_package_edit_state.dart';

class FoodPackageEditBloc
    extends Bloc<FoodPackageEditEvent, FoodPackageEditState> {
  FoodPackageEditBloc({
    required PackageRepository packageRepository,
    required FoodPackage package,
  }) : _repo = packageRepository,
       _package = package,
       super(
         FoodPackageEditInitial(
           name: Name.pure(package.name),
           description: Description.pure(package.description),
           price: Price.pure(package.price.toString()),
           timeLimit: TimeLimit.pure(package.timeLimit.toString()),
         ),
       ) {
    on<_NameChanged>(_onNameChanged);
    on<_DescriptionChanged>(_onDescriptionChanged);
    on<_PriceChanged>(_onPriceChanged);
    on<_TimeLimitChanged>(_onTimeLimitChanged);
    on<_ImageChanged>(_onImageChanged);
    on<_Submitted>(_onSubmitted);
  }

  final PackageRepository _repo;
  final FoodPackage _package;

  void _onNameChanged(
    _NameChanged event,
    Emitter<FoodPackageEditState> emit,
  ) {
    final name = Name.dirty(event.name);
    emit(
      FoodPackageEditChanged(
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
    Emitter<FoodPackageEditState> emit,
  ) {
    final description = Description.dirty(event.description);
    emit(
      FoodPackageEditChanged(
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
    Emitter<FoodPackageEditState> emit,
  ) {
    final price = Price.dirty(event.price);
    emit(
      FoodPackageEditChanged(
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
    Emitter<FoodPackageEditState> emit,
  ) {
    final timeLimit = TimeLimit.dirty(event.timeLimit);
    emit(
      FoodPackageEditChanged(
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
    Emitter<FoodPackageEditState> emit,
  ) {
    emit(
      FoodPackageEditChanged(
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
    Emitter<FoodPackageEditState> emit,
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
        FoodPackageEditChanged(
          name: name,
          description: description,
          price: price,
          timeLimit: timeLimit,
          image: state.image,
        ),
      );
    }

    try {
      final p = _package.copyWith(
        name: name.value,
        description: description.value,
        price: double.parse(price.value),
        timeLimit: int.parse(timeLimit.value),
      );

      if (p == _package && state.image == null) {
        return emit(
          FoodPackageEditNoChanges(
            name: name,
            description: description,
            price: price,
            timeLimit: timeLimit,
            image: state.image,
          ),
        );
      }

      emit(
        FoodPackageEditLoading(
          name: name,
          description: description,
          price: price,
          timeLimit: timeLimit,
          image: state.image,
        ),
      );

      final updatedPackage = await _repo.updatePackage(
        package: p,
        image: state.image,
      );

      emit(
        FoodPackageEditSuccess(
          name: name,
          description: description,
          price: price,
          timeLimit: timeLimit,
          image: state.image,
          package: updatedPackage,
        ),
      );
    } on ResponseException catch (e) {
      emit(
        FoodPackageEditFailure(
          name: name,
          description: description,
          price: price,
          timeLimit: timeLimit,
          image: state.image,
          errorMessage: e.message,
        ),
      );
    } on Exception catch (e) {
      emit(
        FoodPackageEditFailure(
          name: name,
          description: description,
          price: price,
          timeLimit: timeLimit,
          image: state.image,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
