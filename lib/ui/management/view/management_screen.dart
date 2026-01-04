import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:samgyup_serve/data/management.dart';
import 'package:samgyup_serve/ui/components/components.dart';

class ManagementScreen extends StatelessWidget {
  const ManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = managementItems.where((item) => item.enabled).toList();

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final item = items[index];

              return ActionCard(
                title: item.title,
                leading: Icon(item.icon),
                onTap: () {
                  if (item.route == null) return;

                  unawaited(context.router.push(item.route!));
                },
              );
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: kIsWeb ? 4 : 2,
              childAspectRatio: 1.5,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: items.length,
          ),
        ),
      ),
    );
  }
}
