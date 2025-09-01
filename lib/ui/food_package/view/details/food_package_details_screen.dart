import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/food_package/details/food_package_details_bloc.dart';
import 'package:samgyup_serve/shared/formatter.dart';
import 'package:samgyup_serve/ui/components/components.dart';
import 'package:samgyup_serve/ui/food_package/components/components.dart';

class FoodPackageDetailsScreen extends StatefulWidget {
  const FoodPackageDetailsScreen({super.key});

  @override
  State<FoodPackageDetailsScreen> createState() =>
      _FoodPackageDetailsScreenState();
}

class _FoodPackageDetailsScreenState extends State<FoodPackageDetailsScreen> {
  final _scrollController = ScrollController();
  final _expandedHeight = 300.0;
  bool _isExpanded = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    super.dispose();
  }

  bool get _isAppBarExpanded {
    return _scrollController.hasClients &&
        _scrollController.offset < (_expandedHeight - kToolbarHeight);
  }

  @override
  Widget build(BuildContext context) {
    final package = context.select(
      (FoodPackageDetailsBloc bloc) => bloc.state.package,
    );
    final hasImage =
        package.imageFilename != null && package.imageFilename!.isNotEmpty;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final buttonStyle = _isExpanded
        ? IconButton.styleFrom(
            backgroundColor: colorScheme.surface,
          )
        : null;

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: _expandedHeight,
            leading: IconButton(
              onPressed: () {
                context.router.pop();
              },
              icon: const Icon(Icons.arrow_back),
              style: buttonStyle,
            ),
            actions: [
              PackageMoreOptionButton(
                style: buttonStyle,
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: hasImage
                  ? PackageImage(filename: package.imageFilename!)
                  : const NoImageFallback(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    package.name,
                    style: textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    CurrencyFormatter.formatToPHP(package.price),
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  InfoCard(
                    title: 'Description',
                    child: Text(
                      package.description,
                      style: textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Text(
                'Menu items',
                style: textTheme.labelLarge,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleScroll() {
    if (_isAppBarExpanded != _isExpanded) {
      setState(() {
        _isExpanded = _isAppBarExpanded;
      });
    }
  }
}
