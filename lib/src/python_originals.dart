import 'extension.dart';
import 'math/math.dart';
import 'dart:math' as rnd;

/// Original python definition:
/// `def find(searchWith:int|float|str|bool|object,
/// *searchFor:int|float|str|bool|object, caseSensitive:bool=False,
/// shouldFind:bool=True, crash:bool=False) -> bool`.
///
/// [crash] is if the output is the opposite of shouldFind;
///
/// Added in `2.8`.
bool find<E>(
  E searchWith,
  Iterable<E> searchFor, {
  bool caseSensitive = false,
  bool shouldFind = true,
  bool crash = false,
}) {
  bool found;
  if (caseSensitive) {
    found = searchFor.contains(searchWith);
  } else {
    found = searchFor.nonCaseSensitiveContains(searchWith);
  }
  if (crash && shouldFind != found) {
    throw "Crashed on the basis of not finding a match; option.Crash:$crash";
  } else {
    return shouldFind == found;
  }
}

/// Original python definition:
/// `def delta(*num)`
///
/// Added in `2.8`.
N delta<N extends num>(Iterable<N> nums) => max(nums) - min(nums) as N;

/// Original python definition:
/// `def pick(*inputs:str|int|float|bool|object|list|set|tuple)
/// -> str|int|float|bool|object`
///
/// Added in `2.8`.
E pick<E>(Iterable<E> elements) =>
    elements.elementAt(rnd.Random().nextInt(elements.length - 1));
