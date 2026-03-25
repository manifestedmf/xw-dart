import 'dart:math' as math;
import '../extension.dart' show MapKV, NumExt, StringExt, IntExt;

final ArgumentError _ifNoneError = ArgumentError(
  "No optional parameter set",
  "ifNone",
);

/// The |absolute| value of [signed].
///
/// ```
/// print(abs(-15)); // 15
/// print(abs(12)); // 12
/// print(abs(17262)); // 17262
/// ```
///
/// Added in `2.7`.
N abs<N extends num>(N signed) => (signed < 0) ? -signed as N : signed;

/// The Representation for each digit, so for example `'0'` is `0` and
/// `'A'` is `10`.
///
/// Added in `2.7.2`.
const Map<String, int> baseDigitToNumRepr = {
  "0": 0,
  "1": 1,
  "2": 2,
  "3": 3,
  "4": 4,
  "5": 5,
  "6": 6,
  "7": 7,
  "8": 8,
  "9": 9,
  "A": 10,
  "B": 11,
  "C": 12,
  "D": 13,
  "E": 14,
  "F": 15,
  "G": 16,
  "H": 17,
  "I": 18,
  "J": 19,
  "K": 20,
  "L": 21,
  "M": 22,
  "N": 23,
  "O": 24,
  "P": 25,
  "Q": 26,
  "R": 27,
  "S": 28,
  "T": 29,
  "U": 30,
  "V": 31,
  "W": 32,
  "X": 33,
  "Y": 34,
  "Z": 35,
  "a": 36,
  "b": 37,
  "c": 38,
  "d": 39,
  "e": 40,
  "f": 41,
  "g": 42,
  "h": 43,
  "i": 44,
  "j": 45,
  "k": 46,
  "l": 47,
  "m": 48,
  "n": 49,
  "o": 50,
  "p": 51,
  "q": 52,
  "r": 53,
  "s": 54,
  "t": 55,
  "u": 56,
  "v": 57,
  "w": 58,
  "x": 59,
  "y": 60,
  "z": 61,
  "!": 62,
  "?": 63,
  "<": 64,
  ">": 65,
};

/// The Representation for each number, so for example `0` is `'0'` and `10`
/// is `'A'`
///
/// Added in `2.7.2`.
final Map<int, String> baseNumToDigitRepr = baseDigitToNumRepr.toReversed();

/// The standard representation for Minus.
///
/// Added in `2.7.2`.
const String minusRepr = "-";

/// Returns a [int] that the [base] is in from the [string]
///
/// ```
/// print(strToBase("34", 11)); // 37
/// print(strToBase("55", 5)); // CRASH
/// print(strToBase("332", 16)); // 818
/// ```
///
/// Note: `strToBase(baseToStr(a, b), b);` should give `a` back. Unless `b` is a
/// base that doesn't encapsulate all `repr`.
///
/// Added in `2.7.2`.
int strToBase(
  String string,
  int base, {
  Map<String, int>? repr,
  String minus = minusRepr,
}) {
  repr ??= baseDigitToNumRepr;
  if (base > repr.length) {
    throw "$base can't be longer than the length of repr, which is "
        "${repr.length}";
  }
  String digit;
  int value;
  int mule = 0;
  int index = string.length - 1;
  int j = 0;
  do {
    digit = string[index--];
    value =
        baseDigitToNumRepr[digit] ?? (throw "Expected $digit to be in $repr");
    if (value >= base) {
      throw "'$digit': $value can't be a higher than ${base - 1}, happened on "
          "string[${index + 1}].";
    }
    mule += pow(base, j++) * value;
  } while (index > 0); // Doesn't do last part
  digit = string[index--];
  if (digit == minusRepr) {
    mule = -mule;
  } else {
    value =
        baseDigitToNumRepr[digit] ?? (throw "Expected $digit to be in $repr");
    if (value >= base) {
      throw "'$digit': $value can't be a higher than ${base - 1}, happened on "
          "string[0].";
    }
    mule += pow(base, j++) * value;
  }
  return mule;
}

/// Returns a [String] in the [base] form of the [input].
///
/// Example:
/// ```
/// print(baseToStr(25, 32)); // 'P'
/// print(baseToStr(298, 11)); // '251'
/// print(baseToStr(77, 5)); // '302'
/// ```
///
/// Note: `baseToStr(strToBase(a, b), b);` should give `a` back.
/// Unless `a` is not a valid base input for `b` or if `b` is a base that
/// doesn't encapsulate all `repr`.
///
/// Added in `2.7.2`.
String baseToStr(
  int input,
  int base, {
  Map<int, String>? repr,
  String minus = minusRepr,
}) {
  repr ??= baseNumToDigitRepr;
  String mule = "";
  bool sign = input.isSigned;
  int value;
  String digit;
  do {
    value = input % base;
    digit = repr[value] ?? (throw "Expected $value to be listed in $repr");
    mule += digit;
  } while ((input ~/= base) > 0);
  if (sign) {
    mule += minusRepr;
  }
  return mule.toReversed();
}

/// Gives back a [String] in the base: [baseTo],
/// from [from] in base: [baseFrom].
///
/// Added in `2.7.2`.
String baseToBase({
  required String from,
  required int baseFrom,
  required int baseTo,
}) => baseToStr(strToBase(from, baseFrom), baseTo);

/// Gets the max value in [numbers].
///
/// If there are no values in [numbers], then it returns [ifNone].
///
/// If [ifNone] is a null while there are no values in [numbers],
/// then it throws a [ArgumentError].
///
/// ```
/// print(max([0, 15, 23, 29, 11, -6])); // 29
/// print(max([], -5)); // -5
/// print(max([])); // CRASH
/// print(max([3.2, 5.22, 69.03], -5.3)); // 69.03
/// print(max<num>([5, 6.2, 9, double.pi])); // 9
/// ```
///
/// Added in `2.7`.
N max<N extends num>(Iterable<N> numbers, [N? ifNone]) {
  if (numbers.isEmpty) {
    return ifNone ?? (throw _ifNoneError);
  }
  N max = numbers.first;
  for (N current in numbers) {
    if (current > max) {
      max = current;
    }
  }
  return max;
}

/// The [max]es in [elements].
/// Uses [greaterThan] to know if it needs to swap the current max.
/// Uses [equalValue] to know if it has the same value (but not fully equal).
///
/// If [ifNone] is a null while there are no values in [elements],
/// then it throws a [ArgumentError].
///
/// Added in `2.8`.
Set<E> maxAny<E>(
  Iterable<E> elements, {
  required bool Function(E, E) greaterThan,
  bool Function(E, E)? equalValue,
  Set<E>? ifNone,
}) {
  if (elements.isEmpty) {
    return ifNone ?? (throw _ifNoneError);
  }
  equalValue ??= (a, b) => a == b;
  Set<E> max = {};
  E maxVal = elements.first;
  for (E current in elements) {
    if (greaterThan(current, maxVal)) {
      max = {current};
      maxVal = current;
    } else if (equalValue(current, maxVal)) {
      max.add(current);
    }
  }
  return max;
}

/// Gives the maximum of Two values, being [a] & [b].
///
/// ```
/// print(maxSimple(5, 9)); // 9
/// print(maxSimple(5.2, 9.0)); // 9.0
/// print(maxSimple<num>(5.2, 9)); // 9
/// ```
///
/// Added in `2.7.3`.
N maxSimple<N extends num>(N a, N b) => math.max(a, b);

/// Gives the [MapEntry] with the highest key([K]) value.
///
/// If [ifNone] is a null while there are no values in [map],
/// then it throws a [ArgumentError].
///
///
/// Added in `2.7`.
MapEntry<K, V> maxMapKey<K extends num, V>(
  Map<K, V> map, [
  MapEntry<K, V>? ifNone,
]) {
  if (map.isEmpty) {
    return ifNone ?? (throw StateError("No Optional Parameter Set"));
  }
  Iterable<MapEntry<K, V>> entries = map.entries;
  MapEntry<K, V> max = entries.first;
  for (MapEntry<K, V> current in entries) {
    if (current.key > max.key) {
      max = current;
    }
  }
  return max;
}

/// Gives a [Map] with the only the highest value([V]).
///
/// If [ifNone] is a null while there are no values in [map],
/// then it throws a [ArgumentError].
///
/// Added in `2.7`.
Map<K, V> maxMapValue<K, V extends num>(Map<K, V> map, [Map<K, V>? ifNone]) {
  if (map.isEmpty) {
    return ifNone ?? (throw StateError("No Optional Parameter Set"));
  }
  Iterable<MapEntry<K, V>> entries = map.entries;
  Map<K, V> maxSet = {entries.first.key: entries.first.value};
  V max = entries.first.value;
  for (MapEntry<K, V> current in entries) {
    if (current.value > max) {
      maxSet = {current.key: current.value};
      max = current.value;
    } else if (current.value == max) {
      maxSet.addEntry(current);
    }
  }
  return maxSet;
}

/// Gets the min value in [numbers].
///
/// If there are no values in [numbers], then it returns [ifNone].
///
/// Added in `2.7`.
N min<N extends num>(Iterable<N> numbers, [N? ifNone]) {
  if (numbers.isEmpty) {
    return ifNone ?? (throw StateError("No Optional Parameter Set"));
  }
  N min = numbers.first;
  for (N current in numbers) {
    if (current < min) {
      min = current;
    }
  }
  return min;
}

/// The [min]s in [elements].
/// Uses [lessThan] to know if it needs to swap the current min.
/// Uses [equalValue] to know if it has the same value (but not fully equal).
///
/// Added in `2.8`.
Set<E> minAny<E>(
  Iterable<E> elements, {
  required bool Function(E, E) lessThan,
  bool Function(E, E)? equalValue,
  Set<E>? ifNone,
}) {
  if (elements.isEmpty) {
    return ifNone ?? (throw StateError("No Optional Parameter Set"));
  }
  equalValue ??= (a, b) => a == b;
  Set<E> min = {};
  E minVal = elements.first;
  for (E current in elements) {
    if (lessThan(current, minVal)) {
      min = {current};
      minVal = current;
    } else if (equalValue(current, minVal)) {
      min.add(current);
    }
  }
  return min;
}

/// Gets the minimum of Two values, [a] & [b].
///
/// Added in `2.7.3`.
N minSimple<N extends num>(N a, N b) => math.min(a, b);

/// Added in `2.7`.
MapEntry<K, V> minMapKey<K extends num, V>(
  Map<K, V> map, [
  MapEntry<K, V>? ifNone,
]) {
  if (map.isEmpty) {
    return ifNone ?? (throw StateError("No Optional Parameter Set"));
  }
  Iterable<MapEntry<K, V>> entries = map.entries;
  MapEntry<K, V> min = entries.first;
  for (MapEntry<K, V> current in entries) {
    if (current.key < min.key) {
      min = current;
    }
  }
  return min;
}

/// Added in `2.7`.
Set<MapEntry<K, V>> minMapValue<K, V extends num>(
  Map<K, V> map, [
  Set<MapEntry<K, V>>? ifNone,
]) {
  if (map.isEmpty) {
    return ifNone ?? (throw StateError("No Optional Parameter Set"));
  }
  Iterable<MapEntry<K, V>> entries = map.entries;
  Set<MapEntry<K, V>> minSet = {entries.first};
  V min = entries.first.value;
  for (MapEntry<K, V> current in entries) {
    if (current.value < min) {
      minSet = {current};
      min = current.value;
    } else if (current.value == min) {
      minSet.add(current);
    }
  }
  return minSet;
}

/// Gets the sum of [numbers], The starting value is [starting].
///
/// Added in `2.7`.
N sum<N extends num>(Iterable<N> numbers, [N? starting]) {
  N sum;
  sum = (starting == null)
      ? ((numbers is Iterable<int>) ? 0 : 0.0) as N
      : starting;
  for (N current in numbers) {
    sum = sum + current as N;
  }
  return sum;
}

/// Added in `2.8`.
E sumAny<E>(Iterable<E> elements, E Function(E, E) plus, E starting) {
  E mule = starting;
  for (E current in elements) {
    mule = plus(mule, current);
  }
  return mule;
}

/// Added in `2.7`.
K sumMapKey<K extends num, V>(Map<K, V> map, [K? starting]) {
  K sum;
  sum = (starting == null) ? 0 as K : starting;
  Iterable<MapEntry<K, V>> entries = map.entries;
  for (MapEntry<K, V> current in entries) {
    sum = sum + current.key as K;
  }
  return sum;
}

/// Added in `2.7`.
V sumMapValue<K, V extends num>(Map<K, V> map, [V? starting]) {
  V sum;
  sum = (starting == null) ? 0 as V : starting;
  Iterable<MapEntry<K, V>> entries = map.entries;
  for (MapEntry<K, V> current in entries) {
    sum = sum + current.value as V;
  }
  return sum;
}

/// Added in `2.8`.
N product<N extends num>(Iterable<N> numbers, [N? starting]) {
  N product;
  product = (starting == null)
      ? ((numbers is Iterable<int>) ? 0 : 0.0) as N
      : starting;
  for (N current in numbers) {
    product = product * current as N;
  }
  return product;
}

/// The [max], [min] and [sum] of a [Iterable].
///
/// Added in `2.8`.
({N max, N min, N sum, N product}) properties<N extends num>(
  Iterable<N> numbers, {
  N? startingSum,
  N? startingProduct,
  N? ifNoneMax,
  N? ifNoneMin,
}) {
  startingSum ??= (numbers is Iterable<double>) ? 0.0 as N : 0 as N;
  startingProduct ??= (numbers is Iterable<double>) ? 0.0 as N : 0 as N;
  if (numbers.isEmpty) {
    if (ifNoneMax == null || ifNoneMin == null) {
      throw throw _ifNoneError;
    } else {
      return (
        max: ifNoneMax,
        min: ifNoneMin,
        sum: startingSum,
        product: startingProduct,
      );
    }
  }
  N sum = startingSum;
  N product = startingProduct;
  N max = numbers.first;
  N min = numbers.first;
  for (N current in numbers) {
    sum = sum + current as N;
    product = product * current as N;
    if (current > max) {
      max = current;
    } else if (current < min) {
      min = current;
    }
  }
  return (max: max, min: min, sum: sum, product: product);
}

/// The [max], [min] and [sum] of a [Iterable].
///
/// [equality] should give out:
/// [false] if a < b,
/// [null] if a == b and
/// [true] if a > b.
///
/// [plus] is used with `plus(sum, current)`.
/// This should mean if there is a positional difference between
/// `sum + current` and `current + sum`, then it should be handled
/// by the user.
///
/// Added in `2.8`.
({Set<E> max, Set<E> min, E sum, E product}) propertiesAny<E>(
  Iterable<E> elements, {
  required E startingSum,
  required E startingProduct,
  Set<E>? ifNoneMax,
  Set<E>? ifNoneMin,
  required bool? Function(E, E) equality,
  required E Function(E, E) plus,
  required E Function(E, E) times,
}) {
  if (elements.isEmpty) {
    if (ifNoneMax == null || ifNoneMin == null) {
      throw throw StateError("No Optional Parameter Set");
    } else {
      return (
        max: ifNoneMax,
        min: ifNoneMin,
        sum: startingSum,
        product: startingProduct,
      );
    }
  }
  E sum = startingSum;
  E product = startingProduct;
  Set<E> max = {};
  E maxVal = elements.first;
  Set<E> min = {};
  E minVal = elements.first;
  for (E current in elements) {
    sum = plus(sum, current);
    product = plus(product, current);
    switch (equality(maxVal, current)) {
      case null:
        max.add(current);
      case true:
        max = {current};
        maxVal = current;
      case false:
        break;
    }
    switch (equality(minVal, current)) {
      case null:
        min.add(current);
      case true:
        break;
      case false:
        min = {current};
        minVal = current;
    }
  }
  return (max: max, min: min, sum: sum, product: product);
}

/// The [base] to [exponent].
///
/// Added in `2.7`.
N pow<N extends num>(N base, N exponent) {
  if (N != num && base is int && exponent is int && exponent < 0) {
    throw ArgumentError.value(exponent, "exponent", "Negative exponent");
  }
  return math.pow(base, exponent) as N;
}

// RT stands for Return Type.
/// Added in `2.8`.
RT powAny<RT>(
  RT base,
  RT exponent, {
  required RT Function(RT, RT) times,
  required RT Function(RT) minusOne,
  required bool Function(RT) equalToZero,
}) {
  RT mule = base;
  while (!equalToZero(exponent)) {
    mule = times(mule, base);
    exponent = minusOne(exponent);
  }
  return mule;
}

/// Added in `2.8`.
N square<N extends num>(N base) => base * base as N;

/// Added in `2.8`.
RT squareAny<RT>(RT base, {required RT Function(RT, RT) times}) =>
    times(base, base);

/// Added in `2.8`.
N round<N extends num>(N number) =>
    (N == double) ? number.roundToDouble() as N : number;

/// If [number] is a [pow]`(int, 2)`, then it returns a [int],
/// else it returns a [double].
///
/// Added in `2.7`.
num sqrt(num number) {
  double value = math.sqrt(number);
  return (value.isWhole) ? value.toInt() : value;
}

/// Added in `2.8`.
N binarySearch<N extends num>(Iterable<N> numbers, N value) {
  int minIndex, maxIndex, index, prevIndex;
  N number;
  minIndex = 0;
  maxIndex = numbers.length - 1;
  index = maxIndex >> 1;
  prevIndex = -1;
  while (index != prevIndex) {
    number = numbers.elementAt(index);
    if (number == value) {
      return number;
    } else if (number > value) {
      maxIndex = index;
      prevIndex = index;
      index = (minIndex + maxIndex) >> 1;
    } else {
      minIndex = index;
      prevIndex = index;
      index = (minIndex + maxIndex) >> 1;
    }
  }
  return (value is int) ? -1 as N : -1.0 as N;
}

/// Gives back [pow]`(`[base]`, 1/`[root]`)`.
///
/// Added in `2.8`.
num root<N extends num>(N base, N root) => pow(base, 1 / root);

/// Returns [pow]`(`[base]`, `[double.e]`)`.
///
/// Added in `2.8`.
double exp(num base) => math.exp(base);

/// Gives back the natural logarithm of [x].
///
/// Added in `2.8`.
double ln(num x) => math.log(x);

/// The [sin]e function.
///
/// Added in `2.8`.
double sin(num radians) => math.sin(radians);

/// The [cos]`in`e function.
///
/// Added in `2.8`.
double cos(num radians) => math.cos(radians);

/// The [tan]gent function.
///
/// Added in `2.8`.
double tan(num radians) => math.tan(radians);

/// The arc [sin]e function.
///
/// Added in `2.8`.
double asin(num x) => math.asin(x);

/// The arc [cos]`in`e function.
///
/// Added in `2.8`.
double acos(num x) => math.acos(x);

/// The arc [tan]gent function.
///
/// Added in `2.8`.
double atan(num x) => math.atan(x);

/// View `dart:math` library to see more about this function.
///
/// Added in `2.8`.
double atan2(num a, num b) => math.atan2(a, b);

/// Added in `2.7`.
bool isLow(num number) => (number % 1 < 0.5);

/// Added in `2.7`.
bool isHigh(num number) => !isLow(number);

/// Added in `2.7`.
bool isDivBy(int oper, int div) => oper % div == 0;

/// Added in `2.8`.
bool isDivBy2(int oper) => oper & 1 == 0;

/// Explicit that the first is 1.
///
/// Added in `2.7`.
List<int> primeFactors(int number) {
  List<int> list = [];
  int div = 2;
  if (number < 0) {
    list.add(-1);
    number *= -1;
  }
  int highestDiv = sqrt(number).toInt();
  while (div <= highestDiv) {
    if (isDivBy(number, div)) {
      list.add(div);
      number ~/= div;
      highestDiv = sqrt(number).toInt();
      div = 2;
    } else {
      div++;
    }
  }
  if (number != 1) {
    list.add(number);
  }
  return list;
}

/// Greatest Common Denominator.
///
/// Added in `2.7.3`.
({int a, int b}) gcd(int a, int b) {
  if (b == 1 || a == 1 || a == b - 1 || a == b + 1) {
    return (a: a, b: b);
  }
  List<int> aFactors = primeFactors(a);
  List<int> bFactors = primeFactors(b);
  while (aFactors[0] == bFactors[0]) {
    aFactors.removeAt(0);
    bFactors.removeAt(0);
  }
  int currentA, currentB;
  int bIndex, aIndex;
  bIndex = aIndex = 0;
  while (bIndex < bFactors.length && aIndex < aFactors.length) {
    currentA = aFactors[aIndex];
    currentB = bFactors[bIndex];
    if (currentA == currentB) {
      aFactors.removeAt(aIndex);
      bFactors.removeAt(bIndex);
    } else if (currentB < currentA) {
      ++aIndex;
    } else if (currentA < currentB) {
      ++bIndex;
    }
  }
  return (a: product(aFactors), b: product(bFactors));
}

/// If [number] is prime.
///
/// Added in `2.7`.
bool isPrime(final int number) {
  if (number & 1 == 0) {
    return false;
  }
  if (number.isNegative) {
    return false;
  }
  int div = 3;
  final int highestDiv = sqrt(number).toInt();
  while (div <= highestDiv) {
    if (div & 1 == 0) {
      div++;
    }
    if (isDivBy(number, div)) {
      return false;
    } else {
      div++;
    }
  }
  return true;
}

/// If number is constructed of primes
///
/// Added in `2.7`.
bool isComprime(List<int> factors) {
  if (factors.length <= 1) {
    return false;
  } else if (factors[0] != factors[1] && factors.length == 2) {
    return true;
  } else {
    return false;
  }
}

/// 64, 2 // true
///
/// 63, 3 // false
///
/// Added in `2.7`.
bool isExponentOf(int number, int base) => isMadeUpOf(number, [base]);

/// Added in `2.7`.
bool isMadeUpOf(int number, List<int> primes) {
  List<int> list = primeFactors(number);
  int index = 0;
  while (index < list.length) {
    if (primes.contains(list[index])) {
      list.removeAt(index);
      index = index.towardsZero;
    } else {
      return false;
    }
  }
  return true;
}

/// Added in `2.8`.
class MathError {
  final String? message;

  const MathError([this.message]);
}

/// Gives the factorial of an unsigned int being, [number].
///
/// Throws a [RangeError] if [number] is less than 0.
///
/// Added in `2.8`.
int factorial(int number) {
  if (number.isSigned) {
    throw RangeError.range(
      number,
      0,
      null,
      "number",
      "function doesn't support signed factorials",
    );
  } else if (number == 0) {
    return 1;
  } else {
    return factorial(number - 1) * number;
  }
}

/// Gives the termial (addition from 0 to [number]).
///
/// Added in `2.8`.
N termial<N extends num>(N number) {
  double mule = (number * number + number) / 2;
  return (number is int) ? mule.toInt() as N : mule as N;
}

/*
/// Gives the corresponding number of the unknown number input.
///
/// Added in `2.8`.
*/
/// The Σ used in math.
///
/// Uses [f] (x),
/// where x starts at [start] (inclusive),
/// and ends at [end] (inclusive).
///
/// Throws [RangeError],
/// if [start] is greater than [end].
///
/// Added in `2.8`.
N sigmaFunc<N extends num>(
  N Function(int) f, {
  int start = 0,
  required int end,
}) {
  if (start > end) {
    throw RangeError.range(end, start, null, "end");
  }
  N sum = f(start);
  for (int i = start + 1; i <= end; i++) {
    sum = sum + f(i) as N;
  }
  return sum;
}

/// The Π used in math.
///
/// Uses [f] (x),
/// where x starts at [start] (inclusive),
/// and ends at [end] (inclusive).
///
/// Throws [RangeError],
/// if [start] is greater than [end].
///
/// Added in `2.8`.
N piFunc<N extends num>(N Function(int) f, {int start = 0, required int end}) {
  if (start > end) {
    throw RangeError.range(end, start, null, "end");
  }
  N product = f(start);
  for (int i = start + 1; i <= end; i++) {
    product = product * f(i) as N;
  }
  return product;
}

/// Added in `2.8`.
int fibonacci(int number) {
  if (number <= 0) {
    return 0;
  } else if (number == 1) {
    return 1;
  } else {
    return fibonacci(number - 2) + fibonacci(number - 1);
  }
}

/// Gets all [fibonacci] numbers up to [number].
///
/// Doing
/// ```
/// List<int> fibonaccis = fibonacciList(n);
/// int fibonacciIndex = fibonaccis[index];
/// ```
/// Will yield `fibonacciIndex` to be [fibonacci]`(`[index]`)`.
///
/// Added in `2.8`.
List<int> fibonacciList(int number) {
  if (number < 0) {
    return [];
  } else if (number == 0) {
    return [0];
  } else {
    List<int> fibonaccis = [0, 1];
    int index = 2;
    for (; fibonaccis.length <= number; index++) {
      fibonaccis.add(fibonaccis[index - 2] + fibonaccis[index - 1]);
    }
    return fibonaccis;
  }
}

/// Added in `2.8`.
enum Operator {
  /// Added in `2.8`.
  plus(char: "+"),

  /// Added in `2.8`.
  minus(char: "-"),

  /// Added in `2.8`.
  times(char: "*"),

  /// Added in `2.8`.
  divide(char: "/");

  /// Added in `2.8`.
  final String char;
  const Operator({required this.char});

  /// Throws a [ArgumentError] if [char] is not a valid [Operator].
  ///
  /// Added in `2.8`.
  static Operator fromChar(String char) {
    for (Operator current in values) {
      if (current.char == char) {
        return current;
      }
    }
    throw ArgumentError.value(char, "char", "Needs to be a operator");
  }
}
/*
/// Added in `2.8.1`.
num reversePolishCalculator(String input) {
  int index = 0;
  num left, right;
  void parseNext() {}
  parseNext();

  return 2;
}
 */

/// Added in `2.8`.
extension DoubleMathExt on double {
  /// Closest [double] representation of [pi].
  ///
  /// Added in `2.8`.
  static const pi = math.pi;

  /// Closest [double] representation of [e].
  ///
  /// Added in `2.8`.
  static const e = math.e;

  /// Closest [double] representation of `natural logarithm of `[10].
  ///
  /// Added in `2.8`.
  static const ln10 = math.ln10;

  /// Closest [double] representation of `natural logarithm of `[2].
  ///
  /// Added in `2.8`.
  static const ln2 = math.ln2;

  /// Closest [double] representation of `base 2 logarithm of `[e].
  ///
  /// Added in `2.8`.
  static const log2e = math.log2e;

  /// Closest [double] representation of `base 10 logarithm of `[e].
  ///
  /// Added in `2.8`.
  static const log10e = math.log10e;

  /// Closest [double] representation of `sqrt of 1/2`.
  ///
  /// Added in `2.8`.
  static const sqrtHalf = math.sqrt1_2;

  /// Closest [double] representation of `sqrt of 2`.
  ///
  /// Added in `2.8`.
  static const sqrt2 = math.sqrt2;
}
