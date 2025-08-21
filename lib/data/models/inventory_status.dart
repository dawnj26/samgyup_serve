import 'package:flutter/material.dart';

class InventoryStatus {
  const InventoryStatus({
    required this.all,
    required this.inStock,
    required this.lowStock,
    required this.outOfStock,
    required this.expired,
  });

  factory InventoryStatus.empty() {
    return const InventoryStatus(
      all: InventoryStatusItem(title: 'All', count: 0),
      inStock: InventoryStatusItem(title: 'In Stock', count: 0),
      lowStock: InventoryStatusItem(title: 'Low Stock', count: 0),
      outOfStock: InventoryStatusItem(title: 'Out of Stock', count: 0),
      expired: InventoryStatusItem(title: 'Expired', count: 0),
    );
  }

  final InventoryStatusItem all;
  final InventoryStatusItem inStock;
  final InventoryStatusItem lowStock;
  final InventoryStatusItem outOfStock;
  final InventoryStatusItem expired;
}

class InventoryStatusItem {
  const InventoryStatusItem({
    required this.title,
    this.count,
    this.color,
  });

  final String title;
  final int? count;
  final Color? color;
}
