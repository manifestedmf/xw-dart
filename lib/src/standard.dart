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