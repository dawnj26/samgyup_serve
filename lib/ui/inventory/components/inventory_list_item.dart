import 'package:flutter/material.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:samgyup_serve/shared/formatter.dart';
import 'package:samgyup_serve/ui/components/components.dart';
import 'package:samgyup_serve/ui/menu/components/components.dart';

class InventoryListItem extends StatelessWidget {
  const InventoryListItem({
    required this.item,
    super.key,
    this.onTap,
    this.color,
    this.image,
  });

  final InventoryItem item;
  final void Function()? onTap;
  final Color? color;
  final Widget? image;

  @override
  Widget build(BuildContext context) {
    final price = formatToPHP(item.price);
    final isAvailable = item.isAvailable;

    return AspectRatio(
      aspectRatio: 3,
      child: InkWell(
        onTap: onTap,
        child: Container(
          color: color,
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
                          Expanded(
                            child: _InventoryTitle(
                              title: item.name,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _InventoryState(isAvailable: isAvailable),
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
                        child: _InventoryDescription(
                          description: item.description ?? '',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _InventoryImage(
                imageId: item.imageId,
                child: image,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InventoryTitle extends StatelessWidget {
  const _InventoryTitle({required this.title});

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

class _InventoryDescription extends StatelessWidget {
  const _InventoryDescription({required this.description});

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

class _InventoryState extends StatelessWidget {
  const _InventoryState({required this.isAvailable});

  final bool isAvailable;

  @override
  Widget build(BuildContext context) {
    return AvailableBadge(isAvailable: isAvailable);
  }
}

class _InventoryImage extends StatelessWidget {
  const _InventoryImage({this.imageId, this.child});

  final String? imageId;
  final Widget? child;

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
          child: imageId == null
              ? const AppLogoIcon(
                  variant: AppLogoIconVariant.blackAndWhite,
                  useFallback: true,
                )
              : child ??
                    const AppLogoIcon(
                      variant: AppLogoIconVariant.blackAndWhite,
                      useFallback: true,
                    ),
        ),
      ),
    );
  }
}
