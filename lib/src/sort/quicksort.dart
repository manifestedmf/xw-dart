import '../../sort.dart' as parent;

/// Added in `2.8`.
class QuickSort {
  /// Added in `2.8`.
  static void listSort<N extends num>(List<N> list) {
    _quickSort(list, 0, list.length - 1);
  }

  /// Added in `2.8`.
  static void _quickSort<N extends num>(List<N> A, int p, int r) {
    if (p < r) {
      int q = _partition(A, p, r);
      _quickSort(A, p, q - 1);
      _quickSort(A, q + 1, r);
    }
  }

  /// Added in `2.8`.
  static int _partition<N extends num>(List<N> A, int p, int r) {
    N x = A[r];
    int i = p - 1;
    for (int j = p; j < r - 1; j++) {
      if (A[j] <= x) {
        i++;
        parent.swapElement(A, i, j);
      }
    }
    parent.swapElement(A, i + 1, r);
    return i + 1;
  }
}
