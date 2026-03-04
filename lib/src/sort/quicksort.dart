import '../../sort.dart' as parent;

/// Added in `2.8`.
class QuickSort {
  /// Added in `2.8`.
  static int listSort<N extends num>(List<N> list) =>
      _quickSort(list, 0, list.length - 1);

  /// Added in `2.8`.
  static int _quickSort<N extends num>(List<N> array, int start, int end) {
    if (start < end) {
      var (:highestValueIndex, :checks) = _partition(array, start, end);
      checks += _quickSort(array, start, highestValueIndex - 1);
      checks += _quickSort(array, highestValueIndex + 1, end);
      return checks;
    }
    return 0;
  }

  /// Added in `2.8`.
  static ({int highestValueIndex, int checks}) _partition<N extends num>(
    List<N> array,
    int start,
    int end,
  ) {
    N lastElement = array[end];
    int checks = 0;
    int primeIndex = start - 1;
    for (int index = start; index < end; index++) {
      checks++;
      if (array[index] <= lastElement) {
        primeIndex++;
        parent.swapElement(array, primeIndex, index);
      }
    }
    parent.swapElement(array, primeIndex + 1, end);
    return (highestValueIndex: primeIndex + 1, checks: checks);
  }

  /// Added in `2.8`.
  static int listSortAny<E>(List<E> list, bool Function(E, E) mt) =>
      _quickSortAny(list, 0, list.length - 1, mt);
  /// Added in `2.8`.
  static int _quickSortAny<E>(
    List<E> array,
    int start,
    int end,
    bool Function(E, E) mt,
  ) {
    if (start < end) {
      var (:highestValueIndex, :checks) = _partitionAny(array, start, end, mt);
      checks += _quickSortAny(array, start, highestValueIndex - 1, mt);
      checks += _quickSortAny(array, highestValueIndex + 1, end, mt);
      return checks;
    }
    return 0;
  }
  /// Added in `2.8`.
  static ({int highestValueIndex, int checks}) _partitionAny<E>(
    List<E> array,
    int start,
    int end,
    bool Function(E, E) mt,
  ) {
    E lastElement = array[end];
    int checks = 0;
    int primeIndex = start - 1;
    for (int index = start; index < end; index++) {
      checks++;
      if (!mt(array[index], lastElement)) {
        primeIndex++;
        parent.swapElement(array, primeIndex, index);
      }
    }
    parent.swapElement(array, primeIndex + 1, end);
    return (highestValueIndex: primeIndex + 1, checks: checks);
  }
}
