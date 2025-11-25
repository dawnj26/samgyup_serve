import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_repository/package_repository.dart';
import 'package:samgyup_serve/bloc/food_package/food_package_bloc.dart';
import 'package:samgyup_serve/router/router.dart';
import 'package:samgyup_serve/ui/components/bottom_loader.dart';
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
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: kIsWeb ? 1200 : double.infinity,
          ),
          child: const CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: _Status(),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.all(16),
                sliver: _PackageList(),
              ),
              SliverToBoxAdapter(
                child: _Loader(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.router.push(
            FoodPackageCreateRoute(
              onCreated: (package) => _handleCreate(context, package),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _handleCreate(
    BuildContext context,
    FoodPackageItem package,
  ) async {
    await context.router.replace(
      FoodPackageDetailsRoute(
        package: package,
      ),
    );

    if (!context.mounted) return;

    context.read<FoodPackageBloc>().add(
      const FoodPackageEvent.refreshed(),
    );
  }
}

class _Status extends StatelessWidget {
  const _Status();

  @override
  Widget build(BuildContext context) {
    final total = context.select(
      (FoodPackageBloc bloc) => bloc.state.totalPackages,
    );

    return HomeStatus(count: total);
  }
}

class _Loader extends StatelessWidget {
  const _Loader();

  @override
  Widget build(BuildContext context) {
    final hasReachedMax = context.select(
      (FoodPackageBloc bloc) => bloc.state.hasReachedMax,
    );

    if (hasReachedMax) {
      return const SizedBox.shrink();
    }

    return const BottomLoader();
  }
}

class _PackageList extends StatelessWidget {
  const _PackageList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodPackageBloc, FoodPackageState>(
      builder: (context, state) {
        switch (state) {
          case FoodPackageSuccess(:final packages):
            return SliverGrid.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                crossAxisCount: kIsWeb ? 2 : 1,
              ),
              itemCount: packages.length,
              itemBuilder: (ctx, i) {
                final package = packages[i];

                return PackageTile(
                  onTap: () => _handleTap(context, package),
                  package: package,
                );
              },
            );

          case FoodPackageFailure():
            return const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text('Failed to load packages'),
              ),
            );
          default:
            return const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
        }
      },
    );
  }

  Future<void> _handleTap(BuildContext context, FoodPackageItem package) async {
    await context.router.push(
      FoodPackageDetailsRoute(
        package: package,
        onChange: () {
          context.read<FoodPackageBloc>().add(
            const FoodPackageEvent.refreshed(),
          );
        },
      ),
    );
  }
}
