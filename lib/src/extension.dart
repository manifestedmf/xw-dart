import 'equals.dart';
import 'standard.dart' as std;
import 'math/core.dart';

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
  int get length => (isSigned) ? lengthSigned - 1 : lengthSigned;

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
  int get intLength => (isSigned) ? intLengthSigned - 1 : intLengthSigned;
  int get intLengthUnsigned => intLength;
  int get intLengthSigned => "${truncate()}".length;

  int get decimalLength =>
      (isSigned) ? decimalLengthSigned - 1 : decimalLengthSigned;

  int get decimalLengthUnsigned => decimalLength;

  int get decimalLengthSigned => (isWhole) ? 0 : length - (intLengthSigned + 1);

  bool get isSigned => isNegative;

  bool get isPositive => this >= 0;

  static num get signNum => -1;
}

extension IntExtension on int {
  int towards(int value) {
    if (value < this) {
      return this - 1;
    } else if (value > this) {
      return this + 1;
    } else {
      return this;
    }
  }

  int get towardsZero => towards(0);

  /// is automatically true if 0
  bool higher(int value) {
    if (value >= this) {
      return true;
    } else {
      return false;
    }
  }

  /// is automatically true if 0
  bool lower(int value) {
    if (value <= this) {
      return true;
    } else {
      return false;
    }
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
      if (this - amount < value) {
        return value;
      } else {
        return this - amount;
      }
    } else if (value > this) {
      if (this + amount > value) {
        return value;
      } else {
        return this + amount;
      }
    } else {
      return this;
    }
  }

  bool get isWhole => this == roundToDouble();
}

extension ListE<E> on List<E> {
  /// Added in `2.7`.
  @Deprecated("2.8, use equalsShallow or equalsDeep")
  bool equals(List<E> other, [bool isShallow = true]) =>
      listEquals(this, other, isShallow);

  /// Added in `2.8`.
  bool equalsShallow(List<E> other) => listEqualsShallow(this, other);

  /// Added in `2.8`.
  bool equalsDeep(List<E> other) => listEqualsDeep(this, other);

  /// Removes all occurrences of [value].
  ///
  /// Returns [false] if there is no occurrence of [value].
  ///
  /// Added in `2.8`.
  bool removeAll(E value) {
    if (!contains(E)) {
      return false;
    } else {
      while (remove(value)) ; // removes value while it still exists.
      return true;
    }
  }

  /// Reverses [this] [List].
  ///
  /// Added in `2.8`.
  void reverse() {
    int i, j;
    i = 0;
    j = length - 1;
    E first, last;
    while (i < j) {
      first = this[i];
      last = this[j];
      this[i++] = last;
      this[j++] = first;
    }
  }

  /// Inputs current element to [inv] and selects current element to
  /// be the output of [inv].
  ///
  /// Added in `2.8`.
  void inverse(E Function(E) inv) => changeEach(inv);

  /// Added in `2.8`.
  void changeEach(E Function(E) changer) {
    for (int index = 0; index < length; index++) {
      this[index] = changer(this[index]);
    }
  }

  /// Swaps elements at [a] & [b].
  ///
  /// Added in `2.8`.
  void swap(int a, int b) {
    E element = this[a];
    this[a] = this[b];
    this[b] = element;
  }
}

extension ListBool on List<bool> {
  /// Added in `2.8`.
  void inverseThis() => inverse((b) => !b);
}

extension ListInt on List<int> {
  /// Added in `2.8`.
  void inverseThis() => inverse((n) => ~n);
}


extension ListN<N extends num> on List<N> {
  /// Added in `2.8`.
  void powEach(N number) => changeEach((n) => pow(n, number));
  /// Added in `2.8`.
  void squareEach() => changeEach(square);
}

extension ListNum on List<num> {
  void roundEach() => changeEach(round);
}

extension MapKV<K, V> on Map<K, V> {
  /// Added in `2.7`.
  @Deprecated("2.8, use equalsShallow or equalsDeep")
  bool equals(Map<K, V> other, [bool isShallow = true]) =>
      mapEquals(this, other, isShallow);

  /// Added in `2.8`.
  bool equalsShallow(Map<K, V> other) => mapEqualsShallow(this, other);

  /// Added in `2.8`.
  bool equalsDeep(Map<K, V> other) => mapEqualsDeep(this, other);

  /// This might lose some entries.
  ///
  /// Added in `2.7.3`.
  Map<V, K> toReversed() => entries.reverseEntries().toMap();
}

extension SetE<E> on Set<E> {
  /// Added in `2.7`.
  @Deprecated("2.8, use equalsShallow or equalsDeep")
  bool equals(Set<E> other, [bool isShallow = true]) =>
      setEquals(this, other, isShallow);

  /// Added in `2.8`.
  bool equalsShallow(Set<E> other) => setEqualsShallow(this, other);

  /// Added in `2.8`.
  bool equalsDeep(Set<E> other) => setEqualsDeep(this, other);
}

extension IterableE<E> on Iterable<E> {
  /// Added in `2.7`.
  @Deprecated("2.8, use equalsShallow or equalsDeep")
  bool equals(Iterable<E> other, [bool isShallow = true]) =>
      iterableEquals(this, other, true);

  /// Added in `2.8`.
  bool equalsShallow(Iterable<E> other) => iterableEqualsShallow(this, other);

  /// Added in `2.8`.
  bool equalsDeep(Iterable<E> other) => iterableEqualsDeep(this, other);
}

extension IterableBool on Iterable<bool> {
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

extension IterableMapEntry<K, V> on Iterable<MapEntry<K, V>> {
  /// Reverses each `MapEntry<K,V>` to be `MapEntry<V,K>`.
  /*Iterable<MapEntry<V,K>> reverseEntries() {
    Iterable<MapEntry<V,K>> mule = [
      for (MapEntry<K,V> current in this)
        MapEntry(current.value, current.key)
    ];
    return mule;
  }*/
  Iterable<MapEntry<V, K>> reverseEntries() => [
    for (MapEntry<K, V> current in this) MapEntry(current.value, current.key),
  ];

  /// Returns [this] to a [Map].
  Map<K, V> toMap() => Map.fromEntries(this);
}

extension BoolExtension on bool {
  int toInt() => (this) ? 1 : 0;
}

extension StringExtension on String {
  String truncate(int characters) => substring(0, characters);
  String safeTruncate(int characters) =>
      (characters >= length) ? substring(0, length - 1) : truncate(characters);
  String after(int start) => substring(start);
  String insert(String string, [int index = 0]) =>
      "${truncate(index)}$string${after(index)}";
  String overwrite(String string, [int index = 0]) {
    if (index + string.length >= length) {
      return "${truncate(index)}$string";
    } else {
      return "${truncate(index)}$string${after(index + string.length)}";
    }
  }

  String safeSubstring(int start, [int? end]) {
    if (start < 0) {
      start = 0;
    } else if (start > length) {
      start = length;
    }
    if (end == null) {
      end = length;
    } else if (end < start) {
      end = start;
    } else if (end > length) {
      end = length;
    }
    return substring(start, end);
  }

  ({String start, String end}) splitAt(int index) =>
      (start: truncate(index), end: after(index));

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
      if (this[index].isWhiteSpace) {
        return true;
      }
    }
    return false;
  }

  bool get isWhiteSpace => computeIsWhiteSpace(this);
  static bool computeIsWhiteSpace(String character) => switch (character) {
    " " => true,
    "\n" => true,
    "\t" => true,
    String() => false,
  };

  bool get isDigit => computeIsDigit(this);
  static bool computeIsDigit(String character) => switch (character) {
    "0" => true,
    "1" => true,
    "2" => true,
    "3" => true,
    "4" => true,
    "5" => true,
    "6" => true,
    "7" => true,
    "8" => true,
    "9" => true,
    String() => false,
  };

  String get spaced {
    String mule = this;
    int index = 1;
    while (index < mule.length) {
      if (mule[index].isUpperCase) {
        mule = mule.insert(" ", index++);
      }
      ++index;
    }
    return mule;
  }

  bool get isUpperCase => toUpperCase() == this && length == 1;
  bool get isLowerCase => toLowerCase() == this && length == 1;
  /// Added in `2.8`.
  bool get isUpperCased => toUpperCase() == this;
  /// Added in `2.8`.
  bool get isLowerCased => toLowerCase() == this;

  /// Gets the reverse of [this] [String].
  ///
  /// ```
  /// print(toReversed("abc")); // 'cba'
  /// print(toReversed("the small dog")); // 'god llams eht'
  /// print(toReversed("α is alpha, β is beta")); // 'ateb si β ,ahpla si α'
  /// ```
  ///
  /// Added in `2.7.3`.
  String toReversed() {
    String mule = "";
    int index = length - 1;
    while (index >= 0) {
      mule += this[index--];
    }
    return mule;
  }

  /// Puts each word into a [List].
  ///
  /// Added in `2.8`.
  Iterable<String> toWords() {
    List<String> mule = [];
    String char, builder;
    builder = "";
    bool prevWS = true; // previous was whitespace
    for (int index = 0; index < length; index++) {
      char = this[index];
      if (char.isWhiteSpace) {
        if (prevWS) {
          continue;
        }
        mule.add(builder);
        builder = "";
      } else {
        builder += char;
        prevWS = false;
      }
    }
    mule.add(builder);
    mule.removeAll("");
    return mule;
  }
}
