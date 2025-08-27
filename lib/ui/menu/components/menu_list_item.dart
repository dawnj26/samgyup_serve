import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_repository/menu_repository.dart';
import 'package:samgyup_serve/shared/formatter.dart';
import 'package:samgyup_serve/ui/components/components.dart';

class MenuListItem extends StatelessWidget {
  const MenuListItem({required this.item, super.key, this.onTap});

  final MenuItem item;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final price = CurrencyFormatter.formatToPHP(item.price);

    return AspectRatio(
      aspectRatio: 3,
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: _MenuTitle(title: item.name)),
                        const SizedBox(width: 8),
                        _MenuState(isAvailable: item.isAvailable),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '$price · ${item.category.label}',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: _MenuDescription(
                        description: item.description,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _MenuImage(imageFilename: item.imageFileName),
          ],
        ),
      ),
    );
  }
}

class _MenuTitle extends StatelessWidget {
  const _MenuTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Text(
      title,
      style: textTheme.labelLarge,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _MenuDescription extends StatelessWidget {
  const _MenuDescription({required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Text(
      description,
      style: textTheme.bodySmall,
      overflow: TextOverflow.ellipsis,
      maxLines: 3,
    );
  }
}

class _MenuState extends StatelessWidget {
  const _MenuState({required this.isAvailable});

  final bool isAvailable;

  @override
  Widget build(BuildContext context) {
    if (!isAvailable) {
      return const BadgeIndicator(
        color: Colors.red,
        label: 'Unavailable',
      );
    }

    return const BadgeIndicator(
      color: Colors.green,
      label: 'Available',
    );
  }
}

class _MenuImage extends StatelessWidget {
  const _MenuImage({this.imageFilename});

  final String? imageFilename;

  Future<File> _handleLoadImage(BuildContext context) {
    final menuRepo = context.read<MenuRepository>();
    return menuRepo.getMenuItemImage(imageFilename!);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey.shade200,
          ),
          clipBehavior: Clip.hardEdge,
          child: imageFilename == null
              ? const AppLogoIcon(
                  variant: AppLogoIconVariant.blackAndWhite,
                )
              : BucketImage(
                  onLoad: () => _handleLoadImage(context),
                ),
        ),
      ),
    );
  }
}
