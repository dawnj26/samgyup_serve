import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/menu/create/menu_create_bloc.dart';
import 'package:samgyup_serve/shared/form/menu/menu_category_input.dart';
import 'package:samgyup_serve/shared/form/menu/menu_description.dart';
import 'package:samgyup_serve/shared/form/name.dart';
import 'package:samgyup_serve/shared/form/price.dart';
import 'package:samgyup_serve/ui/components/image_picker.dart';
import 'package:samgyup_serve/ui/menu/components/components.dart';

@RoutePage()
class MenuFormScreen extends StatelessWidget {
  const MenuFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Menu Details',
            style: textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          const _Name(),
          const SizedBox(height: 16),
          const _Description(),
          const SizedBox(height: 16),
          const _Price(),
          const SizedBox(height: 16),
          const _Category(),
          const SizedBox(height: 16),
          const _Image(),
        ],
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
        context.read<MenuCreateBloc>().add(
          MenuCreateEvent.imageChanged(image),
        );
      },
    );
  }
}

class _Name extends StatelessWidget {
  const _Name();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuCreateBloc, MenuCreateState>(
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
          key: const Key('menuForm_nameInput_textField'),
          errorText: errorText,
          onChanged: (name) {
            context.read<MenuCreateBloc>().add(
              MenuCreateEvent.nameChanged(name),
            );
          },
        );
      },
    );
  }
}

class _Description extends StatelessWidget {
  const _Description();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuCreateBloc, MenuCreateState>(
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
          key: const Key('menuForm_descriptionInput_textField'),
          errorText: errorText,
          onChanged: (description) {
            context.read<MenuCreateBloc>().add(
              MenuCreateEvent.descriptionChanged(description),
            );
          },
        );
      },
    );
  }
}

class _Price extends StatelessWidget {
  const _Price();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuCreateBloc, MenuCreateState>(
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
          key: const Key('menuForm_priceInput_textField'),
          errorText: errorText,
          onChanged: (price) {
            context.read<MenuCreateBloc>().add(
              MenuCreateEvent.priceChanged(price),
            );
          },
        );
      },
    );
  }
}

class _Category extends StatelessWidget {
  const _Category();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuCreateBloc, MenuCreateState>(
      buildWhen: (previous, current) => previous.category != current.category,
      builder: (context, state) {
        final category = state.category;
        final categoryError = category.displayError;

        String? errorText;
        if (categoryError == MenuCategoryInputValidationError.empty) {
          errorText = 'Category cannot be empty';
        }

        return CategoryInput(
          key: const Key('menuForm_categoryInput_dropdown'),
          errorText: errorText,
          onSelected: (category) {
            context.read<MenuCreateBloc>().add(
              MenuCreateEvent.categoryChanged(category),
            );
          },
        );
      },
    );
  }
}
