import '../math/numbers.dart';

/// Added in `2.8`.
class BubbleSort {
  /// [swaps]: gives back the amount of [swaps] for [list].
  ///
  /// [checks]: gives back the amount of times `>` was asked.
  ///
  /// Added in `2.8`.
  static ({int swaps, int checks}) listSort<N extends num>(List<N> list) {
    int index, nextIndex, rotation, swaps, checks;
    index = swaps = checks = 0;
    nextIndex = rotation = 1;
    N current, next;
    while (rotation <= list.length) {
      if (nextIndex + rotation - 1 >= list.length) {
        index = 0;
        nextIndex = 1;
        ++rotation;
      }
      current = list[index];
      next = list[nextIndex];
      if (current > next) {
        list[index] = next;
        list[nextIndex] = current;
        ++swaps;
      }
      ++checks;
      index++;
      nextIndex++;
    }
    return (swaps: swaps, checks: checks);
  }

  /// Added in `2.8`.
  static ({int swaps, int checks}) listSortFraction(List<Fraction> list) {
    int index, nextIndex, rotation, swaps, checks;
    index = swaps = checks = 0;
    nextIndex = rotation = 1;
    Fraction current, next;
    while (rotation <= list.length) {
      if (nextIndex + rotation - 1 >= list.length) {
        index = 0;
        nextIndex = 1;
        ++rotation;
      }
      current = list[index];
      next = list[nextIndex];
      if (current > next) {
        list[index] = next;
        list[nextIndex] = current;
        ++swaps;
      }
      ++checks;
      ++index;
      ++nextIndex;
    }
    return (swaps: swaps, checks: checks);
  }

  /// Asks if [current] is more than [next] if it is, then it swaps.
  ///
  /// Added in `2.8`.
  static ({int swaps, int checks}) listSortAny<E>(
    List<E> list,
    bool? Function(E, E) equality,
  ) {
    int index, nextIndex, rotation, swaps, checks;
    index = swaps = checks = 0;
    nextIndex = rotation = 1;
    E current, next;
    while (rotation <= list.length) {
      if (nextIndex + rotation - 1 >= list.length) {
        index = 0;
        nextIndex = 1;
        ++rotation;
      }
      current = list[index];
      next = list[nextIndex];
      ++checks;
      switch (equality(current, next)) {
        case null:
          break;
        case true:
          list[index] = next;
          list[nextIndex] = current;
          ++swaps;
        case false:
          break;
      }
      ++index;
      ++nextIndex;
    }
    return (swaps: swaps, checks: checks);
  }

  static ({int swaps, int checks}) listSortStringLength(List<String> list) =>
      listSortAny(list, (c, n) => c.length > n.length);

  /*static Map<int,V> mapKeySortInt<V>(Map<int,V> map) {
    int index = 0;
    int rotation = 1;
    while (rotation <= map.length) {
      if (index + 1 + rotation >= map.length) {
        index = 0;
        ++rotation;
      }
      MapEntry<int, V> current = map.entries.elementAt(index);
      MapEntry<int, V> next = map.entries.elementAt(index+1);
      (current.key > next.key)
          ? {
        map[current.key] = next.value,
        map.
      }
          : {};
      index++;
    }
    return map;
  }*/
}
