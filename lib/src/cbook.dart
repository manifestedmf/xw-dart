import 'extension.dart';
import 'array.dart';
/// [List] of [fahr]-[cels] for Fahrenheit-Celsius table;
///
/// Set start with [lower]; And end with [upper];
///
/// Set the step amount with [step];
///
/// Taken from `SECTION 1.2`, Page `9`;
List<({int fahr, C cels})> fahrToCelsTable<C extends num>({int lower = 0, int upper = 300, int step = 20}) {
  int fahr;
  C cels;
  List<({int fahr, C cels})> table = [];
  fahr = lower;
  while (fahr <= upper) {
    cels = fahrToCels(fahr) as C;
    table.add((fahr: fahr, cels: cels));
    fahr += step;
  }
  return table;
}
/// Gives back the celsius value for the [fahr];
double fahrToCels(num fahr) => 5 * (fahr-32) / 9;

enum _State {
  inside,
  outside
}
/// Count [lines], [whitespaces], and [characters] in [string];
({int lines, int whitespaces, int characters}) stringCount(String string) {
  String c = "";
  int lines, whitespaces, characters;
  _State state;

  state = _State.outside;
  lines = whitespaces = characters = 0;
  for (int index = 0; index < string.length; c = string[++index]) {
    ++characters;
    if (c == "\n") {++lines;}
    if (c.isWhiteSpace) {state = _State.outside;}
    else if (state == _State.outside) {
      state = _State.inside;
      ++whitespaces;
    }
  }
  return (lines: lines, whitespaces: whitespaces, characters: characters);
}

/// Reverse a [List];
void reverse<E>(List<E> list) {
  int i = 0; int j = list.length - 1;
  E first, last;
  for (; i < j; i++, j--) {
    first = list[i]; last = list[j];
    list[i] = last; list[j] = first;
  }
}

/// Reverse a [Array];
void reverseArray<T>(Array<T> array) {
  int i = 0; int j = array.length - 1;
  T first, last;
  for (; i < j; i++, j--) {
    first = array[i]; last = array[j];
    array[i] = last; array[j] = first;
  }
}
