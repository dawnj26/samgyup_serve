import 'package:flutter/material.dart';
import 'package:samgyup_serve/data/models/management_item.dart';
import 'package:samgyup_serve/router/router.dart';

final List<ManagementItem> managementItems = [
  const ManagementItem(
    title: 'Inventory',
    icon: Icons.inventory_2_rounded,
    route: InventoryRoute(),
  ),
  const ManagementItem(
    title: 'Menu',
    icon: Icons.restaurant_menu,
    route: MenuShellRoute(),
  ),
  const ManagementItem(
    title: 'Packages',
    icon: Icons.card_giftcard_rounded,
    route: FoodPackageShellRoute(),
  ),
  const ManagementItem(
    title: 'Tables',
    icon: Icons.table_bar_rounded,
    route: TableRoute(),
  ),
  const ManagementItem(
    title: 'Settings',
    icon: Icons.settings,
    route: SettingsRoute(),
  ),
];
