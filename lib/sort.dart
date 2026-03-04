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

/// Added in `2.8`.
({int swaps, int checks}) bubbleSortAny<E>(
  List<E> list,
  bool Function(E, E) mt,
) => BubbleSort.listSortAny(list, mt);

/// Added in `2.8`.
int mergeSort<N extends num>(List<N> list) => MergeSort.listSort(list);

/// Added in `2.8`.
List<N> mergeList<N extends num>(List<N> a, List<N> b) =>
    MergeSort.listMerge(a, b);

/// [mt] is a MORE THAN function, it should not do MORE THAN OR EQUAL activity,
/// or LESS THAN (OR EQUAL) activity.
///
/// Added in `2.8`.
int mergeSortAny<E>(List<E> list, bool Function(E, E) mt) =>
    MergeSort.listSortAny(list, mt);

/// Added in `2.8`.
List<E> mergeListAny<E>(List<E> a, List<E> b, bool Function(E, E) mt) =>
    MergeSort.listMergeAny(a, b, mt);

/// Added in `2.8.`
int quickSort<N extends num>(List<N> list) => QuickSort.listSort(list);

/// Added in `2.8`.
int quickSortAny<E>(List<E> list, bool Function(E, E) mt) =>
    QuickSort.listSortAny(list, mt);

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
bool isSortedAny<E>(List<E> array, bool Function(E, E) mt) {
  int i = 0;
  while (i + 1 < array.length - 1) {
    if (mt(array[i++], array[i])) {
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
  bubble(funcStd: bubbleSort, funcAny: bubbleSortAny, isInline: true),

  /// Added in `2.8`.
  merge(funcStd: mergeSort, funcAny: mergeSortAny, isInline: true),

  /// Added in `2.8`.
  quick(funcStd: quickSort, funcAny: quickSort, isInline: true);

  /// Standard function for a list.
  ///
  /// Call must be
  /// `int Function<N extends num>(List<N>)` and any optional arguments;
  ///
  /// Added in `2.8`.
  final Function funcStd;

  /// Any function for a list.
  ///
  /// Call must be
  /// `int Function<E>(List<E>, bool Function(E, E))` and any optional arguments.
  ///
  /// Added in `2.8`.
  final Function funcAny;

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

/// Uses [alg]`.`[funcAny]`(`[list]`, `[moreThan]`)`.
///
/// Added in `2.8`
int inlineSortAny<E>(
  List<E> list, {
  required SortAlg alg,
  required bool Function(E, E) moreThan,
}) => alg.funcAny(list, moreThan);
