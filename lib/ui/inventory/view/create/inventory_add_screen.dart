import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/inventory/create/inventory_create_bloc.dart';
import 'package:samgyup_serve/shared/form/inventory/category.dart';
import 'package:samgyup_serve/shared/form/inventory/description.dart';
import 'package:samgyup_serve/shared/form/inventory/low_stock_threshold.dart';
import 'package:samgyup_serve/shared/form/inventory/measurement_unit.dart';
import 'package:samgyup_serve/shared/form/inventory/name.dart';
import 'package:samgyup_serve/shared/form/inventory/stock.dart';
import 'package:samgyup_serve/shared/snackbar.dart';
import 'package:samgyup_serve/ui/inventory/components/add_button.dart';
import 'package:samgyup_serve/ui/inventory/components/category_input.dart';
import 'package:samgyup_serve/ui/inventory/components/description_input.dart';
import 'package:samgyup_serve/ui/inventory/components/expiration_input.dart';
import 'package:samgyup_serve/ui/inventory/components/low_stock_threshold_input.dart';
import 'package:samgyup_serve/ui/inventory/components/measurement_unit_input.dart';
import 'package:samgyup_serve/ui/inventory/components/name_input.dart';
import 'package:samgyup_serve/ui/inventory/components/stock_input.dart';

class InventoryAddScreen extends StatelessWidget {
  const InventoryAddScreen({super.key});

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
      child: Scaffold(
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
                      const _CategoryInputField(),
                      const SizedBox(height: 16),
                      const _StockInputField(),
                      const SizedBox(height: 16),
                      const _LowStockThresholdInputField(),
                      const SizedBox(height: 16),
                      const _MeasurementUnitInputField(),
                      const SizedBox(height: 16),
                      const _ExpirationInputField(),
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

        return NameInput(
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
        return DescriptionInput(
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
  const _CategoryInputField();

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
          },
        );
      },
    );
  }
}

class _StockInputField extends StatelessWidget {
  const _StockInputField();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryCreateBloc, InventoryCreateState>(
      buildWhen: (p, c) =>
          p.stock.value != c.stock.value || p.stock.isPure != c.stock.isPure,
      builder: (context, state) {
        final stock = state.stock;
        String? errorText;
        if (stock.displayError == StockValidationError.empty) {
          errorText = 'Stock is required';
        } else if (stock.displayError == StockValidationError.negative) {
          errorText = 'Stock cannot be negative';
        } else if (stock.displayError == StockValidationError.invalid) {
          errorText = 'Stock must be a valid number';
        }
        return StockInput(
          key: const Key('inventoryCreate_stockInput_textField'),
          errorText: errorText,
          onChanged: (value) {
            context.read<InventoryCreateBloc>().add(
              InventoryCreateEvent.stockChanged(stock: value),
            );
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
          p.lowStockThreshold.isPure != c.lowStockThreshold.isPure ||
          p.stock.value != c.stock.value ||
          p.stock.isPure != c.stock.isPure,
      builder: (context, state) {
        final lowStockThreshold = state.lowStockThreshold;
        final enabled = state.stock.isValid;
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
          enabled: enabled,
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
        if (unit.displayError == MeasurementUnitValidationError.empty) {
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

class _ExpirationInputField extends StatelessWidget {
  const _ExpirationInputField();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryCreateBloc, InventoryCreateState>(
      buildWhen: (p, c) => p.expiration != c.expiration,
      builder: (context, state) {
        return ExpirationInput(
          key: const Key('inventoryCreate_expirationInput_datePicker'),
          onChanged: (date) {
            context.read<InventoryCreateBloc>().add(
              InventoryCreateEvent.expirationChanged(expiration: date),
            );
          },
        );
      },
    );
  }
}
