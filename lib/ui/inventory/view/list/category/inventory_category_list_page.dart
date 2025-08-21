import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:samgyup_serve/bloc/inventory/category/inventory_category_bloc.dart';
import 'package:samgyup_serve/bloc/inventory/delete/inventory_delete_bloc.dart';
import 'package:samgyup_serve/ui/inventory/view/list/category/inventory_category_list_screen.dart';

@RoutePage()
class InventoryCategoryListPage extends StatelessWidget {
  const InventoryCategoryListPage({required this.category, super.key});

  final InventoryCategory category;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              InventoryCategoryBloc(
                inventoryRepository: context.read<InventoryRepository>(),
                category: category,
              )..add(
                const InventoryCategoryEvent.started(),
              ),
        ),
        BlocProvider(
          create: (context) => InventoryDeleteBloc(
            inventoryRepository: context.read<InventoryRepository>(),
          ),
        ),
      ],
      child: const InventoryCategoryListScreen(),
    );
  }
}
