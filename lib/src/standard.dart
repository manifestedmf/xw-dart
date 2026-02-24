import 'extension.dart';
import 'math/math.dart';

/// `true` = [a],
/// `false` = [b],
/// `null` = [c]
V ternaryO<V>(bool? question, V a, V b, V c) {
  if (question == true) {return a;}
  else if (question == false) {return b;}
  else {return c;}
}
/// `true` = [a],
/// `false` = [b],
/// `null` = [c]
Object? ternaryI(bool? question, Function() a, [Function()? b, Function()? c]) {
  if (question == true) {return a();}
  else if (question == false) {
    return (b != null) ? b() : b;
  }
  else {
    return (c != null) ? c() : c;
  }
}

Iterable<int> boolValues(Iterable<bool> bools) => [
  for (bool current in bools)
    current.toInt()
];

bool and(Iterable<bool> bools) =>
  sum(boolValues(bools))
      == bools.length;

bool or(Iterable<bool> bools) => bools.contains(true);
bool xor(Iterable<bool> bools) => sum(boolValues(bools)).isOdd;
Iterable<bool> not(Iterable<bool> bools) => [
  for (bool current in bools)
    !current
];

bool nand(Iterable<bool> bools) => !and(bools);
bool nor(Iterable<bool> bools) => !or(bools);
bool xnor(Iterable<bool> bools) => !xor(bools);
bool xand(Iterable<bool> bools) =>
  sum(boolValues(bools))
      == 0;

bool xnand(Iterable<bool> bools) => !xand(bools);

/// [lowest] is the lowest possible number for [value].
///
/// [highest] is the highest possible number for [value].
///
/// [value] is guaranteed to be in the ranges of [lowest] & [highest].
///
/// If [value] is not in bounds, then report it to the creator of this
/// function (mainfestedmf on github) or on their repository
/// (manifestedmf/xw-dart on github)
int wrapper({required int lowest, required int highest, required int value}) {
  int size = highest+1-lowest;
  if (lowest > highest) {
    throw "lowest: $lowest, can't be after highest: $highest";
  } else if (lowest == highest) {
    return lowest;
  } else if (lowest == 0) {
    return value % (highest+1);
  } else {
    if (value >= lowest && value <= highest) {
    } else if (value < lowest) {
      do {
        value += size;
      } while (value < lowest);
    } else {
      do {
        value -= size;
      } while (value > highest);
    }
    return value;
  }
}

/// [min] is the value that is placed if [value] is below [min].
///
/// [max] is the value that is placed if [value] is above [max].
///
/// [value] is the inputted number, guaranteed to be inbetween [min] & [max].
int trim({required int min, required int max, required int value}) =>
  maxSimple(min, minSimple(max, value));