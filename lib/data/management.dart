import 'package:flutter/material.dart';
import 'package:samgyup_serve/app/router/router.dart';
import 'package:samgyup_serve/data/models/management_item.dart';

final List<ManagementItem> managementItems = [
  const ManagementItem(
    title: 'Inventory',
    icon: Icons.inventory_2_rounded,
    route: InventoryRoute(),
  ),
  const ManagementItem(
    title: 'Orders',
    icon: Icons.receipt_long_rounded,
  ),
  const ManagementItem(
    title: 'Customers',
    icon: Icons.people_rounded,
  ),
  const ManagementItem(
    title: 'Settings',
    icon: Icons.settings_rounded,
  ),
];
