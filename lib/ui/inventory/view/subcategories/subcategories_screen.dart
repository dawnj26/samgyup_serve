import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/subcategory/action/subcategory_action_bloc.dart';
import 'package:samgyup_serve/bloc/subcategory/subcategory_bloc.dart';
import 'package:samgyup_serve/shared/dialog.dart';
import 'package:samgyup_serve/shared/enums/loading_status.dart';
import 'package:samgyup_serve/ui/inventory/components/subcategory_card.dart';

class SubcategoriesScreen extends StatelessWidget {
  const SubcategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Builder(
          builder: (context) {
            final category = context.select(
              (SubcategoryBloc bloc) => bloc.state.category,
            );
            return Text('$category categories');
          },
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: kIsWeb ? 1200 : double.infinity,
          ),
          child: BlocBuilder<SubcategoryBloc, SubcategoryState>(
            builder: (context, state) {
              if (state.status == LoadingStatus.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state.status == LoadingStatus.failure) {
                return Center(
                  child: Text(state.errorMessage ?? 'Something went wrong'),
                );
              }

              if (state.subcategories.isEmpty) {
                return const Center(
                  child: Text('No subcategories found. Add a new one!'),
                );
              }

              return ListView.builder(
                itemCount: state.subcategories.length,
                itemBuilder: (context, index) {
                  final subcategory = state.subcategories[index];
                  return SubcategoryCard(
                    subcategory: subcategory,
                    onDelete: () async {
                      final confirm = await showDeleteDialog(
                        context: context,
                        message:
                            'Are you sure you want to delete the '
                            'subcategory "${subcategory.name}"? This action '
                            'cannot be undone.',
                      );

                      if (!context.mounted || !confirm) return;

                      context.read<SubcategoryActionBloc>().add(
                        SubcategoryActionEvent.removed(id: subcategory.id),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final category = await showTextInputDialog(
            context: context,
            title: 'Add new category',
            validator: (v) {
              if (v.isEmpty) {
                return 'Category name cannot be empty';
              }

              if (v.length < 3) {
                return 'Category name must be at least 3 characters long';
              }

              return null;
            },
          );

          if (!context.mounted || category == null) return;

          context.read<SubcategoryActionBloc>().add(
            SubcategoryActionEvent.created(
              name: category,
              category: context.read<SubcategoryBloc>().state.category,
            ),
          );
        },
        label: const Text('Add Category'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
