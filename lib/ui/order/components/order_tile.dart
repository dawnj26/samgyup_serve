import 'package:flutter/material.dart';
import 'package:samgyup_serve/shared/formatter.dart';
import 'package:samgyup_serve/ui/components/bucket_image.dart';

class OrderTile extends StatelessWidget {
  const OrderTile({
    required this.name,
    required this.price,
    required this.quantity,
    super.key,
    this.imageId,
    this.trailing,
  });

  final String? imageId;
  final String name;
  final double price;
  final int quantity;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return AspectRatio(
      aspectRatio: 3.5,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: BucketImage(fileId: imageId),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: textTheme.titleSmall,
                    ),
                    Text(
                      formatToPHP(price),
                      style: textTheme.titleSmall?.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Quantity: $quantity',
                      style: textTheme.labelMedium,
                    ),
                  ],
                ),
              ],
            ),
            trailing ?? const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
