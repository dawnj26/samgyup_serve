import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/food_package/create/food_package_create_bloc.dart';
import 'package:samgyup_serve/shared/form/inventory/description.dart';
import 'package:samgyup_serve/shared/form/name.dart';
import 'package:samgyup_serve/shared/form/price.dart';
import 'package:samgyup_serve/shared/form/time_limit.dart';
import 'package:samgyup_serve/ui/components/components.dart';
import 'package:samgyup_serve/ui/food_package/components/components.dart';

class FoodPackageCreateScreen extends StatelessWidget {
  const FoodPackageCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FormScaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            pinned: true,
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Create Package'),
            ),
          ),
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: kIsWeb ? 1200 : double.infinity,
                ),
                child: SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const _Name(),
                      const SizedBox(height: 16),
                      const _Description(),
                      const SizedBox(height: 16),
                      const _Price(),
                      const SizedBox(height: 16),
                      const _TimeLimit(),
                      const SizedBox(height: 16),
                      const _Picker(),
                    ]),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SavePackageButton(
        onPressed: () => _handleSave(context),
      ),
    );
  }

  void _handleSave(BuildContext context) {
    context.read<FoodPackageCreateBloc>().add(
      const FoodPackageCreateEvent.submitted(),
    );
  }
}

class _Name extends StatelessWidget {
  const _Name();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodPackageCreateBloc, FoodPackageCreateState>(
      buildWhen: (p, c) => p.name != c.name,
      builder: (context, state) {
        return NameInput(
          key: const Key('foodPackageCreate_nameInput_textField'),
          onChanged: (name) {
            context.read<FoodPackageCreateBloc>().add(
              FoodPackageCreateEvent.nameChanged(name),
            );
          },
          errorText: state.name.displayError?.message,
        );
      },
    );
  }
}

class _Description extends StatelessWidget {
  const _Description();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodPackageCreateBloc, FoodPackageCreateState>(
      buildWhen: (p, c) => p.description != c.description,
      builder: (context, state) {
        return DescriptionInput(
          key: const Key('foodPackageCreate_descriptionInput_textField'),
          onChanged: (description) {
            context.read<FoodPackageCreateBloc>().add(
              FoodPackageCreateEvent.descriptionChanged(description),
            );
          },
          errorText: state.description.displayError?.message,
        );
      },
    );
  }
}

class _Price extends StatelessWidget {
  const _Price();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodPackageCreateBloc, FoodPackageCreateState>(
      buildWhen: (p, c) => p.price != c.price,
      builder: (context, state) {
        return PriceInput(
          key: const Key('foodPackageCreate_priceInput_textField'),
          onChanged: (price) {
            context.read<FoodPackageCreateBloc>().add(
              FoodPackageCreateEvent.priceChanged(price),
            );
          },
          errorText: state.price.displayError?.message,
        );
      },
    );
  }
}

class _TimeLimit extends StatelessWidget {
  const _TimeLimit();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodPackageCreateBloc, FoodPackageCreateState>(
      buildWhen: (p, c) => p.timeLimit != c.timeLimit,
      builder: (context, state) {
        return TimeLimitInput(
          key: const Key('foodPackageCreate_timeLimitInput_textField'),
          onChanged: (timeLimit) {
            context.read<FoodPackageCreateBloc>().add(
              FoodPackageCreateEvent.timeLimitChanged(timeLimit),
            );
          },
          errorText: state.timeLimit.displayError?.message,
        );
      },
    );
  }
}

class _Picker extends StatelessWidget {
  const _Picker();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodPackageCreateBloc, FoodPackageCreateState>(
      buildWhen: (p, c) => p.image != c.image,
      builder: (context, state) {
        return ImagePicker(
          key: const Key('foodPackageCreate_imagePicker_picker'),
          onChange: (image) {
            context.read<FoodPackageCreateBloc>().add(
              FoodPackageCreateEvent.imageChanged(image),
            );
          },
        );
      },
    );
  }
}
