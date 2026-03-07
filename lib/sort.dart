/// Added in `2.8`.
library;

import 'src/math/fraction.dart';
import 'src/sort/bubblesort.dart';
import 'src/sort/mergesort.dart';
import 'src/sort/quicksort.dart';

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

/// [gt] is short for `>`.
///
/// [eq] is short for `==`.
///
/// Added in `2.8`.
({int swaps, int checks}) bubbleSortAny<E>(
  List<E> list, {
  required bool Function(E, E) gt,
  bool Function(E, E)? eq,
}) => BubbleSort.listSortAny(list, gt);

/// Added in `2.8`.
int _bubbleSort<N extends num>(List<N> list) => bubbleSort(list).checks;

/// Added in `2.8`.
int _bubbleSortAny<E>(
  List<E> list, {
  required bool Function(E, E) gt,
  bool Function(E, E)? eq,
}) => bubbleSortAny(list, gt: gt).checks;

/// Added in `2.8`.
int mergeSort<N extends num>(List<N> list) => MergeSort.listSort(list);

/// Added in `2.8`.
List<N> mergeList<N extends num>(List<N> a, List<N> b) =>
    MergeSort.listMerge(a, b);

/// [gt] is short for `>`.
///
/// [eq] is short for `==`.
///
/// Added in `2.8`.
int mergeSortAny<E>(
  List<E> list, {
  required bool Function(E, E) gt,
  bool Function(E, E)? eq,
}) => MergeSort.listSortAny(list, gt);

/// [gt] is short for `>`.
///
/// Added in `2.8`.
List<E> mergeListAny<E>(
  List<E> a,
  List<E> b, {
  required bool Function(E, E) gt,
}) => MergeSort.listMergeAny(a, b, gt);

/// Added in `2.8.`
int quickSort<N extends num>(List<N> list) => QuickSort.listSort(list);

/// [gt] is short for `>`.
///
/// [eq] is short for `==`.
///
/// Added in `2.8`.
int quickSortAny<E>(
  List<E> list, {
  required bool Function(E, E) gt,
  bool Function(E, E)? eq,
}) => QuickSort.listSortAny(list, gt);

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
bool isSortedAny<E>(List<E> array, bool Function(E, E) gt) {
  int i = 0;
  while (i + 1 < array.length - 1) {
    if (gt(array[i++], array[i])) {
      return false;
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
  quick(funcStd: quickSort, funcAny: quickSortAny, isInline: true);

  /// Standard function for a list.
  ///
  /// Call must be
  /// `int Function<N extends num>(List<N>)` and any optional arguments;
  ///
  /// Added in `2.8`.
  final int Function<N extends num>(List<N>) funcStd;

  /// Any function for a list.
  ///
  /// Call must be
  /// `int Function<E>(List<E>, {required bool Function(E, E) gt,
  /// bool Function(E, E)? eq})` and any optional arguments.
  ///
  /// Added in `2.8`.
  final int Function<E>(
    List<E>, {
    required bool Function(E, E) gt,
    bool Function(E, E)? eq,
  })
  funcAny;

  /// If the algorithm does it in the [list] or creates a `new` one.
  ///
  /// Added in `2.8`.
  final bool isInline;
  const SortAlg({
    required this.funcStd,
    required this.funcAny,
    required this.isInline,
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
  required bool Function(E, E) greaterThan,
  bool Function(E, E)? equalTo,
}) => alg.funcAny(list, gt: greaterThan, eq: equalTo);
