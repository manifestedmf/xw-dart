/// Added in `2.8`.
class MergeSort {
  /// Added in `2.8`.
  static void listSort<N extends num>(List<N> list) {
    _mergeSort(list, 0, list.length - 1);
  }

  /// Gives back a concatenated sort, assuming that [a] & [b] is sorted.
  ///
  /// Added in `2.8`.
  static List<N> listMerge<N extends num>(List<N> a, List<N> b) {
    List<N> array = a + b;
    _merge(array, 0, a.length, array.length);
    return array;
  }

  /// Added in `2.8`.
  static void _mergeSort<N extends num>(List<N> array, int start, int end) {
    if (start < end) {
      int half = (start + end) ~/ 2;
      _mergeSort(array, start, half);
      _mergeSort(array, half + 1, end);
      _merge(array, start, half, end);
    }
  }

  static void _merge<N extends num>(
    List<N> array,
    int start,
    int half,
    int end,
  ) {
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
      if (_lessThanEqual(left[lIndex], right[rIndex])) {
        array[pIndex] = left[lIndex]!;
        lIndex++;
      } else {
        array[pIndex] = right[rIndex]!;
        rIndex++;
      }
    }
  }

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
}
