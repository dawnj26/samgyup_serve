import 'package:billing_repository/billing_repository.dart';
import 'package:flutter/material.dart';

class PaymentMethodDropdown extends StatelessWidget {
  const PaymentMethodDropdown({
    super.key,
    this.initialValue,
    this.errorText,
    this.onSelected,
  });

  final PaymentMethod? initialValue;
  final String? errorText;
  final ValueChanged<PaymentMethod?>? onSelected;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    const padding = 16.0;
    final entries = PaymentMethod.values
        .map(
          (category) => DropdownMenuEntry<PaymentMethod>(
            value: category,
            label: category.label,
          ),
        )
        .toList();

    return DropdownMenu<PaymentMethod>(
      leadingIcon: const Icon(Icons.category_outlined),
      label: const Text('Method'),
      width: screenWidth - padding * 2,
      initialSelection: initialValue,
      onSelected: onSelected,
      dropdownMenuEntries: entries,
      errorText: errorText,
    );
  }
}
