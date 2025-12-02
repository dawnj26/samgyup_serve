import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_repository/menu_repository.dart';
import 'package:samgyup_serve/bloc/menu/edit/menu_edit_bloc.dart';
import 'package:samgyup_serve/shared/form/menu/menu_category_input.dart';
import 'package:samgyup_serve/shared/form/menu/menu_description.dart';
import 'package:samgyup_serve/shared/form/name.dart';
import 'package:samgyup_serve/shared/form/price.dart';
import 'package:samgyup_serve/ui/components/components.dart';
import 'package:samgyup_serve/ui/menu/components/components.dart';

class MenuEditScreen extends StatelessWidget {
  const MenuEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final item = context.select((MenuEditBloc bloc) => bloc.menuItem);

    return FormScaffold(
      appBar: AppBar(
        title: const Text('Edit Menu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Menu Details',
              style: textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            _Name(
              initialValue: item.name,
            ),
            const SizedBox(height: 16),
            _Description(
              initialValue: item.description,
            ),
            const SizedBox(height: 16),
            _Price(
              initialValue: item.price.toString(),
            ),
            const SizedBox(height: 16),
            _Category(
              initialValue: item.category,
            ),
            const SizedBox(height: 16),
            const _Image(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: FilledButton(
          key: const Key('menuEditForm_submit_elevatedButton'),
          onPressed: () {
            context.read<MenuEditBloc>().add(const MenuEditEvent.submitted());
          },
          child: const Text('Save'),
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
      onChange: (image) {
        // context.read<MenuEditBloc>().add(
        //   MenuEditEvent.imageChanged(image),
        // );
      },
    );
  }
}

class _Name extends StatelessWidget {
  const _Name({
    required this.initialValue,
  });

  final String initialValue;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuEditBloc, MenuEditState>(
      buildWhen: (previous, current) => previous.name != current.name,
      builder: (context, state) {
        final name = state.name;
        final nameError = name.displayError;

        String? errorText;
        if (nameError == NameValidationError.empty) {
          errorText = 'Name cannot be empty';
        } else if (nameError == NameValidationError.tooShort) {
          errorText = 'Name is too short';
        }

        return NameInput(
          initialValue: initialValue,
          key: const Key('menuEditForm_nameInput_textField'),
          errorText: errorText,
          onChanged: (name) {
            context.read<MenuEditBloc>().add(
              MenuEditEvent.nameChanged(name),
            );
          },
        );
      },
    );
  }
}

class _Description extends StatelessWidget {
  const _Description({
    required this.initialValue,
  });

  final String initialValue;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuEditBloc, MenuEditState>(
      buildWhen: (previous, current) =>
          previous.description != current.description,
      builder: (context, state) {
        final description = state.description;
        final descriptionError = description.displayError;

        String? errorText;
        if (descriptionError == MenuDescriptionValidationError.empty) {
          errorText = 'Description cannot be empty';
        } else if (descriptionError == MenuDescriptionValidationError.tooLong) {
          errorText = 'Description is too long';
        }

        return DescriptionInput(
          initialValue: initialValue,
          key: const Key('menuEditForm_descriptionInput_textField'),
          errorText: errorText,
          onChanged: (description) {
            context.read<MenuEditBloc>().add(
              MenuEditEvent.descriptionChanged(description),
            );
          },
        );
      },
    );
  }
}

class _Price extends StatelessWidget {
  const _Price({
    required this.initialValue,
  });

  final String initialValue;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuEditBloc, MenuEditState>(
      buildWhen: (previous, current) => previous.price != current.price,
      builder: (context, state) {
        final price = state.price;
        final priceError = price.displayError;

        String? errorText;
        if (priceError == PriceValidationError.empty) {
          errorText = 'Price cannot be empty';
        } else if (priceError == PriceValidationError.invalidFormat) {
          errorText = 'Invalid price format';
        } else if (priceError == PriceValidationError.negative) {
          errorText = 'Price cannot be negative';
        }

        return PriceInput(
          initialValue: initialValue,
          key: const Key('menuEditForm_priceInput_textField'),
          errorText: errorText,
          onChanged: (price) {
            context.read<MenuEditBloc>().add(
              MenuEditEvent.priceChanged(price),
            );
          },
        );
      },
    );
  }
}

class _Category extends StatelessWidget {
  const _Category({
    required this.initialValue,
  });

  final MenuCategory initialValue;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuEditBloc, MenuEditState>(
      buildWhen: (previous, current) => previous.category != current.category,
      builder: (context, state) {
        final category = state.category;
        final categoryError = category.displayError;

        String? errorText;
        if (categoryError == MenuCategoryInputValidationError.empty) {
          errorText = 'Category cannot be empty';
        }

        return CategoryInput(
          value: initialValue,
          key: const Key('menuEditForm_categoryInput_dropdown'),
          errorText: errorText,
          onSelected: (category) {
            context.read<MenuEditBloc>().add(
              MenuEditEvent.categoryChanged(category),
            );
          },
        );
      },
    );
  }
}
