import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_repository/menu_repository.dart';
import 'package:samgyup_serve/bloc/menu/create/menu_create_bloc.dart';
import 'package:samgyup_serve/router/router.dart';
import 'package:samgyup_serve/ui/components/empty_fallback.dart';
import 'package:samgyup_serve/ui/menu/components/components.dart';

@RoutePage()
class MenuIngredientScreen extends StatelessWidget {
  const MenuIngredientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 24, left: 16, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ingredients',
                style: textTheme.headlineMedium,
              ),
              const _AddButton(),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: BlocBuilder<MenuCreateBloc, MenuCreateState>(
            buildWhen: (p, c) => p.ingredients != c.ingredients,
            builder: (context, state) {
              final ingredients = state.ingredients;

              if (ingredients.isEmpty) {
                return const EmptyFallback(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  message: '''
No ingredients added yet.
Tap the + button to add ingredients.
                      ''',
                );
              }

              return ListView.builder(
                itemBuilder: (ctx, i) {
                  final ingredient = ingredients[i];

                  return IngredientTile(
                    ingredient: ingredient,
                    trailing: IconButton(
                      onPressed: () {
                        final updated = ingredients
                            .where(
                              (ing) =>
                                  ing.inventoryItemId !=
                                  ingredient.inventoryItemId,
                            )
                            .toList();

                        context.read<MenuCreateBloc>().add(
                          MenuCreateEvent.ingredientsChanged(updated),
                        );
                      },
                      icon: const Icon(Icons.close_rounded),
                    ),
                  );
                },
                itemCount: ingredients.length,
              );
            },
          ),
        ),
      ],
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
      onPressed: () async {
        final selected = await context.router.push<List<Ingredient>>(
          IngredientSelectRoute(initialValue: ingredients),
        );

        if (!context.mounted || selected == null) return;

        context.read<MenuCreateBloc>().add(
          MenuCreateEvent.ingredientsChanged(selected),
        );
      },
      icon: const Icon(Icons.add),
    );
  }
}
