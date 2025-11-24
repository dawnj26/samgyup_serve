import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:samgyup_serve/bloc/inventory/edit/inventory_edit_bloc.dart';
import 'package:samgyup_serve/shared/form/inventory/category.dart';
import 'package:samgyup_serve/shared/form/inventory/description.dart';
import 'package:samgyup_serve/shared/form/inventory/measurement_unit.dart'
    hide MeasurementUnitInput;
import 'package:samgyup_serve/shared/form/name.dart';
import 'package:samgyup_serve/shared/form/price.dart';
import 'package:samgyup_serve/shared/snackbar.dart';
import 'package:samgyup_serve/ui/components/form_scaffold.dart';
import 'package:samgyup_serve/ui/components/image_picker.dart';
import 'package:samgyup_serve/ui/components/price_input.dart';
import 'package:samgyup_serve/ui/inventory/components/components.dart';

class InventoryEditScreen extends StatefulWidget {
  const InventoryEditScreen({required this.item, super.key});

  final InventoryItem item;

  @override
  State<InventoryEditScreen> createState() => _InventoryEditScreenState();
}

class _InventoryEditScreenState extends State<InventoryEditScreen> {
  final _subcategoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<InventoryEditBloc, InventoryEditState>(
      listener: (context, state) {
        switch (state) {
          case InventoryEditSuccess(:final item):
            showSnackBar(context, 'Item saved successfully');
            context.router.pop(item);
          case InventoryEditFailure(:final message):
            showSnackBar(context, message);
          case InventoryEditNoChanges():
            context.router.pop();
          default:
            break;
        }
      },
      child: FormScaffold(
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: kIsWeb ? 1200 : double.infinity,
              ),
              child: CustomScrollView(
                slivers: [
                  const SliverAppBar(
                    pinned: true,
                    expandedHeight: 200,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text('Edit Item'),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: BlocBuilder<InventoryEditBloc, InventoryEditState>(
                      buildWhen: (previous, current) {
                        return previous is InventoryEditInitializing ||
                            current is InventoryEditInitialized;
                      },
                      builder: (context, state) {
                        if (state is! InventoryEditInitialized) {
                          return const SliverFillRemaining(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        return _Form(
                          item: widget.item,
                          subcategoryController: _subcategoryController,
                          subcategory: state.subcategory,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatelessWidget {
  const _Form({
    required this.item,
    required this.subcategoryController,
    this.subcategory,
  });

  final InventoryItem item;
  final TextEditingController subcategoryController;
  final Subcategory? subcategory;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          _NameInputField(
            item.name,
          ),
          const SizedBox(height: 16),
          _DescriptionInputField(
            item.description,
          ),
          const SizedBox(height: 16),
          _CategoryInputField(
            item.category,
          ),
          const SizedBox(height: 16),
          _Subcategory(
            controller: subcategoryController,
            initialValue: subcategory,
          ),
          const SizedBox(height: 16),
          _LowStock(
            lowStockThreshold: item.lowStockThreshold,
          ),
          const SizedBox(height: 16),
          _MeasurementUnitInputField(
            item.unit,
          ),
          const SizedBox(height: 16),
          _Price(
            initialValue: item.price,
          ),
          const SizedBox(height: 16),
          const _Picker(),
          const SizedBox(height: 16),
          const SaveButton(),
        ],
      ),
    );
  }
}

class _Picker extends StatelessWidget {
  const _Picker();

  @override
  Widget build(BuildContext context) {
    return ImagePicker(
      onChange: (image) {
        context.read<InventoryEditBloc>().add(
          InventoryEditEvent.imageChanged(imageFile: image),
        );
      },
    );
  }
}

class _Price extends StatelessWidget {
  const _Price({
    required this.initialValue,
  });

  final double initialValue;

  @override
  Widget build(BuildContext context) {
    final price = context.select(
      (InventoryEditBloc bloc) => bloc.state.price,
    );

    final errorText = price.displayError?.message;

    return PriceInput(
      errorText: errorText,
      initialValue: initialValue.toString(),
      onChanged: (value) {
        context.read<InventoryEditBloc>().add(
          InventoryEditEvent.priceChanged(price: value),
        );
      },
    );
  }
}

class _LowStock extends StatelessWidget {
  const _LowStock({
    required this.lowStockThreshold,
  });

  final double lowStockThreshold;

  @override
  Widget build(BuildContext context) {
    final lowStock = context.select(
      (InventoryEditBloc bloc) => bloc.state.lowStockThreshold,
    );

    final errorText = lowStock.displayError?.message;

    return LowStockThresholdInput(
      errorText: errorText,
      initialValue: lowStockThreshold.toString(),
      onChanged: (value) {
        context.read<InventoryEditBloc>().add(
          InventoryEditEvent.lowStockThresholdChanged(
            lowStockThreshold: value,
          ),
        );
      },
    );
  }
}

class _NameInputField extends StatelessWidget {
  const _NameInputField(this.initialValue);

  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryEditBloc, InventoryEditState>(
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
          initialValue: initialValue,
          key: const Key('InventoryEdit_nameInput_textField'),
          onNameChanged: (name) {
            context.read<InventoryEditBloc>().add(
              InventoryEditEvent.nameChanged(name: name),
            );
          },
          errorText: errorText,
        );
      },
    );
  }
}

class _DescriptionInputField extends StatelessWidget {
  const _DescriptionInputField(this.initialValue);

  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryEditBloc, InventoryEditState>(
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
          key: const Key('InventoryEdit_descriptionInput_textField'),
          initialValue: initialValue,
          errorText: errorText,
          onChanged: (value) {
            context.read<InventoryEditBloc>().add(
              InventoryEditEvent.descriptionChanged(description: value),
            );
          },
        );
      },
    );
  }
}

class _CategoryInputField extends StatelessWidget {
  const _CategoryInputField(this.value);

  final InventoryCategory? value;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryEditBloc, InventoryEditState>(
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
          key: const Key('InventoryEdit_categoryInput_dropdown'),
          value: value,
          errorText: errorText,
          onSelected: (value) {
            if (value == null) return;
            context.read<InventoryEditBloc>().add(
              InventoryEditEvent.categoryChanged(category: value),
            );
          },
        );
      },
    );
  }
}

class _MeasurementUnitInputField extends StatelessWidget {
  const _MeasurementUnitInputField(this.value);

  final MeasurementUnit? value;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryEditBloc, InventoryEditState>(
      buildWhen: (p, c) =>
          p.measurementUnit.value != c.measurementUnit.value ||
          p.measurementUnit.isPure != c.measurementUnit.isPure,
      builder: (context, state) {
        final unit = state.measurementUnit;
        String? errorText;
        if (unit.displayError == MeasurementUnitValidationError.empty) {
          errorText = 'Measurement unit is required';
        }
        return MeasurementUnitInput(
          key: const Key('InventoryEdit_measurementUnitInput_dropdown'),
          value: value,
          errorText: errorText,
          onSelected: (value) {
            if (value == null) return;
            context.read<InventoryEditBloc>().add(
              InventoryEditEvent.unitChanged(measurementUnit: value),
            );
          },
        );
      },
    );
  }
}

class _Subcategory extends StatefulWidget {
  const _Subcategory({
    required this.initialValue,
    required this.controller,
  });

  final TextEditingController controller;
  final Subcategory? initialValue;

  @override
  State<_Subcategory> createState() => _SubcategoryState();
}

class _SubcategoryState extends State<_Subcategory> {
  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      widget.controller.text = widget.initialValue!.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    final category = context.select(
      (InventoryEditBloc bloc) => bloc.state.category,
    );
    final subcategories = context.select(
      (InventoryEditBloc bloc) => bloc.state.subcategories,
    );

    return SubcategoryInput(
      enabled: category.isValid && subcategories.isNotEmpty,
      value: widget.initialValue,
      controller: widget.controller,
      subcategories: subcategories,
      onSelected: (value) => context.read<InventoryEditBloc>().add(
        InventoryEditEvent.subcategoryChanged(subcategory: value),
      ),
    );
  }
}
