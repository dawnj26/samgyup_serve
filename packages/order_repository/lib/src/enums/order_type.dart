/// The type of an order, used to distinguish between single-menu orders and
/// package (bundled) orders.
enum OrderType {
  /// An order consisting of individual menu items.
  menu,

  /// An order consisting of pre-defined packages.
  package
  ;

  /// A human-readable label for this order type.
  String get label {
    switch (this) {
      case OrderType.menu:
        return 'Menu';
      case OrderType.package:
        return 'Package';
    }
  }
}
