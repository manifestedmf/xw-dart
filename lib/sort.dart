/// Added in `2.8`.
library;

import 'src/math/numbers.dart' show Fraction;
import 'src/sort/bubblesort.dart' show BubbleSort;
import 'src/sort/mergesort.dart' show MergeSort;
import 'src/sort/quicksort.dart' show QuickSort;
import 'src/math/random.dart' show shuffleList, swapRandomElement;

/// Sorts using the [BubbleSort] method.
///
/// Goes through each index to the next,
/// does nothing if next is more than current index;
/// Swaps if next is less than current index.
///
/// Added in `2.8`.
({int swaps, int checks}) bubbleSort<N extends num>(List<N> list) =>
    BubbleSort.listSort(list);

/// Added in `2.8`.
({int swaps, int checks}) bubbleSortFraction(List<Fraction> list) =>
    BubbleSort.listSortFraction(list);

/// [equality] should give out:
/// [true] for `current > next`,
/// [null] for `current == next` and
/// [false] for `current < next`.
///
/// [equality] only swaps if `current` is more than `next`.
///
/// Added in `2.8`.
({int swaps, int checks}) bubbleSortAny<E>(
  List<E> list, {
  required bool? Function(E, E) equality,
}) => BubbleSort.listSortAny(list, equality);

/// Added in `2.8`.
int _bubbleSort<N extends num>(List<N> list) => bubbleSort(list).checks;

/// Added in `2.8`.
int _bubbleSortAny<E>(List<E> list, {required bool? Function(E, E) equality}) =>
    bubbleSortAny(list, equality: equality).checks;

/// Added in `2.8`.
int mergeSort<N extends num>(List<N> list) => MergeSort.listSort(list);

/// Added in `2.8`.
List<N> mergeList<N extends num>(List<N> a, List<N> b) =>
    MergeSort.listMerge(a, b);

/// [equality] should give out:
/// [true] for `left[a] > right[b]`,
/// [null] for `left[a] == right[b]` and
/// [false] for `left[a] < right[b]`.
///
/// [equality] only picks `left[a]` if `left[a]` is more than `right[b]`.
///
/// Added in `2.8`.
int mergeSortAny<E>(List<E> list, {required bool? Function(E, E) equality}) =>
    MergeSort.listSortAny(list, equality);

/// [gt] is short for `>`.
///
/// Added in `2.8`.
List<E> mergeListAny<E>(
  List<E> a,
  List<E> b, {
  required bool? Function(E, E) equality,
}) => MergeSort.listMergeAny(a, b, equality);

/// Added in `2.8.`
int quickSort<N extends num>(List<N> list) => QuickSort.listSort(list);

/// [equality] should give out:
/// [true] for `array[a] > array[b]`,
/// [null] for `array[a] == array[b]` and
/// [false] for `array[a] < array[b]`.
///
/// [equality] only swaps `array[a]` & `array[b]` if
/// `array[a] <= lastElement`.
///
/// Added in `2.8`.
int quickSortAny<E>(List<E> list, {required bool? Function(E, E) equality}) =>
    QuickSort.listSortAny(list, equality);

/// Shuffles [list] randomly, till it gets out the sorted value.
///
/// Added in `2.8`.
int bogoSort<N extends num>(List<N> list) {
  int shuffles = 0;
  while (!isSorted(list)) {
    shuffleList(list);
    shuffles++;
  }
  return shuffles;
}

/// Shuffles [list] randomly, till it gets out the sorted value.
///
/// Added in `2.8`.
int bogoSortAny<E>(List<E> list, {required bool? Function(E, E) equality}) {
  int shuffles = 0;
  while (!isSortedAny(list, equality: equality)) {
    shuffleList(list);
    shuffles++;
  }
  return shuffles;
}

/// Swaps 2 elements in [list] randomly, till it gets out the sorted value.
///
/// Added in `2.8.1`.
int bozoSort<N extends num>(List<N> list) {
  int swaps = 0;
  while (!isSorted(list)) {
    swapRandomElement(list);
    swaps++;
  }
  return swaps;
}

/// Swaps 2 elements in [list] randomly, till it gets out the sorted value.
///
/// Added in `2.8.1`.
int bozoSortAny<E>(List<E> list, {required bool? Function(E, E) equality}) {
  int swaps = 0;
  while (!isSortedAny(list, equality: equality)) {
    swapRandomElement(list);
    swaps++;
  }
  return swaps;
}

/// Deletes any data that isn't one more than the previous.
///
/// Returns the amount deleted.
///
/// Added in `2.8.1`.
int stalinSort<N extends num>(List<N> list) {
  int deleted = 0;
  for (int index = list.length - 2; index > 0; index--) {
    if (list[index] > list[index + 1]) {
      list.removeAt(index + 1);
      deleted++;
    }
  }
  return deleted;
}

/// Deletes any data that isn't one more than the previous.
///
/// Returns the amount deleted.
///
/// Added in `2.8.1`.
int stalinSortAny<E>(List<E> list, {required bool? Function(E, E) equality}) {
  int deleted = 0;
  for (int index = list.length - 2; index > 0; index--) {
    switch (equality(list[index], list[index + 1])) {
      case true:
        list.removeAt(index + 1);
        deleted++;
      case false:
      case null:
        break;
    }
  }
  return deleted;
}

/// Swaps [E]lement at [a] and [E]lement at [b] in [array].
///
/// This is what the [swapElement] does (in a generic language).
/// ```
/// element = array[a]
/// array[a] = array[b]
/// array[b] = element
/// ```
///
/// Added in `2.8`.
void swapElement<E>(List<E> array, int a, int b) {
  E element = array[a];
  array[a] = array[b];
  array[b] = element;
  return;
}

/// Checks if [array] is sorted.
///
/// Added in `2.8`.
bool isSorted<N extends num>(List<N> array) {
  int i = 0;
  while (i + 1 < array.length - 1) {
    if (array[i++] > array[i]) {
      return false;
    }
  }
  return true;
}

/// Added in `2.8`.
bool isSortedAny<E>(List<E> array, {required bool? Function(E, E) equality}) {
  int i = 0;
  while (i + 1 < array.length - 1) {
    switch (equality(array[i++], array[i])) {
      case true:
        return false;
      case null:
      case false:
        break;
    }
  }
  return true;
}

/// Sorting Algorithm
///
/// Added in `2.8`.
enum SortAlg {
  /// Added in `2.8`.
  bubble(funcStd: _bubbleSort, funcAny: _bubbleSortAny, isInline: true),

  /// Added in `2.8`.
  merge(funcStd: mergeSort, funcAny: mergeSortAny, isInline: true),

  /// Added in `2.8`.
  quick(funcStd: quickSort, funcAny: quickSortAny, isInline: true),

  /// Added in `2.8.1`.
  bogo(funcStd: bogoSort, funcAny: bogoSortAny, isInline: true),

  /// Added in `2.8.1`.
  bozo(funcStd: bozoSort, funcAny: bozoSortAny, isInline: true),

  /// Added in `2.8.1`.
  stalin(
    funcStd: stalinSort,
    funcAny: stalinSortAny,
    isInline: true,
    losesData: true,
  );

  /// The `std` function for a list.
  ///
  /// Added in `2.8`.
  final int Function<N extends num>(List<N>) funcStd;

  /// The `any` function for a list.
  ///
  /// Added in `2.8`.
  final int Function<E>(List<E>, {required bool? Function(E, E) equality})
  funcAny;

  /// If the algorithm does it in the [list] or creates a `new` one.
  ///
  /// Added in `2.8`.
  final bool isInline;

  /// If the algorithm loses some of its date when processed.
  ///
  /// Added in `2.8.1`.
  final bool losesData;

  const SortAlg({
    required this.funcStd,
    required this.funcAny,
    required this.isInline,
    this.losesData = false,
  });
}

/// Uses [alg]`.`[funcStd]`(`[list]`)`.
///
/// Added in `2.8`.
int inlineSort<N extends num>(List<N> list, {required SortAlg alg}) =>
    alg.funcStd(list);

/// Uses [alg]`.`[funcAny]`(`[list]`, `[greaterThan]`)`.
///
/// Added in `2.8`
int inlineSortAny<E>(
  List<E> list, {
  required SortAlg alg,
  required bool? Function(E, E) equality,
}) => alg.funcAny(list, equality: equality);
