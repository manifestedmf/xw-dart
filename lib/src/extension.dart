import 'mixins.dart';
import 'internal.dart';

// class Char {
//   final int char;
//   factory Char(String char) => Char.constant(char.codeUnitAt(0));
//   const Char.constant(this.char);
//   @override
//   toString() => "".
// }

extension NumExtension on num {
  /// If the [num].[isWhole] or not;
  ///
  /// Is always true if the the [num] is [int];
  ///
  /// For [double] it returns true if the number is the same as the rounded one;
  ///
  /// Example:
  /// ```
  /// (5).isWhole // true
  /// (6.2).isWhole // false
  /// pi.isWhole // false
  /// (3 as num).isWhole // true
  /// (139.0).isWhole // true
  /// ```
  ///
  /// Added in {\$`uV`, \$`uV`};
  bool get isWhole => this is int || this == roundToDouble();

  @Added("2.7","1.6")
  /// Gets the [unsigned] length of the number;
  ///
  /// For [signed] do [lengthSigned];
  ///
  /// Since some doubles give back a long number;
  /// Meaning the number is sometimes not the one expected;
  ///
  /// Examples:
  /// ```
  /// (5.36).length // 4
  /// (-5.23).length // 4
  /// (5.1 % 1).length // 19
  /// (6).length // 1
  /// pi.length // 17
  /// ```
  ///
  /// Added in {\$`2.7`, \$`1.6`};
  int get length =>
      (isSigned)
          ? lengthSigned-1
          : lengthSigned;
  @Added("2.7","1.6")
  /// Gets the [unsigned] length of the number;
  ///
  /// For [signed] do [lengthSigned];
  ///
  /// Since some doubles give back a long number;
  /// Meaning the number is sometimes not the one expected;
  ///
  /// Examples:
  /// ```
  /// (5.36).lengthUnsigned // 4
  /// (-5.23).lengthUnsigned // 4
  /// (5.1 % 1).lengthUnsigned // 19
  /// (-6).lengthUnsigned // 1
  /// pi.lengthUnsigned // 17
  /// ```
  ///
  /// Added in {\$`2.7`, \$`1.6`};
  int get lengthUnsigned => length;
  @Added("2.7","1.6")
  /// Gets the [signed] length of the number;
  ///
  /// For [unsigned] do [length] or [lengthUnsigned];
  ///
  /// Since some doubles give back a long number;
  /// Meaning the number is sometimes not the one expected;
  ///
  /// Examples:
  /// ```
  /// (5.36).length // 4
  /// (-5.23).length // 5
  /// (5.1 % 1).length // 19
  /// (-6).length // 1
  /// pi.length // 17
  /// ```
  ///
  /// Added in {\$`2.7`, \$`1.6`};
  int get lengthSigned => "$this".length;

  @Added("2.7","1.6")
  /// Gets the [unsigned] whole number length;
  ///
  /// For [signed] do [intLengthSigned];
  ///
  /// Example:
  /// ```
  /// (553).intLength // 3
  /// ```
  int get intLength =>
      (isSigned)
          ? intLengthSigned-1
          : intLengthSigned;
  @Added("2.7","1.6")
  int get intLengthUnsigned => intLength;
  @Added("2.7","1.6")
  int get intLengthSigned => "${truncate()}".length;

  @Added("2.7","1.6")
  int get decimalLength =>
      (isSigned)
          ? decimalLengthSigned-1
          : decimalLengthSigned;
  @Added("2.7","1.6")
  int get decimalLengthUnsigned => decimalLength;
  @Added("2.7","1.6")
  int get decimalLengthSigned =>
      (isWhole)
          ? 0
          : length - (intLengthSigned + 1);

  @Added("2.7","1.6")
  bool get isSigned => isNegative;
  @Added("2.7","1.6")
  bool get isPositive => this >= 0;

  @Added("2.7","1.6")
  static num get signNum => -1;
}

extension IntExtension on int {
  int towards(int value) {
    if (value < this) {return this-1;}
    else if (value > this) {return this+1;}
    else {return this;}
  }
  int get towardsZero => towards(0);
  /// is automatically true if 0
  bool higher(int value) {
    if (value >= this) {return true;}
    else {return false;}
  }
  /// is automatically true if 0
  bool lower(int value) {
    if (value <= this) {return true;}
    else {return false;}
  }
  bool get plusSide => higher(0);
  bool get minusSide => lower(0);

  bool toBool() => this != 0;

  @Added("2.7","1.6")
  int get lengthSigned => "$this".length;

  @Added("2.7","1.6")
  int get intLengthSigned => length;

  @Added("2.7","1.6")
  int get decimalLength => 0;
  @Added("2.7","1.6")
  int get decimalLengthUnsigned => decimalLength;
  @Added("2.7","1.6")
  int get decimalLengthSigned => (isSigned) ? 1 : 0;

  int addAtEnd(int newDigit) => int.parse("$this$newDigit");

  @Added("2.7","1.6")
  bool get isWhole => true;
}
@Added("2.7","1.6")
extension DoubleExtensioon on double {
  @Added("2.7","1.6")
  double towards(double value, [double amount = 1]) {
    if (value < this) {
      if (this-amount < value) {return value;}
      else {return this-amount;}
    }
    else if (value > this) {
      if (this+amount > value) {return value;}
      else {return this+amount;}
    }
    else {return this;}
  }

  @Added("2.7","1.6")
  bool get isWhole => this == roundToDouble();
}

extension ListExtension on List {
  bool equals(List other) => listEquals(this,other);
}

extension MapExtension on Map {
  bool equals(Map other) => mapEquals(this,other);
}

extension SetExtension on Set {
  bool equals(Set other) => setEquals(this,other);
}

extension IterableExtension on Iterable {
  bool equals(Iterable other) => iterableEquals(this,other);
}

extension BoolExtension on bool {
  int toInt() => (this) ? 1 : 0;
}

extension StringExtension on String {
  String truncate(int characters) => substring(0,characters);
  String safeTruncate(int characters) => (characters >= length) ? substring(0,length-1) : truncate(characters);
  String after(int start) => substring(start);
  String insert(String string, [int index = 0]) => "${truncate(index)}$string${after(index)}";
  String overwrite(String string, [int index = 0]) {
    if (index+string.length >= length) {return "${truncate(index)}$string";}
    else {return "${truncate(index)}$string${after(index+string.length)}";}
  }
  @Added("2.6.3","1.4")
  ({String start, String end}) splitAt(int index) => (start: truncate(index),end:after(index));
  @Added("2.6.4","1.5")
  String toTitle() {
    String previous = "";
    String mule = "";
    String current = "";
    for (int index = 0; index < length; index++) {
      if (previous.isWhiteSpace) {
        current = current.toUpperCase();
      }
      mule += current;
      previous = current;
    }
    return mule;
  }
  @Added("2.6.4","1.5")
  bool get containsWhiteSpace {
    for (int index = 0; index < length; index++) {
      if (this[index].isWhiteSpace) {return true;}
    }
    return false;
  }
  @Added("2.6.4","1.5")
  bool get isWhiteSpace => computeIsWhiteSpace(this);
  @Added("2.6.4","1.5")
  static bool computeIsWhiteSpace(String character) =>
      character == " " || character == "\n";
  @Added("2.7","1.6")
  bool get isDigit => computeIsDigit(this);
  @Added("2.7","1.6")
  static bool computeIsDigit(String character) =>
      switch (character) {
        "0" => true, "1" => true, "2" => true, "3" => true, "4" => true,
        "5" => true, "6" => true, "7" => true, "8" => true, "9" => true,
        String() => false,
      };

  @Added("2.7","1.6")
  String get spaced {
    String mule = this;
    int index = 1;
    while (index < mule.length) {
      if (mule[index].isUpperCase) {
        mule = mule.insert(" ",index++);
      }
      ++index;
    }
    return mule;
  }

  @Added("2.7","1.6")
  bool get isUpperCase => toUpperCase() == this;
  @Added("2.7","1.6")
  bool get isLowerCase => toLowerCase() == this;
}