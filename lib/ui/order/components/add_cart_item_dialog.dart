import 'package:flutter/material.dart';
import 'package:samgyup_serve/shared/formatter.dart';
import 'package:samgyup_serve/shared/snackbar.dart';
import 'package:samgyup_serve/ui/components/components.dart';

class AddCartItemDialog extends StatefulWidget {
  const AddCartItemDialog({
    required this.name,
    required this.description,
    required this.price,
    required this.maxQuantity,
    super.key,
    this.imageId,
    this.content,
    this.initialValue = 1,
    this.onTap,
  });

  final String? imageId;
  final String name;
  final String description;
  final double price;
  final int maxQuantity;
  final Widget? content;
  final int initialValue;
  final void Function()? onTap;

  @override
  State<AddCartItemDialog> createState() => _AddCartItemDialogState();
}

class _AddCartItemDialogState extends State<AddCartItemDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => widget.onTap?.call(),
      child: Dialog.fullscreen(
        child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Image(
                imageId: widget.imageId,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: _ItemDetails(
                        name: widget.name,
                        price: widget.price,
                        description: widget.description,
                      ),
                    ),
                    Expanded(child: widget.content ?? const SizedBox.shrink()),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        children: [
                          _Quantity(
                            initialValue: widget.initialValue,
                            controller: _controller,
                            maxQuantity: widget.maxQuantity,
                          ),
                          const SizedBox(height: 16),
                          _Action(
                            onCancelled: () => Navigator.of(context).pop(),
                            onSaved: () {
                              final quantity = int.tryParse(_controller.text);
                              if (quantity == null ||
                                  quantity < 1 ||
                                  quantity > widget.maxQuantity) {
                                showSnackBar(context, 'Invalid quantity');
                                return;
                              }

                              Navigator.of(context).pop(quantity);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Action extends StatelessWidget {
  const _Action({
    this.onSaved,
    this.onCancelled,
  });

  final void Function()? onSaved;
  final void Function()? onCancelled;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: onCancelled,
            child: const Text(
              'Cancel',
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: FilledButton(
            onPressed: onSaved,
            child: const Text('Add to Cart'),
          ),
        ),
      ],
    );
  }
}

class _Quantity extends StatelessWidget {
  const _Quantity({
    required this.maxQuantity,
    required this.controller,
    required this.initialValue,
  });

  final int maxQuantity;
  final TextEditingController controller;
  final int initialValue;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Quantity ($maxQuantity)',
          style: textTheme.labelLarge,
        ),
        QuantityInput(
          initialValue: initialValue,
          controller: controller,
          width: 150,
          minValue: 1,
          maxValue: maxQuantity,
        ),
      ],
    );
  }
}

class _ItemDetails extends StatelessWidget {
  const _ItemDetails({
    required this.name,
    required this.price,
    required this.description,
  });

  final String name;
  final double price;
  final String description;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          CurrencyFormatter.formatToPHP(price),
          style: textTheme.titleMedium?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _Image extends StatelessWidget {
  const _Image({
    required this.imageId,
  });

  final String? imageId;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 5 / 4,
      child: BucketImage(fileId: imageId),
    );
  }
}
