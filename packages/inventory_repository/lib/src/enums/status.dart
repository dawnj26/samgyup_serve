/// Represents the various status states for inventory items.
///
/// Used to categorize and filter inventory items based on their
/// availability and condition in the system.
enum InventoryItemStatus {
  /// Items that are currently available and have sufficient quantity
  inStock,

  /// Items that have zero quantity or are unavailable
  outOfStock,

  /// Items that have quantity below the minimum threshold
  lowStock,
}

/// Extension that provides human-readable
/// display names for [InventoryItemStatus] values.
///
/// This extension allows easy conversion of enum values to user-friendly
/// strings for display purposes in the UI.
extension InventoryStatusX on InventoryItemStatus {
  /// Returns the human-readable display name for the inventory status.
  ///
  /// Example:
  /// ```dart
  /// final status = InventoryStatus.inStock;
  /// print(status.label); // Output: "In Stock"
  /// ```
  String get label {
    switch (this) {
      case InventoryItemStatus.inStock:
        return 'In Stock';
      case InventoryItemStatus.outOfStock:
        return 'Out of Stock';
      case InventoryItemStatus.lowStock:
        return 'Low Stock';
    }
  }
}
