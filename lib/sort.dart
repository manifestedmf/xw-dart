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
int bubbleSort<N extends num>(List<N> list) => BubbleSort.listSort(list);

/// Added in `2.8`.
int bubbleSortFraction(List<Fraction> list) =>
    BubbleSort.listSortFraction(list);

/// Added in `2.8`.
int bubbleSortAny<E>(List<E> list, bool Function(E, E) mt) =>
    BubbleSort.listSortAny(list, mt);

/// Added in `2.8`.
void mergeSort<N extends num>(List<N> list) => MergeSort.listSort(list);

/// Added in `2.8`.
List<N> mergeList<N extends num>(List<N> a, List<N> b) =>
    MergeSort.listMerge(a, b);

void quickSort<N extends num>(List<N> list) => QuickSort.listSort(list);

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

bool isSorted<N extends num>(List<N> array) {
  int i = 0;
  while (i + 1 < array.length - 1) {
    if (array[i++] > array[i]) {
      return false;
    }
  }
  return true;
}
