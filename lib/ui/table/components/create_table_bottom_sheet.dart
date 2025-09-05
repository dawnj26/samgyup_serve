import 'package:flutter/material.dart';
import 'package:samgyup_serve/ui/components/components.dart';

class CreateTableBottomSheet extends StatelessWidget {
  const CreateTableBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: BottomSheetLayout(
        padding: const EdgeInsets.all(16),
        height: screenSize.height * 0.7,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Create New Table',
              style: textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            const OutlinedTextField(
              labelText: 'Table Number',
            ),
            const SizedBox(height: 16),
            const OutlinedTextField(
              labelText: 'Capacity',
            ),
            const SizedBox(height: 16),
            const OutlinedTextField(
              labelText: 'Status',
            ),
            const Spacer(),
            FilledButton(onPressed: () {}, child: const Text('Save')),
          ],
        ),
      ),
    );
  }
}
