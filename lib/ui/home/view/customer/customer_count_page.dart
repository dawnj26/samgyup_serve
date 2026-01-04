import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:samgyup_serve/ui/home/view/customer/customer_count_screen.dart';

@RoutePage()
class CustomerCountPage extends StatelessWidget {
  const CustomerCountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomerCountScreen();
  }
}
