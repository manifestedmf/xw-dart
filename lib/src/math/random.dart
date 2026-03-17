import 'dart:math' show Random;
import 'math.dart' show abs;
import 'numbers.dart' show Fraction;
export 'dart:math' show Random;

/// Generates a random [int] from [low] (inclusive) to [high] (inclusive).
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

/// Generates a random [double] from
/// `0.0` (inclusive) to `1.0` (exclusive),
/// meaning the return is `>= 0.0` and `< 1.0`.
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
/// This advances [random] by two steps.
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
  return random.nextInt(abs(chance.div)) > abs(chance.oper) - 1;
}
