import 'extension.dart' show BoolExt, NumExt, StringExt;
import 'math/math.dart' show sum, minSimple, maxSimple;

/// `true` = [t],
/// `false` = [f],
/// `null` = [n]
V ternaryO<V>(bool? question, V t, V f, V n) {
  if (question == true) {
    return t;
  } else if (question == false) {
    return f;
  } else {
    return n;
  }
}

/// `true` = [t],
/// `false` = [f],
/// `null` = [n]
Object? ternaryI(bool? question, dynamic Function() t, [dynamic Function()? f, dynamic Function()? n]) {
  if (question == true) {
    return t();
  } else if (question == false) {
    return (f != null) ? f() : f;
  } else {
    return (n != null) ? n() : n;
  }
}

Iterable<int> boolValues(Iterable<bool> bools) => [
  for (bool current in bools) current.toInt(),
];

bool and(Iterable<bool> bools) => sum(boolValues(bools)) == bools.length;

bool or(Iterable<bool> bools) => bools.contains(true);
bool xor(Iterable<bool> bools) => sum(boolValues(bools)).isOdd;
Iterable<bool> not(Iterable<bool> bools) => [
  for (bool current in bools) !current,
];

bool nand(Iterable<bool> bools) => !and(bools);
bool nor(Iterable<bool> bools) => !or(bools);
bool xnor(Iterable<bool> bools) => !xor(bools);
bool xand(Iterable<bool> bools) => sum(boolValues(bools)) == 0;

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
  int size = highest + 1 - lowest;
  if (lowest > highest) {
    throw "lowest: $lowest, can't be after highest: $highest";
  } else if (lowest == highest) {
    return lowest;
  } else if (lowest == 0) {
    return value % (highest + 1);
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

/// [min] is the value that is placed if [val] is below [min].
///
/// [max] is the value that is placed if [val] is above [max].
///
/// [val] is the inputted number, guaranteed to be inbetween [min] & [max].
///
/// Added in `2.7.2`.
N trim<N extends num>({required N min, required N max, required N val}) =>
    maxSimple(min, minSimple(max, val));

/// If [val] is higher than [max], then it cuts [val] to be the same value as [max].
///
/// Added in `2.8`.
N cut<N extends num>({required N max, required N val}) => minSimple(max, val);

/// If [val] is lower than [min], then it grows [val] to be the same value as [min].
///
/// Added in `2.8`.
N grow<N extends num>({required N min, required N val}) => maxSimple(min, val);

/// Added in `2.8`.
N inverse<N extends num>({required N min, required N max, required N val}) =>
    max - val + min as N;

/// Makes so there is at least [amount] of zeroes.
///
/// [amount] being one or less will only return [number] (in a string form).
///
/// the `return`s length will always at least be above [amount],
/// indicated by `return.length`.
///
/// ` `
///
/// ```
/// print(hAdder(50, 2)) // 50
/// print(hAdder(56, 4)) // 0056
/// print(hAdder(1896, 4)) // 1896
/// print(hAdder(1, -2)) // 1
/// ```
///
/// Do note, that there is a problem if any instance of
/// `int.parse(hAdder(n, x))` is not n (Where n & x is an unknown int).
/// Do please report it to the creator of this function
/// (manifestedmf on github) or on their repository
/// (manifestedmf/xw-dart on github).
///
/// Added in `2.8`.
String hAdder(int number, int amount) {
  String mule = "$number";
  if (number.length < amount) {
    String messenger = "";
    for (int index = 0; index < amount - number.length; index++) {
      messenger += "0";
    }
    mule = (number >= 0) ? mule.insert(messenger) : mule.insert(messenger, 1);
  }
  return mule;
}

/// Added in `2.8`.
bool? invert(bool? input) => (input == null) ? null : !input;

/// Gives the time it took to do [func].
///
/// [times] is the amount of times [func] is used (returns the average).
///
/// [sway] is the amount swayed by [Stopwatch]: `start()` and `stop()` functions.
///
/// Added in `2.8.1`.
Duration timed(dynamic Function() func, {int times = 1, Duration? sway}) {
  if (times == 0) {
    return Duration();
  } else if (times < 0) {
    throw RangeError.range(times, 0, null, "times");
  }
  Duration swaySample;
  if (sway == null) {
    int amount = maxSimple(times, 5);
    Stopwatch tester;
    swaySample = Duration();
    for (int i = 1; i <= amount; ++i) {
      tester = Stopwatch();
      tester.start();
      tester.stop();
      swaySample += tester.elapsed;
    }
    swaySample ~/= amount;
  } else {
    swaySample = sway;
  }
  Duration duration = Duration();
  Stopwatch stopwatch;
  for (int i = 1; i <= times; ++i) {
    stopwatch = Stopwatch();
    stopwatch.start();
    func();
    stopwatch.stop();
    duration += stopwatch.elapsed;
  }
  duration ~/= times;
  return duration - swaySample;
}

/// To use this function do
/// ```
/// await sleep(duration);
/// ```
///
/// Added in `2.8.1`.
Future<void> sleep(Duration duration) async => Future.delayed(duration);
