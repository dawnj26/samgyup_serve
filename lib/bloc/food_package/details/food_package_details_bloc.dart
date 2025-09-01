import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:package_repository/package_repository.dart';

part 'food_package_details_bloc.freezed.dart';
part 'food_package_details_event.dart';
part 'food_package_details_state.dart';

class FoodPackageDetailsBloc
    extends Bloc<FoodPackageDetailsEvent, FoodPackageDetailsState> {
  FoodPackageDetailsBloc({
    required PackageRepository packageRepository,
    required FoodPackage package,
  }) : _packageRepository = packageRepository,
       super(FoodPackageDetailsInitial(package: package)) {}

  final PackageRepository _packageRepository;
}
