import 'equals.dart';
import 'standard.dart'
    as std
    show and, xand, nand, xnand, or, xor, nor, xnor, not;
import 'math/math.dart' show pow, square, round, max, min, sum, properties;
import '../sort.dart' as sort show inlineSort, SortAlg;
import 'bitwise.dart' show readBit;
import '../typedef.dart' show Words, Amount;
import 'io/file.dart' show ParseError;
import 'dart:core'
    show
        num,
        bool,
        int,
        double,
        List,
        Object,
        Set,
        String,
        Map,
        MapEntry,
        Iterable,
        Deprecated,
        StringBuffer;
import 'dart:collection' show IterableExtensions;

// class Char {
//   final int char;
//   factory Char(String char) => Char.constant(char.codeUnitAt(0));
//   const Char.constant(this.char);
//   @override
//   toString() => "".
// }

/// Added in `2.7`.
extension NumExt on num {
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

  /// Returns the rounded value of this in that type.
  ///
  /// Added in `2.8`.
  num roundToThis() => switch (this) {
    double() => roundToDouble(),
    int() => this,
  };
}

/// Added in `2.7`.
extension IntExt on int {
  int towards(int value, [int amount = 1]) {
    if (value < this) {
      return this - amount;
    } else if (value > this) {
      return this + amount;
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

  /// Added in `2.8`.
  int roundToThis() => this;

  /// Added in `2.8`.
  bool get isSigned => readBit(this, 63);
}

/// Added in `2.7`.
extension DoubleExt on double {
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

  /// Added in `2.8`.
  double roundToThis() => roundToDouble();
}

/// Added in `2.8`.
extension ListE<E> on List<E> {
  /// Added in `2.8`.
  bool equalsShallow(List<E> other) => listEqualsShallow(this, other);

  /// Added in `2.8`.
  bool equalsDeep(List<E> other) => listEqualsDeep(this, other);

  /// Removes all occurrences of [value].
  ///
  /// Returns `false` if there is no occurrence of [value].
  ///
  /// Adds if [equal] returns `true`,
  /// [equal] should compare input vs [value].
  ///
  /// [equal] is normally `(e) => e == value`.
  ///
  /// Added in `2.8`.
  bool removeAll(Object? value, [bool Function(E)? equal]) {
    Set<int> indexes = indexesOf(value, equal);
    if (indexes.isEmpty) {
      return false;
    } else {
      for (int index = indexes.length - 1; index >= 0; index--) {
        removeAt(indexes.elementAt(index));
      }
      return true;
    }
  }

  /// Gives all indexes of occurrences of [value] in [this].
  ///
  /// Adds if [equal] returns `true`,
  /// [equal] should compare input vs [value].
  ///
  /// [equal] is normally `(e) => e == value`.
  ///
  /// Added in `2.8`.
  Set<int> indexesOf(Object? value, [bool Function(E)? equal]) {
    equal ??= (e) => e == value;
    Set<int> indexes = {};
    for (int index = 0; index < length; index++) {
      if (this[index] == value) {
        indexes.add(index);
      }
    }
    return indexes;
  }

  /// Removes the first item in the list.
  ///
  /// Added in `2.8`.
  E removeFirst() => removeAt(0);

  /// Added in `2.8`.
  E? removeAtOrNull(int index) {
    if (index < 0 || index >= length) {
      return null;
    } else {
      return removeAt(index);
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

  /// If [tester] returns `true` to element, then it removes it.
  ///
  /// Added in `2.8`.
  void removeEach(bool Function(E) tester) {
    for (int index = 0; index < length;) {
      if (tester(this[index])) {
        removeAt(index);
      } else {
        index++;
      }
    }
  }

  /// Swaps elements at [a] & [b].
  ///
  /// Returns element at [a] == element at [b].
  ///
  /// Added in `2.8`.
  bool swap(int a, int b, {bool Function(E, E)? equal}) {
    equal ??= (a, b) => a == b;
    E element = this[a];
    this[a] = this[b];
    this[b] = element;
    return equal(element, this[a]);
  }

  /// Overwrites each element from
  /// [start] (inclusive) to [end] (exclusive), with [other].
  ///
  /// Returns the amount of times it has overwritten,
  /// which can either be [other]`.length`
  /// or [end] - [start].
  ///
  /// Added in `2.8`.
  int overwrite(List<E> other, [int start = 0, int? end]) {
    end ??= length;
    int index;
    index = 0;
    while (start < end && index < other.length) {
      this[start++] = other[index++];
    }
    return index;
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

  /// [SortAlg] comes packaged with this.
  ///
  /// Added in `2.8`.
  void sortWithThis(sort.SortAlg algorithm) =>
      sort.inlineSort(this, alg: algorithm);
}

extension ListNum on List<num> {
  /// Added in `2.8`.
  void roundEach() => changeEach(round);
}

extension ListString on List<String> {
  /// Added in `2.8`.
  Amount<String> toMapUpperCaseAmount() => {
    for (var current in this) current: current.upperCaseAmount,
  };

  /// Added in `2.8`.
  Amount<String> toMapLowerCaseAmount() => {
    for (var current in this) current: current.lowerCaseAmount,
  };
}

/// Added in `2.8`.
extension MapKV<K, V> on Map<K, V> {
  /// Added in `2.8`.
  bool equalsShallow(Map<K, V> other) => mapEqualsShallow(this, other);

  /// Added in `2.8`.
  bool equalsDeep(Map<K, V> other) => mapEqualsDeep(this, other);

  /// This might lose some entries.
  ///
  /// Added in `2.7.3`.
  Map<V, K> toReversed() => entries.reverseEntries().toMap();

  /// Added in `2.8`.
  Set<K> get keySet => keys.toSet();

  /// Added in `2.8`.
  MapEntry<K, V> get first => entries.first;

  /// Added in `2.8`.
  K get firstKey => first.key;

  /// Added in `2.8`.
  V get firstValue => first.value;

  /// Added in `2.8`.
  MapEntry<K, V> get last => entries.last;

  /// Added in `2.8`.
  K get lastKey => last.key;

  /// Added in `2.8`.
  V get lastValue => last.value;

  /// Added in `2.8`.
  MapEntry<K, V> get single => entries.single;

  /// Added in `2.8`.
  K get singleKey => single.key;

  /// Added in `2.8`.
  V get singleValue => single.value;

  /// Added in `2.8`.
  MapEntry<K, V>? get firstOrNull => entries.firstOrNull;

  /// Added in `2.8`.
  K? get firstKeyOrNull => firstOrNull?.key;

  /// Added in `2.8`.
  V? get firstValueOrNull => firstOrNull?.value;

  /// Added in `2.8`.
  MapEntry<K, V>? get lastOrNull => entries.lastOrNull;

  /// Added in `2.8`.
  K? get lastKeyOrNull => lastOrNull?.key;

  /// Added in `2.8`.
  V? get lastValueOrNull => lastOrNull?.value;

  /// Added in `2.8`.
  MapEntry<K, V>? get singleOrNull => entries.singleOrNull;

  /// Added in `2.8`.
  K? get singleKeyOrNull => singleOrNull?.key;

  /// Added in `2.8`.
  V? get singleValueOrNull => singleOrNull?.value;

  /// Added in `2.8`.
  ({MapEntry<K, V> first, MapEntry<K, V> last}) get posProperties {
    Iterable<MapEntry<K, V>> entries = this.entries;
    return (first: entries.first, last: entries.last);
  }

  /// Added in `2.8`.
  String join({String seperator = ", ", String connector = ": "}) {
    if (isEmpty) {
      return "";
    } else if (seperator == ", " && connector == ": ") {
      String string = toString();
      return string.substring(1, string.length - 1);
    }
    Iterable<MapEntry<K, V>> entries = this.entries;
    MapEntry<K, V> current = entries.first;
    String mule = "${current.key}$connector${current.value}";
    for (int index = 1; index < length; index++) {
      current = entries.elementAt(index);
      mule += "$seperator${current.key}$connector${current.value}";
    }
    return mule;
  }

  /// If [this] has only `1` element.
  ///
  /// Added in `2.8`.
  bool get isSingle => length == 1;

  /// Added in `2.8`.
  void addEntry(MapEntry<K, V> entry) => addEntries({entry});
}

extension SetE<E> on Set<E> {
  /// Added in `2.8`.
  bool equalsShallow(Set<E> other) => setEqualsShallow(this, other);

  /// Added in `2.8`.
  bool equalsDeep(Set<E> other) => setEqualsDeep(this, other);
}

extension IterableE<E> on Iterable<E> {
  /// Added in `2.8`.
  bool equalsShallow(Iterable<E> other) => iterableEqualsShallow(this, other);

  /// Added in `2.8`.
  bool equalsDeep(Iterable<E> other) => iterableEqualsDeep(this, other);

  /// Non-CaseSensitive search.
  ///
  /// Added in `2.8`.
  bool nonCaseSensitiveContains(Object? element) {
    if (element is! String) {
      return contains(element);
    } else {
      List<E> array = toList();
      array.changeEach((s) {
        if (s is String) {
          return s.toLowerCase() as E;
        } else {
          return s;
        }
      });
      return array.contains(element.toLowerCase());
    }
  }

  /// If [this] has only `1` element.
  ///
  /// Added in `2.8`.
  bool get isSingle => length == 1;
}

/// Added in `2.8`.
extension IterableN<N extends num> on Iterable<N> {
  /// Added in `2.8`.
  N get maxThis => max(this);

  /// Added in `2.8`.
  N get minThis => min(this);

  /// Added in `2.8`.
  N get sumThis => sum(this);

  ({N max, N sum, N min, N product}) get propertiesThis => properties(this);
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

/// Added in `2.7`.
extension BoolExt on bool {
  int toInt() => (this) ? 1 : 0;
}

/// Added in `2.7`.
extension StringExt on String {
  String truncate(int characters) => substring(0, characters);
  String safeTruncate(int characters) =>
      (characters >= length) ? substring(0, length - 1) : truncate(characters);
  String after(int start) => substring(start);
  String insert(String string, [int index = 0, bool leftToRight = true]) =>
      (leftToRight)
      ? "${truncate(index)}$string${after(index)}"
      : "${truncate(length - index)}$string${after(length - index)}";
  String overwrite(String string, [int index = 0, int? size]) {
    size ??= string.length;
    if (index + size >= length) {
      return "${truncate(index)}$string";
    } else {
      return "${truncate(index)}$string${after(index + size)}";
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
      if (mule[index].isUpperCaseChar) {
        mule = mule.insert(" ", index++);
      }
      ++index;
    }
    return mule;
  }

  @Deprecated("2.9 use isUpperCaseChar")
  bool get isUpperCase => isUpperCaseChar;
  @Deprecated("2.9 use isLowerCasedChar")
  bool get isLowerCase => isLowerCaseChar;

  /// Added in `2.8`.
  bool get isUpperCaseChar => length == 1 && isUpperCased;

  /// Added in `2.8`.
  bool get isLowerCaseChar => length == 1 && isLowerCased;

  /// Added in `2.8`.
  bool get isCaseInsensitiveChar => length == 1 && isUpperCased && isLowerCased;

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
  /// This function should not return any string with no contents ( `""` ).
  ///
  /// Added in `2.8`.
  Words toWords() {
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
    return mule;
  }

  /// Puts each line into a [List].
  ///
  /// Added in `2.8`.
  Words toLines() {
    List<String> mule = [];
    String char, builder;
    builder = "";
    for (int index = 0; index < length; index++) {
      char = this[index];
      if (char == "\n") {
        mule.add(builder);
        builder = "";
      } else {
        builder += char;
      }
    }
    mule.add(builder);
    return mule;
  }

  /// Amount of `uppercase` letters in [this] string.
  ///
  /// Added in `2.8`.
  int get upperCaseAmount {
    int index, mule;
    index = mule = 0;
    while (index < length) {
      if (this[index].isUpperCaseChar) {
        mule++;
      }
    }
    return mule;
  }

  /// Amount of `lowercase` letters in [this] string.
  ///
  /// Added in `2.8`.
  int get lowerCaseAmount {
    int index, mule;
    index = mule = 0;
    while (index < length) {
      if (this[index].isCaseInsensitiveChar) {
        mule++;
      }
    }
    return mule;
  }

  /// Tries to create a [String] like you would write it in `dart`.
  ///
  /// Examples:
  /// ```
  /// print(String.parse(r"\uFA56 enterprise")); // "節 enterprise"
  /// print(String.parse(r"\x44 => \r t")); // " t"
  /// print(String.parse(r"\x44 => \r t", containers: true));
  /// // ParseError (no containers)
  /// print(String.parse(r'"\t', containers: true));
  /// // ParseError (no ending container)
  /// print(String.parse(r'"\t' + r'\y"', containers: true)); // "	y"
  /// print(String.parse(r'"\t' + r'\y"')); // '"	y"'
  /// print(String.parse(r"\\")); // "\"
  /// print(String.parse(r'a""', containers: true));
  /// // ParseError (outside characters)
  /// print(String.parse(r'"' + r"'")); // ""'"
  /// print(String.parse(r"\u33")); // ParseError (\u not fulfilled)
  /// ```
  ///
  /// Added in `2.8.1`.
  static String parse(String input, {bool containers = false}) {}

  /// Tries to create a [String] like you would write it in `dart`.
  ///
  /// Examples:
  /// ```
  /// print(String.tryParse(r"\uFA56 enterprise")); // "節 enterprise"
  /// print(String.tryParse(r"\x44 => \r t")); // " t"
  /// print(String.tryParse(r"\x44 => \r t", containers: true)); // null
  /// print(String.tryParse(r'"\t', containers: true)); // null
  /// print(String.tryParse(r'"\t' + r'\y"', containers: true)); // "	y"
  /// print(String.tryParse(r'"\t' + r'\y"')); // '"	y"'
  /// print(String.tryParse(r"\\")); // "\"
  /// print(String.tryParse(r'a""', containers: true)); // null
  /// print(String.tryParse(r'"' + r"'")); // ""'"
  /// print(String.tryParse(r"\u33")); // null
  /// ```
  ///
  /// Added in `2.8.1`.
  static String? tryParse(String input, {bool containers = false}) {
    StringBuffer buffer = StringBuffer();
    bool escaped, contained;
    bool? isApos = null;
    escaped = contained = false;
    String char;
    for (int index = 0; index < input.length; index++) {
      char = input[index];
      if (containers && !contained) {
        if (char == r"'") {
          contained = true;
          isApos = true;
        } else if (char == r'"') {
          contained = true;
          isApos = true;
        } else {
          return null;
        }
      }
      if (escaped) {
        switch (char) {
          case "u":
            if (index + 5 >= input.length) {
              return null;
            } else {
              int? parsed = int.tryParse(
                input.substring(index + 1, index + 5),
                radix: 16,
              );
              if (parsed == null) {
                return null;
              } else {
                buffer.write(String.fromCharCode(parsed));
                index += 4;
              }
            }
          case "x":
            if (index + 5 >= input.length) {
              return null;
            } else {
              int? parsed = int.tryParse(
                input.substring(index + 1, index + 3),
                radix: 16,
              );
              if (parsed == null) {
                return null;
              } else {
                buffer.write(String.fromCharCode(parsed));
                index += 4;
              }
            }
          case _:
            buffer.write(char);
        }
        escaped = false;
      } else {
        switch (char) {
          case r"\":
            escaped = true;
          case r"'":
            if (!containers) {
              buffer.write(char);
            } else if (!contained) {
              return null;
            }
            if (contained && isApos!) {}
        }
      }
    }
    return buffer.toString();
  }

  /// Tries to create a [String] like you would write it in `dart`.
  ///
  /// Examples:
  /// ```
  /// print(String.tryParse(r"\uFA56 enterprise")); // "節 enterprise"
  /// print(String.tryParse(r"\x44 => \r t")); // " t"
  /// print(String.tryParse(r"\x44 => \r t", containers: true)); // null
  /// print(String.tryParse(r'"\t', containers: true)); // null
  /// print(String.tryParse(r'"\t' + r'\y"', containers: true)); // "	y"
  /// print(String.tryParse(r'"\t' + r'\y"')); // '"	y"'
  /// print(String.tryParse(r"\\")); // "\"
  /// print(String.tryParse(r'a""', containers: true)); // null
  /// print(String.tryParse(r'"' + r"'")); // ""'"
  /// print(String.tryParse(r"\u33")); // null
  /// ```
  ///
  /// Added in `2.8.1`.
  static String? tryParse(String input, {bool containers = false}) {
    if (containers) {
      String a = input.firstChar;
      if (input.lastChar != a) {
        return null;
      }
      bool escaped = false;
      for (int index = 1; index < input.length - 2; ++index) {
        if (escaped && input[index] == a) {
          return null;
        } else if (!escaped && input[index] == r"\") {
          escaped = true;
        } else if (!escaped) {
          escaped = false;
        }
      }
      tryParse(input.substring(1, input.length - 1), containers: false);
    } else {
      StringBuffer buffer = StringBuffer();
      bool escaped = false;
      String char;
      for (int index = 0; index < input.length; index++) {
        char = input[index];
        if (!escaped) {
          if (char == r"\") {
            escaped = true;
          } else {
            buffer.write(char);
          }
        } else {
          switch (char) {
            case r"u":
              if (index + 5 >= input.length) {
                return null;
              } else {
                int? parsed = int.tryParse(
                  input.substring(index + 1, index + 5),
                  radix: 16,
                );
                if (parsed == null) {
                  return null;
                } else {
                  buffer.write(String.fromCharCode(parsed));
                  index += 4;
                  // for loop will increment it like it would be a += 5
                }
              }
            case r"x":
              if (index + 3 >= input.length) {
                return null;
              } else {
                int? parsed = int.tryParse(
                  input.substring(index + 1, index + 3),
                  radix: 16,
                );
                if (parsed == null) {
                  return null;
                } else {
                  buffer.write(String.fromCharCode(parsed));
                  index += 2;
                  // for loop will increment it like it would be a += 3
                }
              }
            case _:
              buffer.write(char);
          }
        }
      }
      return buffer.toString();
    }
  }

  /// Added in `2.8.1`.
  String get firstChar => this[0];

  /// Added in `2.8.1`.
  String get lastChar => this[length - 1];

  // TODO: fix me
  /*
  /// Added in `2.8.1`.
  Never containsAll(Iterable<Pattern> patterns) => throw bool;

  /// Added in `2.8.1`.
  Never containsOne(Iterable<Pattern> patterns) => throw bool;
   */
}
