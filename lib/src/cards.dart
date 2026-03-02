import 'standard.dart';

enum CRank {
  ace(
    value: 1,
    title: "Ace",
  ),
  two(
    value: 2,
    title: "Two",
  ),
  three(
    value: 3,
    title: "Three",
  ),
  four(
    value: 4,
    title: "Four",
  ),
  five(
    value: 5,
    title: "Five",
  ),
  six(
    value: 6,
    title: "Six",
  ),
  seven(
    value: 7,
    title: "Seven",
  ),
  eight(
    value: 8,
    title: "Eight",
  ),
  nine(
    value: 9,
    title: "Nine",
  ),
  ten(
    value: 10,
    title: "Ten",
  ),
  jack(
    value: 11,
    title: "Jack",
  ),
  queen(
    value: 12,
    title: "Queen",
  ),
  king(
    value: 13,
    title: "King",
  ),
  ;
  final int value;
  final String title;
  const CRank({
    required this.value,
    required this.title,
  });
  static CRank valued(int value) {
    value = wrapper(lowest: 1, highest: 13, value: value);
    for (CRank current in values) {
      if (current.value == value) {
        return current;
      }
    }
    throw CRank;
  }
}

enum CType {
  heart(),
  club(),
  spade(),
  clover(),
}
