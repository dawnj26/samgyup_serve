import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:package_repository/package_repository.dart';
import 'package:samgyup_serve/ui/food_package/components/components.dart';

class FoodPackageScreen extends StatelessWidget {
  const FoodPackageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AutoLeadingButton(),
        title: const Text('Packages'),
      ),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: HomeStatus(count: 10),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                crossAxisCount: 1,
              ),
              itemCount: 10,
              itemBuilder: (ctx, i) {
                return PackageTile(
                  onTap: _handleTap,
                  package: FoodPackage(
                    name: 'Package 1',
                    description: 'a description',
                    price: 200,
                    timeLimit: 20,
                    createdAt: DateTime.now(),
                    menuIds: [],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _handleTap() {
    // TODO(package): implement on tap event
  }
}
