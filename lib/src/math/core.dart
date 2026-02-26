import 'dart:math' as math;
import '../extension.dart';

/// The |absolute| value of [signed].
///
/// ```
/// print(abs(-15)); // 15
/// print(abs(12)); // 12
/// print(abs(17262)); // 17262
/// ```
///
/// Added in `2.7.0`.
int abs(int signed) => (signed < 0) ? -signed : signed;

/// The Representation for each digit, so for example `'0'` is `0` and
/// `'A'` is `10`.
///
/// Added in `2.7.2`.
const Map<String,int> baseDigitToNumRepr = {
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
int strToBase(String string, int base,
    {Map<String, int>? repr,
    String minus = minusRepr,}) {
  repr ??= baseDigitToNumRepr;
  if (base > repr.length) {
    throw "$base can't be longer than the length of repr, which is "
      "${repr.length}";
  }
  String digit; int value;
  int mule = 0; int index = string.length-1; int j = 0;
  do {
    digit = string[index--];
    value = baseDigitToNumRepr[digit] ?? (throw "Expected $digit to be in $repr");
    if (value >= base) {
      throw "'$digit': $value can't be a higher than ${base-1}, happened on "
        "string[${index+1}].";
    }
    mule += pow(base, j++) * value;
  } while (index > 0); // Doesn't do last part
  digit = string[index--];
  if (digit == minusRepr) {
    mule = -mule;
  } else {
    value = baseDigitToNumRepr[digit] ?? (throw "Expected $digit to be in $repr");
    if (value >= base) {
      throw "'$digit': $value can't be a higher than ${base-1}, happened on "
        "string[0].";
    }
    mule += pow(base,j++) * value;
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
String baseToStr(int input, int base,
    {Map<int, String>? repr,
    String minus = minusRepr,}) {
  repr ??= baseNumToDigitRepr;
  String mule = ""; bool sign = input.isSigned;
  int value; String digit;
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
/// ```
/// print(max([0, 15, 23, 29, 11, -6])); // 29
/// print(max([], -5)); // -5
/// print(max([])); // CRASH
/// print(max([3.2, 5.22, 69.03], -5.3)); // 69.03
/// print(max<num>([5, 6.2, 9, pi])); // 9
/// ```
///
/// Added in `2.7.0`.
N max<N extends num>(Iterable<N> numbers, [N? ifNone]) {
  if (numbers.isEmpty) {
    return ifNone ?? (throw StateError("No Optional Parameter Set"));
  }
  N max = numbers.first;
  for (N current in numbers) {
    if (current > max) {
      max = current;
    }
  }
  return max;
}

/// Gives the max of Two values, being [a] & [b].
///
/// ```
/// print(maxSimple(5, 9)); // 9
/// print(maxSimple(5.2, 9.0)); // 9.0
/// print(maxSimple<num>(5.2, 9)); // 9
/// ```
///
/// Added in `2.7.3`.
N maxSimple<N extends num>(N a, N b) => (a > b) ? a : b;

/// Gives the [MapEntry] with the highest key([K]) value.
///
/// Added in `2.7.0`.
MapEntry<K,V> maxMapKey<K extends num, V>(Map<K, V> map, [MapEntry<K, V>? ifNone]) {
  if (map.isEmpty) {
    return ifNone ?? (throw StateError("No Optional Parameter Set"));
  }
  Iterable<MapEntry<K,V>> entries = map.entries;
  MapEntry<K,V> max = entries.first;
  for (MapEntry<K,V> current in entries) {
    if (current.key > max.key) {
      max = current;
    }
  }
  return max;
}

/// Gives the [MapEntry]s with the highest value([V]) value.
///
/// Added in `2.7.0`.
Set<MapEntry<K,V>> maxMapValue<K, V extends num>(Map<K, V> map, [MapEntry<K, V>? ifNone]) {
  if (map.isEmpty) {
    if (ifNone == null) {throw StateError("No Optional Parameter Set");}
    return {ifNone};
  }
  Iterable<MapEntry<K,V>> entries = map.entries;
  Set<MapEntry<K,V>> maxSet = {entries.first};
  V max = entries.first.value;
  for (MapEntry<K,V> current in entries) {
    if (current.value > max) {
      maxSet = {current};
      max = current.value;
    }
    else if (current.value == max) {maxSet.add(current);}
  }
  return maxSet;
}

/// Gets the min value in [numbers].
///
/// If there are no values in [numbers], then it returns [ifNone].
///
/// Added in `2.7.0`.
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

/// Gets the min of Two values, [a] & [b].
///
/// Added in `2.7.3`.
N minSimple<N extends num>(N a, N b) => (a < b) ? a : b;

/// Added in `2.7.0`.
MapEntry<K,V> minMapKey<K extends num, V>(Map<K,V> map, [MapEntry<K,V>? ifNone]) {
  if (map.isEmpty) {
    return ifNone ?? (throw StateError("No Optional Parameter Set"));
  }
  Iterable<MapEntry<K,V>> entries = map.entries;
  MapEntry<K,V> min = entries.first;
  for (MapEntry<K,V> current in entries) {
    if (current.key < min.key) {min = current;}
  }
  return min;
}

/// Added in `2.7.0`.
Set<MapEntry<K,V>> minMapValue<K,V extends num>(Map<K,V> map, [MapEntry<K,V>? ifNone]) {
  if (map.isEmpty) {
    if (ifNone == null) {throw StateError("No Optional Parameter Set");}
    return {ifNone};
  }
  Iterable<MapEntry<K,V>> entries = map.entries;
  Set<MapEntry<K,V>> minSet = {entries.first};
  V min = entries.first.value;
  for (MapEntry<K,V> current in entries) {
    if (current.value < min) {
      minSet = {current};
      min = current.value;
    }
    else if (current.value == min) {minSet.add(current);}
  }
  return minSet;
}

/// Gets the sum of [numbers], The starting value is [starting].
///
/// Added in `2.7.0`.
N sum<N extends num>(Iterable<N> numbers, [N? starting]) {
  N sum;
  sum = (starting == null) ? 0 as N : starting;
  for (N current in numbers) {
    sum = sum + current as N;
  }
  return sum;
}

/// Added in `2.7.0`.
K sumMapKey<K extends num,V>(Map<K,V> map, [K? starting]) {
  K sum;
  sum = (starting == null) ? 0 as K : starting;
  Iterable<MapEntry<K,V>> entries = map.entries;
  for (MapEntry<K,V> current in entries) {
    sum = sum + current.key as K;
  }
  return sum;
}

/// Added in `2.7.0`.
V sumMapValue<K,V extends num>(Map<K,V> map, [V? starting]) {
  V sum;
  sum = (starting == null) ? 0 as V : starting;
  Iterable<MapEntry<K,V>> entries = map.entries;
  for (MapEntry<K,V> current in entries) {
    sum = sum + current.value as V;
  }
  return sum;
}

@Deprecated("2.8, use pow<int>(base, exponent)")
int powInt(int base, int exponent) {
  for (int i = 0; i < exponent;i++) {
    base *= exponent;
  }
  return base;
}

@Deprecated("2.8, use pow<num>(base, exponent)")
num powNum(num base, num exponent) => math.pow(base,exponent);
@Deprecated("2.8, use pow<double>(base, exponent)")
double powDouble(double base, double exponent) => math.pow(base,exponent).toDouble();

/// Added in `2.7.0`.
N pow<N extends num>(N base, N exponent) => math.pow(base,exponent) as N;

/// If [number] is a `pow(int, 2)`, then it returns a `int`,
/// else it returns a `double`.
///
/// Added in `2.7.0`.
num sqrt(num number) {
  double value = math.sqrt(number);
  return (value.isWhole) ? value.toInt() : value;
}

/// Added in `2.7.0`.
bool isLow(num number) => (number % 1 < 0.5);
/// Added in `2.7.0`.
bool isHigh(num number) => !isLow(number);

/// Added in `2.7.0`.
bool isDivBy(int oper, int number) => oper % number == 0;

/// Explicit that the first is 1.
///
/// Added in `2.7.0`.
List<int> primeFactors(int number) {
  List<int> list = [];
  int div = 2;
  if (number < 0) {list.add(-1); number*=-1;}
  int highestDiv = math.sqrt(number).toInt();
  while (div <= highestDiv) {
    if (isDivBy(number,div)) {
      list.add(div);
      number ~/= div;
      highestDiv = math.sqrt(number).toInt();
      div = 2;}
    else {div++;}
  }
  if (number != 1) {list.add(number);}
  return list;
}

/// If [number] is prime.
///
/// Added in `2.7.0`.
bool isPrime(int number) => (primeFactors(number).length == 1);
/// if number is constructed of primes
///
/// Added in `2.7.0`.
bool isComprime(int number) {
  List<int> list = primeFactors(number);
  if (list.length <= 1) {return false;}
  else if (list[0] != list[1] && list.length == 2) {return true;}
  else {return false;}
}

/// 64, 2 // true
///
/// 63, 3 // false
///
/// Added in `2.7.0`.
bool isExponentOf(int number, int base) => isMadeUpOf(number, [base]);

/// Added in `2.7.0`.
bool isMadeUpOf(int number, List<int> primes) {
  List<int> list = primeFactors(number);
  int index = 0;
  while (index < list.length) {
    if (primes.contains(list[index])) {list.removeAt(index);
    index = index.towardsZero;}
    else {return false;}
  }
  return true;
}