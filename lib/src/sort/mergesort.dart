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
    List<N?> left = List.filled(leftLength + 1, null, growable: false);
    List<N?> right = List.filled(rightLength + 1, null, growable: false);
    for (int index = 0; index < leftLength; index++) {
      left[index] = array[start + index];
    }
    for (int index = 0; index < rightLength; index++) {
      right[index] = array[half + index + 1];
    }
    left[leftLength] = null;
    right[rightLength] = null;
    int lIndex = 0;
    int rIndex = 0;
    for (int pIndex = start; pIndex <= end; pIndex++) {
      checks++;
      if (_lessThanEqual(left[lIndex], right[rIndex])) {
        array[pIndex] = left[lIndex]!;
        lIndex++;
      } else {
        array[pIndex] = right[rIndex]!;
        rIndex++;
      }
    }
    return checks;
  }

  /// Added in `2.8`.
  static bool _lessThanEqual<N extends num>(N? a, N? b) {
    if (a != null && b != null) {
      return a <= b;
    } else if (a != null) {
      return true;
    } else if (b != null) {
      return false;
    } else {
      return true;
    }
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
    List<dynamic> left = List.filled(
      leftLength + 1,
      _Infinite(),
      growable: false,
    );
    List<dynamic> right = List.filled(
      rightLength + 1,
      _Infinite(),
      growable: false,
    );
    for (int index = 0; index < leftLength; index++) {
      left[index] = array[start + index];
    }
    for (int index = 0; index < rightLength; index++) {
      right[index] = array[half + index + 1];
    }
    left[leftLength] = _Infinite();
    right[rightLength] = _Infinite();
    int lIndex = 0;
    int rIndex = 0;
    for (int pIndex = start; pIndex <= end; pIndex++) {
      checks++;
      if (_lessThanEqualAny(left[lIndex], right[rIndex], mt)) {
        array[pIndex] = left[lIndex]!;
        lIndex++;
      } else {
        array[pIndex] = right[rIndex]!;
        rIndex++;
      }
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
