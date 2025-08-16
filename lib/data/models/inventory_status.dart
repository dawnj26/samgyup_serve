import 'package:flutter/material.dart';

class InventoryStatus {
  const InventoryStatus({
    required this.all,
    required this.inStock,
    required this.lowStock,
    required this.outOfStock,
  });

  final InventoryStatusItem all;
  final InventoryStatusItem inStock;
  final InventoryStatusItem lowStock;
  final InventoryStatusItem outOfStock;
}

class InventoryStatusItem {
  const InventoryStatusItem({
    required this.title,
    required this.count,
    this.color,
  });

  final String title;
  final int count;
  final Color? color;
}
