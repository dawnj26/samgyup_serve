import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/inventory/create/inventory_create_bloc.dart';
import 'package:samgyup_serve/shared/snackbar.dart';
import 'package:samgyup_serve/ui/inventory/components/category_input.dart';
import 'package:samgyup_serve/ui/inventory/components/description_input.dart';
import 'package:samgyup_serve/ui/inventory/components/expiration_input.dart';
import 'package:samgyup_serve/ui/inventory/components/low_stock_threshold_input.dart';
import 'package:samgyup_serve/ui/inventory/components/measurement_unit_input.dart';
import 'package:samgyup_serve/ui/inventory/components/name_input.dart';
import 'package:samgyup_serve/ui/inventory/components/save_button.dart';
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
                      const NameInput(),
                      const SizedBox(height: 16),
                      const DescriptionInput(),
                      const SizedBox(height: 16),
                      const CategoryInput(),
                      const SizedBox(height: 16),
                      const StockInput(),
                      const SizedBox(height: 16),
                      const LowStockThresholdInput(),
                      const SizedBox(height: 16),
                      const MeasurementUnitInput(),
                      const SizedBox(height: 16),
                      const ExpirationInput(),
                      const SizedBox(height: 16),
                      const SaveButton(),
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
