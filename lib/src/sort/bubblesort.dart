import '../math/fraction.dart';
import '../math/core.dart';

/// Added in `2.7.4`.
class BubbleSort {
  /// Gives back the amount of [swaps] for [list].
  ///
  /// Added in `2.7.4`.
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
  /// Added in `2.7.4`.
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
