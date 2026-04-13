part of 'numbers.dart';

/// The |absolute| value of [number].
/// (The positive of [number]).
///
/// Added in `2.7.3`.
Fraction absFraction(Fraction number) => (number.isNegative) ? -number : number;

/// Added in `2.7`.
Fraction maxFraction(Iterable<Fraction> fractions, [Fraction? ifNone]) {
  if (fractions.isEmpty) {
    return ifNone ?? (throw StateError("No Optional Parameter Set"));
  }
  Fraction max = fractions.first;
  for (Fraction current in fractions) {
    if (current > max) {
      max = current;
    }
  }
  return max;
}

/// Added in `2.7.3`.
Fraction maxSimpleFraction(Fraction a, Fraction b) => (a > b) ? a : b;

/// Added in `2.7`.
Set<MapEntry<K, Fraction>> maxMapValueFraction<K>(
  Map<K, Fraction> map, [
  MapEntry<K, Fraction>? ifNone,
]) {
  if (map.isEmpty) {
    if (ifNone == null) {
      throw ArgumentError("No optional parameter set", "ifNone");
    }
    return {ifNone};
  }
  Iterable<MapEntry<K, Fraction>> entries = map.entries;
  Set<MapEntry<K, Fraction>> maxSet = {entries.first};
  Fraction max = entries.first.value;
  for (MapEntry<K, Fraction> current in entries) {
    if (current.value > max) {
      maxSet = {current};
      max = current.value;
    } else if (current.value == max) {
      maxSet.add(current);
    }
  }
  return maxSet;
}

/// Added in `2.7`.
MapEntry<Fraction, V> maxMapKeyFraction<V>(
  Map<Fraction, V> map, [
  MapEntry<Fraction, V>? ifNone,
]) {
  if (map.isEmpty) {
    return ifNone ?? (throw StateError("No Optional Parameter Set"));
  }
  Iterable<MapEntry<Fraction, V>> entries = map.entries;
  MapEntry<Fraction, V> max = entries.first;
  for (MapEntry<Fraction, V> current in entries) {
    if (current.key > max.key) {
      max = current;
    }
  }
  return max;
}

/// Added in `2.7`.
Fraction minFraction(Iterable<Fraction> fractions, [Fraction? ifNone]) {
  if (fractions.isEmpty) {
    return ifNone ?? (throw StateError("No Optional Parameter Set"));
  }
  Fraction min = fractions.first;
  for (Fraction current in fractions) {
    if (current < min) {
      min = current;
    }
  }
  return min;
}

/// Added in `2.7.3`.
Fraction minSimpleFraction(Fraction a, Fraction b) => (a < b) ? a : b;

/// Added in `2.7`.
MapEntry<Fraction, V> minMapKeyFraction<V>(
  Map<Fraction, V> map, [
  MapEntry<Fraction, V>? ifNone,
]) {
  if (map.isEmpty) {
    return ifNone ?? (throw StateError("No Optional Parameter Set"));
  }
  Iterable<MapEntry<Fraction, V>> entries = map.entries;
  MapEntry<Fraction, V> min = entries.first;
  for (MapEntry<Fraction, V> current in entries) {
    if (current.key < min.key) {
      min = current;
    }
  }
  return min;
}

/// Added in `2.7`.
Set<MapEntry<K, Fraction>> minMapValueFraction<K>(
  Map<K, Fraction> map, [
  MapEntry<K, Fraction>? ifNone,
]) {
  if (map.isEmpty) {
    if (ifNone == null) {
      throw StateError("No Optional Parameter Set");
    }
    return {ifNone};
  }
  Iterable<MapEntry<K, Fraction>> entries = map.entries;
  Set<MapEntry<K, Fraction>> minSet = {entries.first};
  Fraction min = entries.first.value;
  for (MapEntry<K, Fraction> current in entries) {
    if (current.value < min) {
      minSet = {current};
      min = current.value;
    } else if (current.value == min) {
      minSet.add(current);
    }
  }
  return minSet;
}

/// Added in `2.7`.
Fraction sumFraction(Iterable<Fraction> fractions, [Fraction? starting]) {
  Fraction sum;
  sum = (starting == null) ? Fraction.compressed(0, 0) : starting;
  for (Fraction current in fractions) {
    sum += current;
  }
  return sum;
}

/// Added in `2.7`.
Fraction powFraction(Fraction base, int exponent) => base ^ exponent;

/// Adds very specific [Fraction] class.
///
/// Added in `2.7`.
class Fraction extends Num with Compare<Fraction> {
  /// The operand.
  ///
  /// Added in `2.7`.
  final int oper;

  /// The divisor.
  ///
  /// Added in `2.7`.
  final int div;

  /// If the [Fraction] is fully known to be compressed.
  ///
  /// Added in `2.7.3`.
  final bool _isCompressed;

  int get integer => oper ~/ div;
  double get float => oper / div;
  Fraction get fraction => this;

  /// Added in `2.8`.
  static const Fraction minusOne = Fraction._compressed(-1, 1);

  /// Added in `2.8`.
  static const Fraction zero = Fraction._compressed(0, 1);

  /// Added in `2.7`.
  static const Fraction one = Fraction._compressed(1, 1);

  /// Added in `2.7`.
  static const Fraction half = Fraction._compressed(1, 2);

  /// Added in `2.7`.
  static const Fraction third = Fraction._compressed(1, 3);

  /// Added in `2.7`.
  static const Fraction quarter = Fraction._compressed(1, 4);

  /// Added in `2.7`.
  static const Fraction fifth = Fraction._compressed(1, 5);

  /// Added in `2.7`.
  static const Fraction sixth = Fraction._compressed(1, 6);

  /// Added in `2.7`.
  static const Fraction seventh = Fraction._compressed(1, 7);

  /// Added in `2.7`.
  static const Fraction eighth = Fraction._compressed(1, 8);

  /// Added in `2.7`.
  static const Fraction ninth = Fraction._compressed(1, 9);

  /// Added in `2.7`.
  static const Fraction tenth = Fraction._compressed(1, 10);

  /// Added in `2.7`.
  static const Fraction twoThirds = Fraction._compressed(2, 3);

  /// Added in `2.7.3`.
  static const Fraction twoQuarters = half;

  /// Added in `2.7`.
  static const Fraction threeQuarters = Fraction._compressed(3, 4);

  /// Added in `2.7`.
  static const Fraction twoFifths = Fraction._compressed(2, 5);

  /// Added in `2.7`.
  static const Fraction threeFifths = Fraction._compressed(3, 5);

  /// Added in `2.7`.
  static const Fraction fourFifths = Fraction._compressed(4, 5);

  /// Added in `2.7.3`.
  static const Fraction twoSixths = third;

  /// Added in `2.7.3`.
  static const Fraction threeSixths = half;

  /// Added in `2.7.3`.
  static const Fraction fourSixths = twoThirds;

  /// Added in `2.7`.
  static const Fraction fiveSixths = Fraction._compressed(5, 6);

  /// Added in `2.7`.
  static const Fraction twoSevenths = Fraction._compressed(2, 7);

  /// Added in `2.7`.
  static const Fraction threeSevenths = Fraction._compressed(3, 7);

  /// Added in `2.7`.
  static const Fraction fourSevenths = Fraction._compressed(4, 7);

  /// Added in `2.7`.
  static const Fraction fiveSevenths = Fraction._compressed(5, 7);

  /// Added in `2.7`.
  static const Fraction sixSevenths = Fraction._compressed(6, 7);

  /// Added in `2.7.3`.
  static const Fraction twoEighths = quarter;

  /// Added in `2.7`.
  static const Fraction threeEighths = Fraction._compressed(3, 8);

  /// Added in `2.7.3`.
  static const Fraction fourEighths = half;

  /// Added in `2.7`.
  static const Fraction fiveEighths = Fraction._compressed(5, 8);

  /// Added in `2.7.3`.
  static const Fraction sixEighths = threeQuarters;

  /// Added in `2.7`.
  static const Fraction sevenEights = Fraction._compressed(7, 8);

  /// Added in `2.7`.
  static const Fraction twoNinths = Fraction._compressed(2, 9);

  /// Added in `2.7.3`.
  static const Fraction threeNinths = third;

  /// Added in `2.7`.
  static const Fraction fourNinths = Fraction._compressed(4, 9);

  /// Added in `2.7`.
  static const Fraction fiveNinths = Fraction._compressed(5, 9);

  /// Added in `2.7.3`.
  static const Fraction sixNinths = twoThirds;

  /// Added in `2.7`.
  static const Fraction sevenNinths = Fraction._compressed(7, 9);

  /// Added in `2.7`.
  static const Fraction eightNinths = Fraction._compressed(8, 9);

  /// Added in `2.7.3`.
  static const Fraction twoTenths = fifth;

  /// Added in `2.7`.
  static const Fraction threeTenths = Fraction._compressed(3, 10);

  /// Added in `2.7.3`.
  static const Fraction fourTenths = twoFifths;

  /// Added in `2.7.3`.
  static const Fraction fiveTenths = half;

  /// Added in `2.7.3`.
  static const Fraction sixTenths = threeFifths;

  /// Added in `2.7`.
  static const Fraction sevenTenths = Fraction._compressed(7, 10);

  /// Added in `2.7.3`.
  static const Fraction eightTenths = fourFifths;

  /// Added in `2.7`.
  static const Fraction nineTenths = Fraction._compressed(9, 10);

  /// Added in `2.7`.
  bool get isWhole => !isNaN && (oper % div == 0 || oper == 0);
  Fraction roundToFraction() {
    Fraction fraction = toCompressed();
    int oper = fraction.oper;
    int index = 1;
    while (!isDivBy(oper, fraction.div)) {
      oper += index;
      index = -++index;
    }
    return Fraction.compressed(oper, fraction.div);
  }

  int round() => roundToFraction().integer;
  double roundToDouble() => roundToFraction().float;

  /// Added in `2.7`.
  String get visualRepresentation {
    if (isWhole) {
      return "$integer";
    } else if (isMadeUpOf(div, [2, 5])) {
      return "$float";
    } else if (isMadeUpOf(div, [3])) {
      return (oper % 3 == 1) ? "$integer.33..." : "$integer.66...7";
    } else {
      return "$float";
    }
  }

  String get closeness {
    if (isWhole) {
      return "=";
    } else if (isMadeUpOf(div, [2, 5])) {
      return "=";
    } else if (isMadeUpOf(div, [3])) {
      return "=";
    } else {
      return "≈";
    }
  }

  String get afterVisualRepr => visualRepresentation.substring(2);

  /// Added in `2.7`.
  @override
  String toString({bool percentage = false}) =>
      (percentage) ? toStringAsPercentage() : _toString();

  /// Added in `2.8`.
  String _toString() => "$string $closeness $visualRepresentation";

  String toStringAsPercentage() =>
      "${(this * Fraction.fromInt(100)).visualRepresentation}%";

  /// Added in `2.7`.
  String get string => "$oper/$div";

  /// Added in `2.7`.
  factory Fraction.fromDouble(double number) =>
      Fraction.compressed(number.truncate(), pow(10, number.decimalLength));

  /// Added in `2.7`.
  const Fraction.fromInt(int oper) : this._compressed(oper, 1);

  /// Added in `2.7`.
  factory Fraction.fromNum(num number) {
    if (number is double) {
      return Fraction.fromDouble(number);
    } else if (number is int) {
      return Fraction.fromInt(number);
    } else {
      throw "unexpected new number class";
    }
  }

  /// For any [const] material. All others should use [Fraction.compressed]
  ///
  /// Added in `2.7.3`.
  const Fraction.constant(this.oper, this.div) : _isCompressed = false;

  /// Added in `2.7.3`.
  const Fraction._compressed(this.oper, this.div) : _isCompressed = true;

  /// Added in `2.7`.
  factory Fraction.compressed(int operand, int divisor) {
    if (operand == 0 && divisor == 0) {
      return Fraction._compressed(operand, divisor);
    } else if (operand == 0) {
      return Fraction._compressed(operand, 1);
    }
    if (divisor == 0) {
      return Fraction._compressed(1, divisor);
    }
    var (a: oper, b: div) = gcd(operand, divisor);
    return Fraction._compressed(oper, div);
  }

  /// Added in `2.7.3`.
  factory Fraction.compressor(Fraction fraction) => fraction.toCompressed();

  /// Compresses [this] to the most it can be.
  ///
  /// Being compressed means it returns itself.
  ///
  /// Added in `2.7.3`.
  Fraction toCompressed() => (_isCompressed) ? this : _compress();

  /// Added in `2.7.3`.
  Fraction _compress() => Fraction.compressed(oper, div);

  @override
  /// Added in `2.7`.
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    } else if (other is! Fraction) {
      return false;
    } else {
      Fraction thisF = toCompressed();
      Fraction otherF = other.toCompressed();
      return thisF.div == otherF.div && thisF.oper == otherF.oper;
    }
  }

  @override
  /// Added in `2.7`.
  int get hashCode {
    if (_isCompressed) {
      return Object.hash(oper, div);
    } else {
      return Fraction.compressor(this).hashCode;
    }
  }

  @override
  /// Added in `2.7`.
  bool operator <(Fraction other) {
    if (integer != other.integer) {
      return integer < other.integer;
    } else {
      Fraction thisMut = this;
      thisMut %= one;
      other %= one;
      return thisMut.float < other.float;
    }
  }

  /// Added in `2.7`.
  Fraction operator +(Fraction other) =>
      Fraction.compressed(oper * other.div + div * other.oper, div * other.div);
  // a*d + b*c, b*d

  /// Added in `2.7`.
  Fraction operator -(Fraction other) =>
      Fraction.compressed(oper * other.div - div * other.oper, div * other.div);
  // a*d - b*c, b*d

  /// Added in `2.7`.
  Fraction operator -() {
    if (_isCompressed) {
      return Fraction._compressed(-oper, div);
    } else {
      return Fraction.compressed(-oper, -div);
    }
  }

  /// Added in `2.7`.
  Fraction operator *(Fraction other) =>
      Fraction.compressed(oper * other.oper, div * other.div);

  /// Divides this by other.
  ///
  /// Added in `2.7`.
  Fraction operator /(Fraction other) => this * ~other;

  /// Divides and floors to nearest whole number.
  ///
  /// Added in `2.7`.
  Fraction operator ~/(Fraction other) => (this / other).floorToFraction();

  /// Added in `2.7`.
  Fraction operator %(Fraction other) {
    if (other == one) {
      return Fraction.compressed(div % oper, oper);
    } else {
      Fraction mule = this;
      while (mule < other) {
        mule += other;
      }
      while (mule > other) {
        mule -= other;
      }
      return mule;
    }
  }

  /// Raises [oper] & [div] to [exponent].
  ///
  /// Added in `2.7`.
  Fraction operator ^(int exponent) =>
      Fraction.compressed(pow(oper, exponent), pow(div, exponent));

  /// Flips [div] & [oper].
  ///
  /// Added in `2.8`.
  Fraction flip() => Fraction.compressed(div, oper);

  /// Added in `2.7`.
  bool get isNaN => div == 0;

  /// Added in `2.7`.
  bool get isInfinite => div == 0;

  /// Added in `2.7`.
  bool get isFinite => div != 0;

  /// Added in `2.7`.
  bool get isNegative => div.isNegative ^ oper.isNegative;

  /// Added in `2.7`.
  bool get isPositive => !isNegative;

  /// Added in `2.7`.
  Fraction floorToFraction() {
    Fraction fraction = toCompressed();
    if (fraction.div == 1) {
      return fraction;
    } else {
      return Fraction.compressed(
        getPreviousFactor(fraction.oper, fraction.div),
        1,
      );
    }
  }

  /// Added in `2.7.3`.
  int floor() => floorToFraction().integer;

  /// Added in `2.7.3`.
  double floorToDouble() => floorToFraction().float;

  /// Added in `2.7.3`.
  Fraction ceilToFraction() {
    Fraction fraction = toCompressed();
    if (fraction.div == 1) {
      return fraction;
    } else {
      return Fraction.compressed(getNextFactor(fraction.oper, fraction.div), 1);
    }
  }

  /// Added in `2.7.3`.
  int ceil() => ceilToFraction().integer;

  /// Added in `2.7.3`.
  double ceilToDouble() => ceilToFraction().float;

  // @override
  // Fraction parse(String text) => throw UnimplementedError();

  /*
  /// Added in `2.8.1`.
  static Fraction? tryParse(String text) {
    int oper = 0;
    int div = 0;
    bool expectedOper = true;
    for (int index = 0; index < text.length; index++) {
      switch (text[index]) {
        case " ":
        case "\n":
        case "\t":
        case "\r":
          break;
        case "/":
          if (expectedOper) {
            expectedOper = false;
          } else {
            return null;
          }
        case "0":
        case "1":
        case "2":
        case "3":
        case "4":
        case "5":
        case "6":
        case "7":
        case "8":
        case "9":
          if (expectedOper) {
            oper *= 10;
            oper += int.parse(text[index]);
          } else {
            div *= 10;
            oper += int.parse(text[index]);
          }
        case _:
          return null;
      }
    }
  }
  */
}

/// Added in `2.7`.
int getPreviousFactor(int number, int divisor) => (number ~/ divisor) * divisor;

/// Added in `2.7`.
int getNextFactor(int number, int divisor) => (number ~/ divisor + 1) * divisor;

extension FractionExtensionInt on int {
  /// Added in `2.7`.
  Fraction toFraction() => Fraction.fromInt(this);
}

extension FractionExtensionDouble on double {
  /// Added in `2.7`.
  Fraction toFraction() => Fraction.fromDouble(this);
}

extension FractionExtensionNum on num {
  /// Added in `2.7.3`.
  Fraction toFraction() => Fraction.fromNum(this);
}

/*
/// Added in `2.7`.
Fraction percentage<N extends num>(N number) =>
  Fraction.compressed(number.truncate(),pow(10,number.decimalLength));
*/
