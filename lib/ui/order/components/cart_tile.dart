import 'package:flutter/material.dart';
import 'package:samgyup_serve/shared/formatter.dart';
import 'package:samgyup_serve/ui/components/components.dart';

class CartTile extends StatelessWidget {
  const CartTile({
    required this.name,
    required this.price,
    required this.quantity,
    required this.maxValue,
    super.key,
    this.imageId,
    this.onQuantityChanged,
    this.onDelete,
  });

  final String? imageId;
  final String name;
  final double price;
  final int quantity;
  final int maxValue;
  final void Function(int quantity)? onQuantityChanged;
  final void Function()? onDelete;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return AspectRatio(
      aspectRatio: 3,
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
                    QuantityInput(
                      minValue: 1,
                      initialValue: quantity,
                      maxValue: maxValue,
                      onChanged: onQuantityChanged,
                      width: 100,
                      height: 32,
                    ),
                  ],
                ),
              ],
            ),
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline),
            ),
          ],
        ),
      ),
    );
  }
}
