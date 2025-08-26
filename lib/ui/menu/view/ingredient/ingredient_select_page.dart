import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_repository/menu_repository.dart';
import 'package:samgyup_serve/bloc/ingredient/select/ingredient_select_bloc.dart';
import 'package:samgyup_serve/ui/menu/view/ingredient/ingredient_select_screen.dart';

@RoutePage()
class IngredientSelectPage extends StatelessWidget {
  const IngredientSelectPage({required this.initialValue, super.key});

  final List<Ingredient> initialValue;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => IngredientSelectBloc(
        inventoryRepository: context.read(),
        selectedIngredients: initialValue,
      )..add(const IngredientSelectEvent.started()),
      child: const IngredientSelectScreen(),
    );
  }
}
