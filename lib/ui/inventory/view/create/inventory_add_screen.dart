import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/inventory/create/inventory_create_bloc.dart';
import 'package:samgyup_serve/shared/form/inventory/category.dart';
import 'package:samgyup_serve/shared/form/inventory/description.dart';
import 'package:samgyup_serve/shared/form/inventory/low_stock_threshold.dart';
import 'package:samgyup_serve/shared/form/inventory/measurement_unit.dart' as f;
import 'package:samgyup_serve/shared/form/name.dart';
import 'package:samgyup_serve/shared/form/price.dart';
import 'package:samgyup_serve/shared/snackbar.dart';
import 'package:samgyup_serve/ui/components/components.dart';
import 'package:samgyup_serve/ui/inventory/components/components.dart';

class InventoryAddScreen extends StatefulWidget {
  const InventoryAddScreen({super.key});

  @override
  State<InventoryAddScreen> createState() => _InventoryAddScreenState();
}

class _InventoryAddScreenState extends State<InventoryAddScreen> {
  final _subcategoryController = TextEditingController();

  @override
  void dispose() {
    _subcategoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<InventoryCreateBloc, InventoryCreateState>(
      listener: (context, state) {
        switch (state) {
          case InventoryCreateSuccess():
            showSnackBar(context, 'Item added successfully');
            context.router.pop(true);
          case InventoryCreateFailure(:final message):
            showSnackBar(context, message);
        }
      },
      child: FormScaffold(
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              const SliverAppBar(
                pinned: true,
                expandedHeight: 200,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text('Add Item'),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      const _NameInputField(),
                      const SizedBox(height: 16),
                      const _DescriptionInputField(),
                      const SizedBox(height: 16),
                      _CategoryInputField(
                        onChanged: _subcategoryController.clear,
                      ),
                      const SizedBox(height: 16),
                      _Subcategory(controller: _subcategoryController),
                      const SizedBox(height: 16),
                      const _LowStockThresholdInputField(),
                      const SizedBox(height: 16),
                      const _MeasurementUnitInputField(),
                      const SizedBox(height: 16),
                      const _Price(),
                      const SizedBox(height: 16),
                      const _Image(),
                      const SizedBox(height: 16),
                      const AddButton(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Image extends StatelessWidget {
  const _Image();

  @override
  Widget build(BuildContext context) {
    return ImagePicker(
      onChange: (file) {
        context.read<InventoryCreateBloc>().add(
          InventoryCreateEvent.imageChanged(imageFile: file),
        );
      },
    );
  }
}

class _Price extends StatelessWidget {
  const _Price();

  @override
  Widget build(BuildContext context) {
    final price = context.select(
      (InventoryCreateBloc bloc) => bloc.state.price,
    );

    final errText = price.displayError?.message;

    return PriceInput(
      key: const Key('inventoryCreate_priceInput_textField'),
      onChanged: (value) {
        context.read<InventoryCreateBloc>().add(
          InventoryCreateEvent.priceChanged(price: value),
        );
      },
      errorText: errText,
    );
  }
}

class _NameInputField extends StatelessWidget {
  const _NameInputField();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryCreateBloc, InventoryCreateState>(
      buildWhen: (previous, current) {
        final prev = previous.name;
        final curr = current.name;

        return prev.value != curr.value || prev.isPure != curr.isPure;
      },
      builder: (context, state) {
        final name = state.name;

        String? errorText;
        if (name.displayError == NameValidationError.empty) {
          errorText = 'Item name is required';
        } else if (name.displayError == NameValidationError.tooShort) {
          errorText = 'Item name must be at least 3 characters';
        }

        return InventoryNameInput(
          key: const Key('inventoryCreate_nameInput_textField'),
          onNameChanged: (name) {
            context.read<InventoryCreateBloc>().add(
              InventoryCreateEvent.nameChanged(name: name),
            );
          },
          errorText: errorText,
        );
      },
    );
  }
}

class _DescriptionInputField extends StatelessWidget {
  const _DescriptionInputField();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryCreateBloc, InventoryCreateState>(
      buildWhen: (p, c) =>
          p.description.value != c.description.value ||
          p.description.isPure != c.description.isPure,
      builder: (context, state) {
        final description = state.description;
        String? errorText;
        if (description.displayError == DescriptionValidationError.tooLong) {
          errorText = 'Description must be at most 500 characters';
        }
        return InventoryDescriptionInput(
          key: const Key('inventoryCreate_descriptionInput_textField'),
          errorText: errorText,
          onChanged: (value) {
            context.read<InventoryCreateBloc>().add(
              InventoryCreateEvent.descriptionChanged(description: value),
            );
          },
        );
      },
    );
  }
}

class _CategoryInputField extends StatelessWidget {
  const _CategoryInputField({this.onChanged});

  final void Function()? onChanged;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryCreateBloc, InventoryCreateState>(
      buildWhen: (p, c) =>
          p.category.value != c.category.value ||
          p.category.isPure != c.category.isPure,
      builder: (context, state) {
        final category = state.category;
        String? errorText;
        if (category.displayError == CategoryValidationError.empty) {
          errorText = 'Category is required';
        }
        return CategoryInput(
          key: const Key('inventoryCreate_categoryInput_dropdown'),
          errorText: errorText,
          onSelected: (value) {
            if (value == null) return;
            context.read<InventoryCreateBloc>().add(
              InventoryCreateEvent.categoryChanged(category: value),
            );

            onChanged?.call();
          },
        );
      },
    );
  }
}

class _LowStockThresholdInputField extends StatelessWidget {
  const _LowStockThresholdInputField();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryCreateBloc, InventoryCreateState>(
      buildWhen: (p, c) =>
          p.lowStockThreshold.value != c.lowStockThreshold.value ||
          p.lowStockThreshold.isPure != c.lowStockThreshold.isPure,
      builder: (context, state) {
        final lowStockThreshold = state.lowStockThreshold;
        String? errorText;
        if (lowStockThreshold.displayError ==
            LowStockThresholdValidationError.empty) {
          errorText = 'Low stock threshold is required';
        } else if (lowStockThreshold.displayError ==
            LowStockThresholdValidationError.negative) {
          errorText = 'Low stock threshold cannot be negative';
        } else if (lowStockThreshold.displayError ==
            LowStockThresholdValidationError.invalid) {
          errorText = 'Low stock threshold must be a valid number';
        }

        return LowStockThresholdInput(
          key: const Key('inventoryCreate_lowStockThresholdInput_textField'),
          errorText: errorText,
          onChanged: (value) {
            context.read<InventoryCreateBloc>().add(
              InventoryCreateEvent.lowStockThresholdChanged(
                lowStockThreshold: value,
              ),
            );
          },
        );
      },
    );
  }
}

class _MeasurementUnitInputField extends StatelessWidget {
  const _MeasurementUnitInputField();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryCreateBloc, InventoryCreateState>(
      buildWhen: (p, c) =>
          p.measurementUnit.value != c.measurementUnit.value ||
          p.measurementUnit.isPure != c.measurementUnit.isPure,
      builder: (context, state) {
        final unit = state.measurementUnit;
        String? errorText;
        if (unit.displayError == f.MeasurementUnitValidationError.empty) {
          errorText = 'Measurement unit is required';
        }
        return MeasurementUnitInput(
          key: const Key('inventoryCreate_measurementUnitInput_dropdown'),
          value: unit.value,
          errorText: errorText,
          onSelected: (value) {
            if (value == null) return;
            context.read<InventoryCreateBloc>().add(
              InventoryCreateEvent.unitChanged(measurementUnit: value),
            );
          },
        );
      },
    );
  }
}

class _Subcategory extends StatelessWidget {
  const _Subcategory({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final category = context.select(
      (InventoryCreateBloc bloc) => bloc.state.category,
    );
    final subcategories = context.select(
      (InventoryCreateBloc bloc) => bloc.state.subcategories,
    );

    return SubcategoryInput(
      enabled: category.isValid && subcategories.isNotEmpty,
      controller: controller,
      subcategories: subcategories,
      onSelected: (value) => context.read<InventoryCreateBloc>().add(
        InventoryCreateEvent.subcategoryChanged(subcategory: value),
      ),
    );
  }
}
