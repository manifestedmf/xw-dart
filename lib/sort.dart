/// Added in `2.7.4`.
library;

import 'src/math/fraction.dart';
import 'src/sort/bubblesort.dart';
import 'src/sort/mergesort.dart';


/// Sorts using the [BubbleSort] method.
///
/// Goes through each index to the next,
/// does nothing if next is more than current index;
/// Swaps if next is less than current index.
///
/// Added in `2.7.4`.
int bubbleSort<N extends num>(List<N> list) => BubbleSort.listSort(list);
/// Added in `2.7.4`.
int bubbleSortFraction(List<Fraction> list) =>
    BubbleSort.listSortFraction(list);

/// Added in `2.7.4`.
void mergeSort<N extends num>(List<N> list) => MergeSort.listSort(list);
/// Added in `2.7.4`.
List<N> mergeList<N extends num>(List<N> a, List<N> b) =>
    MergeSort.listMerge(a, b);
