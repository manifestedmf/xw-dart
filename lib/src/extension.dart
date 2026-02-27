import 'mixins.dart';
import 'standard.dart' as std;

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
  int get intLengthUnsigned => intLength;
  int get intLengthSigned => "${truncate()}".length;

  int get decimalLength =>
      (isSigned)
          ? decimalLengthSigned-1
          : decimalLengthSigned;
  int get decimalLengthUnsigned => decimalLength;
  int get decimalLengthSigned =>
      (isWhole)
          ? 0
          : length - (intLengthSigned + 1);

  bool get isSigned => isNegative;
  bool get isPositive => this >= 0;

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

  int get lengthSigned => "$this".length;

  int get intLengthSigned => length;

  int get decimalLength => 0;
  int get decimalLengthUnsigned => decimalLength;
  int get decimalLengthSigned => (isSigned) ? 1 : 0;

  int addAtEnd(int newDigit) => int.parse("$this$newDigit");

  bool get isWhole => true;
}
extension DoubleExtension on double {
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

  bool get isWhole => this == roundToDouble();
}

extension ListExtension on List {
  bool equals(List other) => listEquals(this,other);
}

extension MapExtension<K,V> on Map<K,V> {
  bool equals(Map<K, V> other) => mapEquals(this,other);
  /// This might lose some entries.
  Map<V,K> toReversed() => entries.reverseEntries().toMap();
  @Deprecated("2.7.4 use toReversed()")
  /// This might lose some entries.
  Map<V,K> reverse() => entries.reverseEntries().toMap();
}

/*extension MapExtension2<KV> on Map<KV,KV> {
  /// This might lose some entries.
  /// makes [this] map to the reverse.
  void reverse() {
    final Iterable<MapEntry<KV, KV>> entries = this.entries.toList();
    for (var a in entries) {
      this.remove(a.key);
    }
    for (MapEntry<KV, KV> current in entries) {
      this[current.key] = current.value;
    }
  }
}*/

extension SetExtension on Set {
  bool equals(Set other) => setEquals(this,other);
}

extension IterableExtension on Iterable {
  bool equals(Iterable other) => iterableEquals(this,other);
}

extension IterableBool<B> on Iterable<bool> {
  bool get and => std.and(this);
  bool get nand => std.nand(this);
  bool get xand => std.xand(this);
  bool get xnand => std.xnand(this);
  bool get or => std.or(this);
  bool get nor => std.nor(this);
  bool get xor => std.xor(this);
  bool get xnor => std.xnor(this);
  Iterable<bool> get not => std.not(this);
}

extension IterableMapEntry<K,V> on Iterable<MapEntry<K,V>> {
  /// Reverses each `MapEntry<K,V>` to be `MapEntry<V,K>`.
  /*Iterable<MapEntry<V,K>> reverseEntries() {
    Iterable<MapEntry<V,K>> mule = [
      for (MapEntry<K,V> current in this)
        MapEntry(current.value, current.key)
    ];
    return mule;
  }*/
  Iterable<MapEntry<V,K>> reverseEntries() => [
    for (MapEntry<K,V> current in this)
      MapEntry(current.value, current.key)
  ];
  /// Returns [this] to a [Map].
  Map<K,V> toMap() => Map.fromEntries(this);
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
  String safeSubstring(int start, [int? end]) {
    if (start < 0) {start = 0;}
    else if (start > length) {start = length;}
    if (end == null) {end = length;}
    else if (end < start) {end = start;}
    else if (end > length) {end = length;}
    return substring(start,end);
  }
  ({String start, String end}) splitAt(int index) => (start: truncate(index),end:after(index));
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
  bool get containsWhiteSpace {
    for (int index = 0; index < length; index++) {
      if (this[index].isWhiteSpace) {return true;}
    }
    return false;
  }
  bool get isWhiteSpace => computeIsWhiteSpace(this);
  static bool computeIsWhiteSpace(String character) =>
      character == " " || character == "\n";
  bool get isDigit => computeIsDigit(this);
  static bool computeIsDigit(String character) =>
      switch (character) {
        "0" => true, "1" => true, "2" => true, "3" => true, "4" => true,
        "5" => true, "6" => true, "7" => true, "8" => true, "9" => true,
        String() => false,
      };

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

  bool get isUpperCase => toUpperCase() == this;
  bool get isLowerCase => toLowerCase() == this;

  /// Gets the reverse of this string.
  ///
  /// ```
  /// print(reverse("abc")); // 'cba'
  /// print(reverse("the small dog")); // 'god llams eht'
  /// print(reverse("α is alpha, β is beta")); // 'ateb si β ,ahpla si α'
  /// ```
  @Deprecated("2.7.4 use toReversed()")
  String reverse() {
    String mule = "";
    int i = length-1;
    while (i >= 0) {
      mule += this[i--];
    }
    return mule;
  }

  /// Gets the reverse of this string.
  ///
  /// ```
  /// print(toReversed("abc")); // 'cba'
  /// print(toReversed("the small dog")); // 'god llams eht'
  /// print(toReversed("α is alpha, β is beta")); // 'ateb si β ,ahpla si α'
  /// ```
  String toReversed() {
    String mule = "";
    int i = length-1;
    while (i >= 0) {
      mule += this[i--];
    }
    return mule;
  }

  // TODO: add List<String> toWords().
}