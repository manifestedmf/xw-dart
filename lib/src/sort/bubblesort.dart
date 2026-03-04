import '../math/fraction.dart';

/// Added in `2.8`.
class BubbleSort {
  /// Gives back the amount of [swaps] for [list].
  ///
  /// Added in `2.8`.
  static int listSort<N extends num>(List<N> list) {
    int index, nextIndex, rotation, swaps;
    index = swaps = 0;
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
      index++;
      nextIndex++;
    }
    return swaps;
  }

  /// Added in `2.8`.
  static int listSortFraction(List<Fraction> list) {
    int index, nextIndex, rotation, swaps;
    index = swaps = 0;
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
      ++index;
      ++nextIndex;
    }
    return swaps;
  }

  /// Asks if [current] is more than [next] if it is, then it swaps.
  ///
  /// Added in `2.8`.
  static int listSortAny<E>(List<E> list, bool Function(E, E) mt) {
    int index, nextIndex, rotation, swaps;
    index = swaps = 0;
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
      if (mt(current, next)) {
        list[index] = next;
        list[nextIndex] = current;
        ++swaps;
      }
      ++index;
      ++nextIndex;
    }
    return swaps;
  }

  static int listSortStringLength(List<String> list) =>
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
