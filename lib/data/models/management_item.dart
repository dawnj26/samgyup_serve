import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class ManagementItem {
  const ManagementItem({
    required this.title,
    required this.icon,
    this.route,
  });

  final String title;
  final IconData icon;
  final PageRouteInfo? route;
}
