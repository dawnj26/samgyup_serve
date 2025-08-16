import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:samgyup_serve/data/management.dart';
import 'package:samgyup_serve/ui/components/components.dart';

class ManagementScreen extends StatelessWidget {
  const ManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final item = managementItems[index];

          return ActionCard(
            title: item.title,
            leading: Icon(item.icon),
            onTap: () {
              if (item.route == null) return;

              context.router.push(item.route!);
            },
          );
        },
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: managementItems.length,
      ),
    );
  }
}
