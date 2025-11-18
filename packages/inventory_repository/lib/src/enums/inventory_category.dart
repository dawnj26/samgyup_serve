/// Enumeration of inventory categories used for organizing items.
///
/// Each category represents a different type of inventory item with
/// a shorter enum name and a corresponding display label.
enum InventoryCategory {
  /// Drinks and beverage items
  beverages,

  /// Non-food consumable items
  consumables,

  /// Meat products and protein items
  meats,

  /// Noodles, rice, and other carbohydrate-based items
  noodles,

  /// Sauces, condiments, and flavor enhancers
  sauces,

  /// Storage containers and packaging materials
  storage,

  /// Unknown category, used as a fallback
  unknown,

  /// Vegetables, side dishes, and accompaniments
  vegetables;

  /// Returns the human-readable display label for this category.
  String get label {
    switch (this) {
      case InventoryCategory.beverages:
        return 'Beverages';
      case InventoryCategory.consumables:
        return 'Non-food Consumables';
      case InventoryCategory.meats:
        return 'Meats';
      case InventoryCategory.noodles:
        return 'Noodles, Rice & Carbs';
      case InventoryCategory.sauces:
        return 'Sauces & Condiments';
      case InventoryCategory.storage:
        return 'Storage & Packaging';
      case InventoryCategory.unknown:
        return 'Others';
      case InventoryCategory.vegetables:
        return 'Vegetables & Sides';
    }
  }
}
