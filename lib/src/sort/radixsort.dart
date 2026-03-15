import 'package:xw/sort.dart' show mergeSortAny;
import 'package:xw/math.dart' show pow;

class RadixSort {
  static void _radixSort<N extends num>(List<N> array, buckets) {

  }
  static void _radixSortInner<N extends num>(
    List<N> array,
    int buckets,
    int position,
  ) {
    mergeSortAny<N>(
      array,
      equality: (l, r) {
        l = l % pow(buckets, position) as N;
        r = r % pow(buckets, position) as N;
        l = l ~/ pow(buckets, position - 1) as N;
        r = r ~/ pow(buckets, position - 1) as N;
        if (l > r) {
          return true;
        } else if (l < r) {
          return false;
        } else {
          return null;
        }
      },
    );
  }
}
