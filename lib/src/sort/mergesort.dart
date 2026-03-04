/// Added in `2.8`.
class MergeSort {
  /// Added in `2.8`.
  static int listSort<N extends num>(List<N> list) =>
      _mergeSort(list, 0, list.length - 1);

  /// Gives back a concatenated sort, assuming that [a] & [b] is sorted.
  ///
  /// Added in `2.8`.
  static List<N> listMerge<N extends num>(List<N> a, List<N> b) {
    List<N> array = a + b;
    _merge(array, 0, a.length - 1, array.length - 1);
    return array;
  }

  /// Added in `2.8`.
  static int _mergeSort<N extends num>(List<N> array, int start, int end) {
    if (start < end) {
      int checks = 0;
      int half = (start + end) ~/ 2;
      checks += _mergeSort(array, start, half);
      checks += _mergeSort(array, half + 1, end);
      checks += _merge(array, start, half, end);
      return checks;
    }
    return 0;
  }

  /// Added in `2.8`.
  static int _merge<N extends num>(
    List<N> array,
    int start,
    int half,
    int end,
  ) {
    int checks = 0;
    int leftLength = half - start + 1;
    int rightLength = end - half;
    List<N> left, right;
    left = [];
    right = [];
    for (int index = 0; index < leftLength; index++) {
      left.add(array[start + index]);
    }
    for (int index = 0; index < rightLength; index++) {
      right.add(array[half + index + 1]);
    }
    int lIndex, rIndex;
    lIndex = rIndex = 0;
    for (int pIndex = start; pIndex <= end; pIndex++) {
      checks++;
      if (lIndex >= leftLength) {
        array[pIndex] = right[rIndex++];
      } else if (rIndex >= rightLength) {
        array[pIndex] = left[lIndex++];
      } else if (left[lIndex] > right[rIndex]) {
        array[pIndex] = right[rIndex++];
      } else {
        array[pIndex] = left[lIndex++];
      }
    }
    return checks;
  }

  /// Added in `2.8`.
  static int listSortAny<E>(List<E> list, bool Function(E, E) mt) =>
      _mergeSortAny(list, 0, list.length - 1, mt);

  /// Added in `2.8`.
  static List<E> listMergeAny<E>(List<E> a, List<E> b, bool Function(E, E) mt) {
    List<E> array = a + b;
    _mergeAny(array, 0, a.length, array.length, mt);
    return array;
  }

  /// Added in `2.8`.
  static int _mergeSortAny<E>(
    List<E> array,
    int start,
    int end,
    bool Function(E, E) mt,
  ) {
    if (start < end) {
      int checks = 0;
      int half = (start + end) ~/ 2;
      checks += _mergeSortAny(array, start, half, mt);
      checks += _mergeSortAny(array, half + 1, end, mt);
      checks += _mergeAny(array, start, half, end, mt);
      return checks;
    }
    return 0;
  }

  /// Added in `2.8`.
  static int _mergeAny<E>(
    List<E> array,
    int start,
    int half,
    int end,
    bool Function(E, E) mt,
  ) {
    int checks = 0;
    int leftLength = half - start + 1;
    int rightLength = end - half;
    List<dynamic> left, right;
    left = []; right = [];
    for (int index = 0; index < leftLength; index++) {
      left.add(array[start + index]);
    }
    for (int index = 0; index < rightLength; index++) {
      right.add(array[half + index + 1]);
    }
    int lIndex, rIndex;
    lIndex = rIndex = 0;
    for (int pIndex = start; pIndex <= end; pIndex++) {
      checks++;
      if (lIndex >= leftLength) {
        array[pIndex] = right[rIndex++];
      } else if (rIndex >= rightLength) {
        array[pIndex] = left[lIndex++];
      } else if (mt(left[lIndex], right[rIndex])) {
        array[pIndex] = right[rIndex++];
      } else {
        array[pIndex] = left[lIndex++];
      }
      /*if (_lessThanEqualAny(left[lIndex], right[rIndex], mt)) {
        array[pIndex] = left[lIndex]!;
        lIndex++;
      } else {
        array[pIndex] = right[rIndex]!;
        rIndex++;
      }*/
    }
    return checks;
  }

  /// Added in `2.8`.
  static bool _lessThanEqualAny<E>(
    dynamic a,
    dynamic b,
    bool Function(E, E) mt,
  ) {
    if (a != _Infinite() && b != _Infinite()) {
      return !mt(a, b);
    } else if (a != _Infinite()) {
      return true;
    } else if (b != _Infinite()) {
      return false;
    } else {
      return true;
    }
  }
}

/// Added in `2.8`.
final class _Infinite {
  @override
  /// Added in `2.8`.
  bool operator ==(Object other) => runtimeType == other.runtimeType;
}
