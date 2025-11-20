import 'package:flutter/material.dart';
import 'package:inventory_repository/inventory_repository.dart';

extension InventoryItemStatusX on InventoryItemStatus {
  MaterialColor get color {
    switch (this) {
      case InventoryItemStatus.inStock:
        return Colors.green;
      case InventoryItemStatus.lowStock:
        return Colors.orange;
      case InventoryItemStatus.outOfStock:
        return Colors.red;
    }
  }
}
