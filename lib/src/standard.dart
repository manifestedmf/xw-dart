import 'internal.dart';

/// `true` = [a],
/// `false` = [b],
/// `null` = [c]
@Added("2.6.5","1.0")
V ternaryO<V>(bool? question, V a, V b, V c) {
  if (question == true) {return a;}
  else if (question == false) {return b;}
  else {return c;}
}
/// `true` = [a],
/// `false` = [b],
/// `null` = [c]
@Added("2.6.5", "1.0")
void ternaryI(bool? question, Function() a, [Function()? b, Function()? c]) {
  if (question == true) {a();}
  else if (question == false) {
    if (b != null) {b();}
  }
  else {
    if (c != null) {c();}
  }
}