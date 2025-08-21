import 'package:flutter/material.dart';
import 'package:inventory_repository/inventory_repository.dart';

extension InventoryItemStatusX on InventoryItemStatus {
  Color get color {
    switch (this) {
      case InventoryItemStatus.inStock:
        return Colors.green.shade100;
      case InventoryItemStatus.lowStock:
        return Colors.orange.shade100;
      case InventoryItemStatus.outOfStock:
        return Colors.red.shade100;
      case InventoryItemStatus.expired:
        return Colors.grey.shade200;
    }
  }
}
