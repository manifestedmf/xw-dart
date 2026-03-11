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
    left = array.sublist(start, half + 1);
    right = array.sublist(half + 1, end + 1);
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
  static int listSortAny<E>(List<E> list, bool? Function(E, E) equality) =>
      _mergeSortAny(list, 0, list.length - 1, equality);

  /// Added in `2.8`.
  static List<E> listMergeAny<E>(
    List<E> a,
    List<E> b,
    bool? Function(E, E) equality,
  ) {
    List<E> array = a + b;
    _mergeAny(array, 0, a.length, array.length, equality);
    return array;
  }

  /// Added in `2.8`.
  static int _mergeSortAny<E>(
    List<E> array,
    int start,
    int end,
    bool? Function(E, E) equality,
  ) {
    if (start < end) {
      int checks = 0;
      int half = (start + end) ~/ 2;
      checks += _mergeSortAny(array, start, half, equality);
      checks += _mergeSortAny(array, half + 1, end, equality);
      checks += _mergeAny(array, start, half, end, equality);
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
    bool? Function(E, E) equality,
  ) {
    int checks = 0;
    int leftLength = half - start + 1;
    int rightLength = end - half;
    List<E> left, right;
    left = array.sublist(start, half + 1);
    right = array.sublist(half + 1, end + 1);
    int lIndex, rIndex;
    lIndex = rIndex = 0;
    for (int pIndex = start; pIndex <= end; pIndex++) {
      checks++;
      if (lIndex >= leftLength) {
        array[pIndex] = right[rIndex++];
      } else if (rIndex >= rightLength) {
        array[pIndex] = left[lIndex++];
      } else {
        switch (equality(left[lIndex], right[rIndex])) {
          case true:
            array[pIndex] = right[rIndex++];
          case null:
          case false:
            array[pIndex] = left[lIndex++];
        }
      }
      /*if (_lessThanEqualAny(left[lIndex], right[rIndex], gt)) {
        array[pIndex] = left[lIndex]!;
        lIndex++;
      } else {
        array[pIndex] = right[rIndex]!;
        rIndex++;
      }*/
    }
    return checks;
  }
}
