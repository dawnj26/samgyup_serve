/// {@template menu_info}
/// Represents information about menu items including availability statistics.
///
/// This class provides a summary of menu
/// items categorized by their availability status.
/// It's typically used to display overview
/// information about the current menu state.
/// {@endtemplate}
class MenuInfo {
  /// {@macro menu_info}
  const MenuInfo({
    required this.totalItems,
    required this.availableItems,
    required this.unavailableItems,
  });

  /// Creates an empty [MenuInfo] instance with all counts set to zero.
  const MenuInfo.empty()
    : this(
        totalItems: 0,
        availableItems: 0,
        unavailableItems: 0,
      );

  /// The total number of menu items across all categories.
  ///
  /// This represents the sum of all menu items
  /// regardless of their availability status.
  final int totalItems;

  /// The number of menu items that are currently available for ordering.
  ///
  /// This count includes only items that customers can currently order.
  final int availableItems;

  /// The number of menu items that are currently unavailable for ordering.
  ///
  /// This includes items that are temporarily out of stock, discontinued,
  /// or otherwise not available for customers to order.
  final int unavailableItems;
}
