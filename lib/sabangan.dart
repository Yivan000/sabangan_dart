// This file is auto-generated. Please do not edit nor contribute here.

// ignore_for_file: file_names

library sabangan;

import 'package:decimal/decimal.dart';
import 'package:rational/rational.dart';
import 'dart:collection';
import 'strings.dart';

part 'src/UnitCategories.dart';
part 'src/UnitLength.dart';

mixin Unit on Enum {
  /// Slope of the line, the 'm' in 'y=mx+b', aka the conversion factor. [m1] is the numerator, [m2] is the denominator.
  ///
  /// Access [m] for the full rational.
  String get m1;

  /// Slope of the line, the 'm' in 'y=mx+b', aka the conversion factor. [m1] is the numerator, [m2] is the denominator.
  ///
  /// Access [m] for the full rational.
  String get m2;

  /// The combination of [m1] and [m2].
  Rational get m => Rational(m1.toBigInt(), m2.toBigInt());

  /// Y-intercept of the line, the 'b' in 'y=mx+b', aka the zero point. [b1] is numerator, [b2] is denominator.
  ///
  /// Access [b] for the full rational.
  String get b1;

  /// Y-intercept of the line, the 'b' in 'y=mx+b', aka the zero point. [b1] is numerator, [b2] is denominator.
  ///
  /// Access [b] for the full rational.
  String get b2;

  /// The combination of [b1] and [b2].
  Rational get b => Rational(b1.tryBigInt() ?? BigInt.zero, b2.toBigInt());

  /// The category that this unit falls into.
  UnitCategory get category;

  /// Converts from the [base] unit to this' unit.
  ///
  /// Example:
  /// ```dart
  /// Rational a = UnitLength.inch.convertFromBase("0.0254".toRational());
  /// print(a);
  /// // "0.0254" is in the base unit (meter)
  /// // outputs 1 as there is 1 inch in 0.0254 meter
  /// ```
  // x = (y-b)/m
  Rational convertFromBase(Rational base) => (base - b) / m;

  /// Converts from this' unit to the [base] unit.
  ///
  /// Example:
  /// ```dart
  /// Rational a = UnitLength.inch.convertToBase("1".toRational());
  /// print(a);
  /// // "1" is in inches
  /// // outputs 0.0254 as there is 0.0254 meters in 1 inch
  /// ```
  // y = mx+b
  Rational convertToBase(Rational input) => (m * input) + b;

  /// This unit's amount when there is 1 base unit. Shortcut for `convertToBase(Rational.one)`.
  Rational convertOneBase() => convertToBase(Rational.one);

  /// Main conversion function. Takes an [inputUnit] and [inputRational] and outputs the corresponding rational using the [outputUnit].
  ///
  /// Example:
  /// ```dart
  /// Rational a = Unit.convert(
  ///   inputUnit: UnitLength.meter,
  ///   inputRational: "0.0254".toRational(),
  ///   outputUnit: UnitLength.inch,
  /// );
  /// print(a);
  /// // "1" is in meters
  /// // outputs 1 as there is 1 inch in 0.0254 meters
  /// ```
  // Converts input into base, then converts it into desired unit
  static Rational convert({
    required Unit inputUnit,
    required Rational inputRational,
    required Unit outputUnit,
    bool checkSameType = true,
  }) {
    if (checkSameType) checkIfSameType(inputUnit, outputUnit);
    return outputUnit.convertFromBase(
      inputUnit.convertToBase(inputRational),
    );
  }

  /// Main conversion function. Takes an [inputUnit] and [inputRational] and outputs the corresponding rational (using the [outputUnits] set) as a [Map] with the key as the unit and the value as the conversion.
  ///
  ///  Example:
  /// ```dart
  /// Rational a = Unit.convert(
  ///   inputUnit: UnitLength.meter,
  ///   inputRational: "1.6".toRational(),
  ///   outputUnits: {
  ///     UnitLength.foot,
  ///     UnitLength.inch,
  ///   },
  /// );
  /// print(a);
  /// // "1.6" is in meters
  /// // outputs the map (string values are as [Rational]):
  /// {
  ///   UnitLength.foot: '5',
  ///   UnitLength.inch: '380/127'
  /// }
  /// ```
  ///
  /// [outputUnits] is a [Set] so that units won't be repeated. It is automatically ordered in order of decreasing units.
  static Map<Unit, Rational> convertWithRemainder({
    required Unit inputUnit,
    required Rational inputRational,
    required Set<Unit> outputUnits,
    bool checkSameType = true,
  }) {
    // Check if every outputUnit is the same type as inputUnit
    if (checkSameType) checkIfSameTypeAll(inputUnit, outputUnits);

    late Rational temp;

    // Use a SplayTreeMap to automatically sort
    var out = SplayTreeMap<Unit, Rational>.fromIterables(
      outputUnits,
      List.filled(outputUnits.length, Rational.zero),
      (a, b) => b.convertOneBase().compareTo(a.convertOneBase()),
    );

    for (final i in out.entries) {
      // Temporarily store the converted value from input/list
      temp = convert(
        inputUnit:
            i.key == out.firstKey() ? inputUnit : out.lastKeyBefore(i.key)!,
        inputRational: i.key == out.firstKey() ? inputRational : temp,
        outputUnit: i.key,
      );
      // If last, then the remainder, else the integer
      out[i.key] = i.key == out.lastKey() ? temp : temp.toBigInt().toRational();
      // Subtract the converted from its integer
      temp = temp - out[i.key]!;
    }
    return out;
  }

  /// The localized name of the unit.
  String get name => strings['${toString()}.name'];

  /// The localized symbol of the unit.
  String get symbol => strings['${toString()}.name'];

  /// The localized description of the unit.
  String get desc => strings['${toString()}.name'];

  @override
  String toString() {
    return "$name $symbol=($m)x+$b";
  }

  bool isSameType(Unit other) => runtimeType == other.runtimeType;

  static void checkIfSameType(Unit a, Unit b) {
    if (a.isSameType(b)) return;
    throw TypeError();
  }

  static void checkIfSameTypeAll(Unit a, Iterable<Unit> b) {
    if (b.every((i) => a.isSameType(i))) return;
    throw TypeError();
  }
}

extension StringExtensions on String? {
  Rational toRational() => Rational.parse(this!);
  Rational? tryRational() => this != null ? Rational.tryParse(this!) : null;

  BigInt toBigInt() => BigInt.parse(this!);
  BigInt? tryBigInt() => this != null ? BigInt.tryParse(this!) : null;
}

extension RationalExtensions on Rational {}

extension IterableUnitExtensions on Iterable<Unit> {
  /// Gets the units from a particular [category].
  Iterable<Unit> getUnitsFromCategory(UnitCategory category) =>
      where((e) => e.category == category).toSet();

  /// Converts into a [SplayTreeMap] (sorted by category) wherein key is the [UnitCategory] and value is a [List] of units (sorted by increasing unit).
  ///
  /// Example:
  /// ```dart
  /// var units = {
  ///   UnitLength.meter,
  ///   UnitLength.inch,
  ///   UnitLength.foot,
  ///   UnitLength.millimeter,
  /// };
  /// var map = units.toUnitCategoryMap();
  /// // [map]
  /// ```
  SplayTreeMap<UnitCategory, List<Unit>> toUnitCategoryMap() =>
      SplayTreeMap.fromIterable(
        this,
        key: (e) => (e as Unit).category,
        value: (e) => List.of(getUnitsFromCategory((e as Unit).category))
          ..sort(
            (a, b) => a.convertOneBase().compareTo(b.convertOneBase()),
          ),
        compare: (a, b) => a.index.compareTo(b.index),
      );
}
