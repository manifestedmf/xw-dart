import 'dart:convert';
import 'dart:math' show Random;
import 'math.dart' as math show abs, sumMapValue;
import 'numbers.dart' show Fraction;
import '../rgb.dart' show sRGB;
import '../standard.dart' show trim;
import '../extension.dart' show MapKV, IterableE, ListE;
import '../../core.dart' show UnexpectedError;
import '../../typedef.dart' show Amount;

export 'dart:math' show Random;

/// Generates a random [int] from [low] (inclusive) to [high] (inclusive).
///
/// This advances [random] by `1` step.
///
/// If [low] is `0`,
/// then it is equivalent to [random]`.`[nextInt]`(`[high]` + 1)`.
///
/// If you already have a pre-existent [Random],
/// then use the [random] argument.
///
/// If you don't have a [Random] but do have a seed,
/// then use the [seed] argument.
///
/// If you want a cryptographically secure [Random],
/// then make [secure] `true`, if it can't generate one,
/// then it throws a [UnsupportedError].
///
/// [secure] overrides over [random] and [seed],
/// while [random] overrides [seed].
/*
///
/// ```
/// randomInt(-1, 5) // Value is >= -1 and <= 5.
/// randomInt(-2, 10, random: Random()) //
/// ```
*/
///
/// Added in `2.8`.
int randomInt(
  int low,
  int high, {
  Random? random,
  int? seed,
  bool secure = false,
}) {
  if (low > high) {
    throw RangeError.range(high, low, null);
  } else if (secure) {
    random = Random.secure();
  } else {
    random ??= Random(seed);
  }
  return random.nextInt(high - low + 1) + low;
}

/// Generates a random [int] from `0` (inclusive) to `1 << 32` (exclusive).
///
/// If you already have a pre-existent [Random],
/// then use the [random] argument.
///
/// If you don't have a [Random] but do have a seed,
/// then use the [seed] argument.
///
/// If you want a cryptographically secure [Random],
/// then make [secure] `true`, if it can't generate one,
/// then it throws a [UnsupportedError].
///
/// [secure] overrides over [random] and [seed],
/// while [random] overrides [seed].
/*
///
/// ```
/// randomInt(-1, 5) // Value is >= -1 and <= 5.
/// randomInt(-2, 10, random: Random()) //
/// ```
*/
///
/// Added in `2.8`.
int randomInt32({Random? random, int? seed, bool secure = false}) {
  if (secure) {
    random = Random.secure();
  } else {
    random ??= Random(seed);
  }
  return random.nextInt(1 << 32);
}

/// Generates a random [double] from
/// `0.0` (inclusive) to `1.0` (exclusive),
/// meaning the return is `>= 0.0` and `< 1.0`.
///
/// This advances [random] by `1` step.
///
/// If you already have a pre-existent [Random],
/// then use the [random] argument.
///
/// If you don't have a [Random] but do have a seed,
/// then use the [seed] argument.
///
/// If you want a cryptographically secure [Random],
/// then make [secure] `true`, if it can't generate one,
/// then it throws a [UnsupportedError].
///
/// [secure] overrides over [random] and [seed],
/// while [random] overrides [seed].
///
/// Added in `2.8`.
double randomFloat({Random? random, int? seed, bool secure = false}) {
  if (secure) {
    random = Random.secure();
  } else {
    random ??= Random(seed);
  }
  return random.nextDouble();
}

/// Generates a random [double] from
/// [low] (inclusive) to [high] (exclusive),
/// meaning the return is `>= `[low] and `< `[high].
///
/// This advances [random] by `1` step.
///
/// If you already have a pre-existent [Random],
/// then use the [random] argument.
///
/// If you don't have a [Random] but do have a seed,
/// then use the [seed] argument.
///
/// If you want a cryptographically secure [Random],
/// then make [secure] `true`, if it can't generate one,
/// then it throws a [UnsupportedError].
///
/// [secure] overrides over [random] and [seed],
/// while [random] overrides [seed].
///
/// Added in `2.8`.
double randomDouble(
  double low,
  double high, {
  Random? random,
  int? seed,
  bool secure = false,
}) {
  if (low > high) {
    throw RangeError.range(high, low.floor(), null);
  } else if (secure) {
    random = Random.secure();
  } else {
    random ??= Random(seed);
  }
  return randomFloat(random: random) * (high - low) + low;
}

/// Generates a random [bool].
///
/// This advances [random] by `1` step.
///
/// The chance for getting a `true` is used by the [chance] argument.
///
/// If [chance] is higher than one, then it goes to 100%,
/// else if [chance] is lower than zero, then it goes to 0%.
///
/// If you already have a pre-existent [Random],
/// then use the [random] argument.
///
/// If you don't have a [Random] but do have a seed,
/// then use the [seed] argument.
///
/// If you want a cryptographically secure [Random],
/// then make [secure] `true`, if it can't generate one,
/// then it throws a [UnsupportedError].
///
/// If you want to always use [random] once,
/// then make [alwaysUse] `true`.
///
/// [secure] overrides over [random] and [seed],
/// while [random] overrides [seed].
///
/// Added in `2.8`.
bool randomBool({
  Fraction chance = Fraction.half,
  Random? random,
  int? seed,
  bool secure = false,
  bool alwaysUse = false,
}) {
  if (secure) {
    random = Random.secure();
  } else {
    random ??= Random(seed);
  }
  chance = chance.toCompressed();
  if (chance >= Fraction.one) {
    if (alwaysUse) {
      random.nextBool();
    }
    return true;
  } else if (chance < Fraction.zero) {
    if (alwaysUse) {
      random.nextBool();
    }
    return false;
  }
  return random.nextInt(math.abs(chance.div)) > math.abs(chance.oper) - 1;
}

/// Generates a random [sRGB].
///
/// This advances [random] by three steps.
///
/// If you want a section of the colors,
/// then use `color` ( `Max` | `Min` ) argument.
///
/// If you already have a pre-existent [Random],
/// then use the [random] argument.
///
/// If you don't have a [Random] but do have a seed,
/// then use the [seed] argument.
///
/// If you want a cryptographically secure [Random],
/// then make [secure] `true`, if it can't generate one,
/// then it throws a [UnsupportedError].
///
/// [secure] overrides over [random] and [seed],
/// while [random] overrides [seed].
///
/// If [secure] is `true`,
/// then it also uses [secure] for each [randomInt] use.
///
/// Added in `2.8`.
sRGB randomRGB({
  int redMin = 0,
  int redMax = 255,
  int greenMin = 0,
  int greenMax = 255,
  int blueMin = 0,
  int blueMax = 255,
  Random? random,
  int? seed,
  bool secure = false,
}) {
  redMin = trim(min: 0, max: 255, val: redMin);
  redMax = trim(min: 0, max: 255, val: redMax);
  if (redMin > redMax) {
    throw RangeError.range(redMax, redMin, 255);
  }
  greenMin = trim(min: 0, max: 255, val: greenMin);
  greenMax = trim(min: 0, max: 255, val: greenMax);
  if (greenMin > greenMax) {
    throw RangeError.range(greenMax, greenMin, 255);
  }
  blueMin = trim(min: 0, max: 255, val: blueMin);
  blueMax = trim(min: 0, max: 255, val: blueMax);
  if (blueMin > blueMax) {
    throw RangeError.range(blueMax, blueMin, 255);
  }
  random ??= Random(seed);
  return sRGB(
    red: randomInt(redMin, redMax, random: random, secure: secure),
    green: randomInt(greenMin, greenMax, random: random, secure: secure),
    blue: randomInt(blueMin, blueMax, random: random, secure: secure),
  );
}

/// Gives back a random element in [elements]
/// from [start] (inclusive) to [end] (inclusive).
///
/// This advances [random] by `1` step.
///
/// If you already have a pre-existent [Random],
/// then use the [random] argument.
///
/// If you don't have a [Random] but do have a seed,
/// then use the [seed] argument.
///
/// If you want a cryptographically secure [Random],
/// then make [secure] `true`, if it can't generate one,
/// then it throws a [UnsupportedError].
///
/// [secure] overrides over [random] and [seed],
/// while [random] overrides [seed].
///
/// Added in `2.8`.
E randomElement<E>(
  Iterable<E> elements, {
  int start = 0,
  int? end,
  Random? random,
  int? seed,
  bool secure = false,
}) {
  if (secure) {
    random = Random.secure();
  } else {
    random ??= Random(seed);
  }
  end ??= elements.length - 1;
  return elements.elementAt(randomInt(start, end));
}

/// Randomly shuffles each element in [list].
///
/// This advances [random] by [list]`.length` steps.
///
/// If you already have a pre-existent [Random],
/// then use the [random] argument.
///
/// If you don't have a [Random] but do have a seed,
/// then use the [seed] argument.
///
/// If you want a cryptographically secure [Random],
/// then make [secure] `true`, if it can't generate one,
/// then it throws a [UnsupportedError].
///
/// [secure] overrides over [random] and [seed],
/// while [random] overrides [seed].
///
/// If [secure] is `true`,
/// then every time [randomInt] is used it creates a new secure [Random].
///
/// Added in `2.8`.
void shuffleList<E>(
  List<E> list, {
  Random? random,
  int? seed,
  bool secure = false,
}) {
  if (secure) {
    random = Random.secure();
  } else {
    random ??= Random(seed);
  }
  int step = 0;
  while (step < list.length) {
    list.swap(
      step,
      randomInt(step, list.length - 1, random: random, secure: secure),
    );
    step++;
  }
}

/// Swaps a `2` random positions in [list],
/// can only be same position if [possiblySame] is `true`.
///
/*
/// If [alwaysUse] is `true`,
/// then it still uses [random] even when it doesn't need to,
/// for example: `swapRandomElement(`[[]`5, 2])`
/// would always swap it to being [[]`2, 5]`,
/// so it doesn't need to use [random] but it will still do.
///
*/
/// This advances [random] by `2` steps.
///
/// If you already have a pre-existent [Random],
/// then use the [random] argument.
///
/// If you don't have a [Random] but do have a seed,
/// then use the [seed] argument.
///
/// If you want a cryptographically secure [Random],
/// then make [secure] `true`, if it can't generate one,
/// then it throws a [UnsupportedError].
///
/// If a combination like
/// `swapRandomElement(`[[]`3], same: false)` or
/// `swapRandomElement(`[[]`], same: false)`
/// happens, then it will throw a [StateError].
///
/// [secure] overrides over [random] and [seed],
/// while [random] overrides [seed].
///
/// Added in `2.8.1`.
void swapRandomElement<E>(
  List<E> list, {
  int start = 0,
  int? end,
  bool possiblySame = false,
  Random? random,
  int? seed,
  bool secure = false,
}) {
  if (secure) {
    random = Random.secure();
  } else {
    random ??= Random(seed);
  }
  if (list.isEmpty && !possiblySame) {
    throw StateError(
      "$list can't be empty and not be allowed to swap same place",
    );
  } else if (list.isSingle && !possiblySame) {
    throw StateError(
      "$list can't be single and not be allowed to swap same place",
    );
  }
  end ??= list.length;
  int gotten = randomInt(start, end, random: random, secure: secure);
  if (possiblySame) {
    list.swap(gotten, randomInt(start, end));
    return;
  } else {
    int other = randomInt(start, end - 1, random: random, secure: secure);
    if (other >= gotten) {
      other++;
    }
    list.swap(gotten, other);
    return;
  }
}

/// Gives back a random [E] in [items],
/// with `key` being chosen by the chance of `value / sum(items.values)`.
///
/// If [alwaysUse] is `true`,
/// then it still uses [random] even when it doesn't need to,
/// for example: `randomOf({1: Fraction})` would return `1` always,
/// so it doesn't need to use [random] but it will still do.
///
/// This advances [random] by `1` step.
///
/// If you already have a pre-existent [Random],
/// then use the [random] argument.
///
/// If you don't have a [Random] but do have a seed,
/// then use the [seed] argument.
///
/// If you want a cryptographically secure [Random],
/// then make [secure] `true`, if it can't generate one,
/// then it throws a [UnsupportedError].
///
/// [secure] overrides over [random] and [seed],
/// while [random] overrides [seed].
///
/// Added in `2.8`.
E randomOf<E>(
  Amount<E> items, {
  Random? random,
  int? seed,
  bool secure = false,
  E? ifNone,
  bool alwaysUse = false,
}) {
  if (secure) {
    random = Random.secure();
  } else {
    random ??= Random(seed);
  }
  if (items.isEmpty) {
    return ifNone ??
        (throw UnsupportedError(
          "$items can't be empty and have $ifNone to be ${null}",
        ));
  } else if (items.isSingle) {
    if (alwaysUse) {
      random.nextBool();
    }
    return items.singleKey;
  }
  int sum = 0;
  int value = random.nextInt(math.sumMapValue(items));
  for (MapEntry<E, int> item in items.entries) {
    sum += item.value;
    if (value < sum) {
      return item.key;
    }
  }
  throw UnexpectedError("Previous loop should have caught a value");
}

/// Generates a random [String], [maxLength] being `null`,
/// means it can be (1 << 8) length.
///
/// If [minLength] is negative, then it throws a [ArgumentError].
///
/// Throws [RangeError] if `maxLength < minLength`.
///
/// This advances [random] by random
/// from `1 + `[minLength]
/// to `1 + `[maxLength] steps.
///
/// [charCode], is the generator of chars,
/// if it gives out a `2` length string, then it throws a [ArgumentError].
/// If [charCode] is `null`, then it uses [String.fromCharCodes].
///
/// [highestUnit] is the highest code unit that can be used
/// (use if [charCode] is changed).
///
/// If you already have a pre-existent [Random],
/// then use the [random] argument.
///
/// If you don't have a [Random] but do have a seed,
/// then use the [seed] argument.
///
/// If you want a cryptographically secure [Random],
/// then make [secure] `true`, if it can't generate one,
/// then it throws a [UnsupportedError].
///
/// [secure] overrides over [random] and [seed],
/// while [random] overrides [seed].
///
/// If [maxLength] is `0`, then it always be `""`
/// and wouldn't need to use [random],
/// but if [alwaysUse] is `true`, then it will use it regardless
/// if it knows it or not.
///
/// Added in `2.8.1`.
String randomString({
  int minLength = 0,
  int maxLength = 1 << 8,
  Converter<List<int>, String>? charCode,
  int highestUnit = 1 << 16,
  Random? random,
  int? seed,
  bool secure = false,
  bool alwaysUse = false,
}) {
  if (minLength.isNegative) {
    throw ArgumentError.value(minLength, "min", "Can't be negative");
  }
  if (maxLength < minLength) {
    throw RangeError.range(maxLength, minLength, 1 << 8, "max");
  }
  if (secure) {
    random = Random.secure();
  } else {
    random ??= Random(seed);
  }
  if (maxLength == 0) {
    if (alwaysUse) {
      random.nextBool();
    }
    return "";
  }
  List<int> bytes = List.filled(
    randomInt(minLength, maxLength),
    0,
    growable: false,
  );
  bytes.changeEach(
    (ul) => randomInt(0, highestUnit, random: random, secure: secure),
  );
  if (charCode == null) {
    return String.fromCharCodes(bytes);
  } else {
    String converted = charCode.convert(bytes);
    if (converted.length != bytes.length) {
      throw ArgumentError.value(charCode, "charCode", "Has to give out chars");
    } else {
      return converted;
    }
  }
}

/// Generates a random [String] that has length of `1`.
///
/// This advances [random] by `1` step.
///
/// [charCode], is the generator of chars,
/// if it gives out a `2` length string, then it throws a [ArgumentError].
/// If [charCode] is `null`, then it uses [String.fromCharCodes].
///
/// [highestUnit] is the highest code unit that can be used
/// (use if [charCode] is changed).
///
/// If you already have a pre-existent [Random],
/// then use the [random] argument.
///
/// If you don't have a [Random] but do have a seed,
/// then use the [seed] argument.
///
/// If you want a cryptographically secure [Random],
/// then make [secure] `true`, if it can't generate one,
/// then it throws a [UnsupportedError].
///
/// [secure] overrides over [random] and [seed],
/// while [random] overrides [seed].
///
/// If [allowEOF] is `true`, then it can return `""`.
///
/// Added in `2.8.1`.
String randomChar({
  Converter<List<int>, String>? charCode,
  int highestUnit = 1 << 16,
  Random? random,
  int? seed,
  bool secure = false,
  bool allowEOF = true,
}) {
  if (allowEOF) {
    highestUnit++;
  }
  if (secure) {
    random = Random.secure();
  } else {
    random ??= Random(seed);
  }
  int code = randomInt(0, highestUnit, random: random);
  if (code == highestUnit) {
    return "";
  } else if (charCode == null) {
    return String.fromCharCode(code);
  } else {
    String char = charCode.convert([code]);
    if (char.length != 1) {
      throw ArgumentError.value(charCode, "charCode", "Has to give out chars");
    } else {
      return char;
    }
  }
}