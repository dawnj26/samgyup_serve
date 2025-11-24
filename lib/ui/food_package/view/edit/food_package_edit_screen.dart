import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_repository/package_repository.dart';
import 'package:samgyup_serve/bloc/food_package/edit/food_package_edit_bloc.dart';
import 'package:samgyup_serve/shared/form/inventory/description.dart';
import 'package:samgyup_serve/shared/form/name.dart';
import 'package:samgyup_serve/shared/form/price.dart';
import 'package:samgyup_serve/shared/form/time_limit.dart';
import 'package:samgyup_serve/ui/components/components.dart';
import 'package:samgyup_serve/ui/food_package/components/components.dart';

class FoodPackageEditScreen extends StatelessWidget {
  const FoodPackageEditScreen({required this.package, super.key});

  final FoodPackage package;

  @override
  Widget build(BuildContext context) {
    return FormScaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            pinned: true,
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Edit Package'),
            ),
          ),
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: kIsWeb ? 1200 : double.infinity,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _NameInput(initialValue: package.name),
                      const SizedBox(height: 16),
                      _DescriptionInput(initialValue: package.description),
                      const SizedBox(height: 16),
                      _PriceInput(initialValue: package.price.toString()),
                      const SizedBox(height: 16),
                      _TimeLimitInput(
                        initialValue: package.timeLimit.toString(),
                      ),
                      const SizedBox(height: 16),
                      _ImagePicker(initialValue: package.imageFilename),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SavePackageButton(
        onPressed: () {
          context.read<FoodPackageEditBloc>().add(
            const FoodPackageEditEvent.submitted(),
          );
        },
      ),
    );
  }
}

class _NameInput extends StatelessWidget {
  const _NameInput({this.initialValue});

  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    final name = context.select(
      (FoodPackageEditBloc bloc) => bloc.state.name,
    );

    return NameInput(
      onChanged: (name) => context.read<FoodPackageEditBloc>().add(
        FoodPackageEditEvent.nameChanged(name),
      ),
      initialValue: initialValue,
      errorText: name.displayError?.message,
    );
  }
}

class _DescriptionInput extends StatelessWidget {
  const _DescriptionInput({this.initialValue});

  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    final description = context.select(
      (FoodPackageEditBloc bloc) => bloc.state.description,
    );

    return DescriptionInput(
      onChanged: (description) => context.read<FoodPackageEditBloc>().add(
        FoodPackageEditEvent.descriptionChanged(description),
      ),
      initialValue: initialValue,
      errorText: description.displayError?.message,
    );
  }
}

class _PriceInput extends StatelessWidget {
  const _PriceInput({this.initialValue});

  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    final price = context.select(
      (FoodPackageEditBloc bloc) => bloc.state.price,
    );

    return PriceInput(
      onChanged: (price) => context.read<FoodPackageEditBloc>().add(
        FoodPackageEditEvent.priceChanged(price),
      ),
      initialValue: initialValue,
      errorText: price.displayError?.message,
    );
  }
}

class _TimeLimitInput extends StatelessWidget {
  const _TimeLimitInput({this.initialValue});

  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    final timeLimit = context.select(
      (FoodPackageEditBloc bloc) => bloc.state.timeLimit,
    );

    return TimeLimitInput(
      onChanged: (timeLimit) => context.read<FoodPackageEditBloc>().add(
        FoodPackageEditEvent.timeLimitChanged(timeLimit),
      ),
      initialValue: initialValue,
      errorText: timeLimit.displayError?.message,
    );
  }
}

class _ImagePicker extends StatelessWidget {
  const _ImagePicker({this.initialValue});

  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return ImagePicker(
      onChange: (image) => context.read<FoodPackageEditBloc>().add(
        FoodPackageEditEvent.imageChanged(image),
      ),
      initialFileName: initialValue,
    );
  }
}
