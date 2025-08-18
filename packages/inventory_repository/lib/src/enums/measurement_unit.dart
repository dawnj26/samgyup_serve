/// Represents different units of measurement for inventory items.
///
/// This enum covers weight, volume, and count-based units commonly used
/// in restaurant inventory management systems.
enum MeasurementUnit {
  /// Weight unit: grams
  grams,

  /// Weight unit: kilograms
  kilograms,

  /// Weight unit: pounds
  pounds,

  /// Weight unit: ounces
  ounces,

  /// Volume unit: milliliters
  milliliters,

  /// Volume unit: liters
  liters,

  /// Volume unit: cups
  cups,

  /// Volume unit: gallons
  gallons,

  /// Count unit: individual piece
  piece,

  /// Count unit: package/pack
  pack,

  /// Count unit: bottle
  bottle,

  /// Count unit: can
  can,

  /// Count unit: tray
  tray,

  /// Count unit: box
  box,

  /// Count unit: set
  set,

  /// Count unit: roll
  roll,

  /// Count unit: sheet
  sheet,

  /// Count unit: bundle
  bundle,

  /// Count unit: dozen (12 pieces)
  dozen,

  /// Represents an unknown or unspecified measurement unit.
  unknown,
}

/// Extension methods for the [MeasurementUnit]
/// enum to provide string conversion utilities
extension UnitExtension on MeasurementUnit {
  /// Returns the string representation of the unit.
  String get value {
    switch (this) {
      case MeasurementUnit.grams:
        return 'grams';
      case MeasurementUnit.kilograms:
        return 'kilograms';
      case MeasurementUnit.pounds:
        return 'pounds';
      case MeasurementUnit.ounces:
        return 'ounces';
      case MeasurementUnit.milliliters:
        return 'milliliters';
      case MeasurementUnit.liters:
        return 'liters';
      case MeasurementUnit.cups:
        return 'cups';
      case MeasurementUnit.gallons:
        return 'gallons';
      case MeasurementUnit.piece:
        return 'piece';
      case MeasurementUnit.pack:
        return 'pack';
      case MeasurementUnit.bottle:
        return 'bottle';
      case MeasurementUnit.can:
        return 'can';
      case MeasurementUnit.tray:
        return 'tray';
      case MeasurementUnit.box:
        return 'box';
      case MeasurementUnit.set:
        return 'set';
      case MeasurementUnit.roll:
        return 'roll';
      case MeasurementUnit.sheet:
        return 'sheet';
      case MeasurementUnit.bundle:
        return 'bundle';
      case MeasurementUnit.dozen:
        return 'dozen';
      case MeasurementUnit.unknown:
        return 'other';
    }
  }

  /// Creates a [MeasurementUnit] from its string representation.
  ///
  /// Returns [MeasurementUnit.piece] as the default fallback if the string
  /// doesn't match any known unit value.
  ///
  /// Example:
  /// ```dart
  /// final unit = Unit.fromString('kilograms'); // Returns Unit.kilograms
  /// final fallback = Unit.fromString('unknown'); // Returns Unit.piece
  /// ```
  static MeasurementUnit fromString(String value) {
    return MeasurementUnit.values.firstWhere(
      (e) => e.value == value,
      orElse: () => MeasurementUnit.piece, // default fallback
    );
  }
}
