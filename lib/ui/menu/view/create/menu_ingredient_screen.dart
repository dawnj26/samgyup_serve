import 'package:auto_route/auto_route.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/menu/create/menu_create_bloc.dart';
import 'package:samgyup_serve/router/router.dart';

@RoutePage()
class MenuIngredientScreen extends StatelessWidget {
  const MenuIngredientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(top: 24, left: 16, right: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ingredients',
                style: textTheme.headlineMedium,
              ),
              const _AddButton(),
            ],
          ),
          const Expanded(
            child: _MenuIngredientFallback(),
          ),
        ],
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton();

  @override
  Widget build(BuildContext context) {
    final ingredients = context.select(
      (MenuCreateBloc bloc) => bloc.state.ingredients,
    );

    return IconButton(
      onPressed: () {
        context.router.push(IngredientSelectRoute(initialValue: ingredients));
      },
      icon: const Icon(Icons.add),
    );
  }
}

class _MenuIngredientFallback extends StatelessWidget {
  const _MenuIngredientFallback();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: DottedBorder(
        options: RoundedRectDottedBorderOptions(
          radius: const Radius.circular(12),
          stackFit: StackFit.expand,
          dashPattern: [10, 5],
          strokeWidth: 2,
          color: colorScheme.outlineVariant,
        ),
        child: Center(
          child: Text(
            'No ingredients added yet.\nTap the + button to add ingredients.',
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
