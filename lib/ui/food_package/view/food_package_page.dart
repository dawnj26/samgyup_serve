import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:samgyup_serve/ui/food_package/view/food_package_screen.dart';

@RoutePage()
class FoodPackagePage extends StatelessWidget {
  const FoodPackagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const FoodPackageScreen();
  }
}
