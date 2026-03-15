/// `for (i in range(e, s, f))`.
///
/// Added in `2.8`.
Iterable<int> range(int end, [int start = 0, int steps = 1]) {
  List<int> iterable = [];
  while (start < end) {
    iterable.add(start);
    start += steps;
  }
  return iterable;
}
