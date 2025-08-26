/// Represents the common categories found in a
/// samgyupsal restaurant menu.
enum MenuCategory {
  /// Items that can be ordered individually, not part of a set.
  aLaCarteMeats,

  /// A specific category for the various types of meat available for grilling.
  grilledMeats,

  /// The Korean side dishes that accompany the main meal.
  sideDishes,

  /// Rice and noodle-based dishes.
  riceAndNoodles,

  /// Korean soups and stews.
  soupsAndStews,

  /// The various sauces and dips provided.
  saucesAndDips,

  /// The list of beverages available.
  beverages,

  /// Dessert items.
  desserts,
}

/// Extension on [MenuCategory] to provide additional functionality.
extension SamgyupMenuCategoryExtension on MenuCategory {
  /// Returns a human-readable label for the menu category.
  String get label {
    switch (this) {
      case MenuCategory.aLaCarteMeats:
        return 'À La Carte Meats';
      case MenuCategory.grilledMeats:
        return 'Grilled Meats';
      case MenuCategory.sideDishes:
        return 'Side Dishes (Banchan)';
      case MenuCategory.riceAndNoodles:
        return 'Rice & Noodles';
      case MenuCategory.soupsAndStews:
        return 'Soups & Stews';
      case MenuCategory.saucesAndDips:
        return 'Sauces & Dips';
      case MenuCategory.beverages:
        return 'Beverages';
      case MenuCategory.desserts:
        return 'Desserts';
    }
  }
}
