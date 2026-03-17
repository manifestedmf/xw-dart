part of 'numbers.dart';

/// Added in `2.8`.
class Int implements Num {
  final int _internal;

  const Int(this._internal);

  @override
  String toString() => _internal.toString();

  @override
  Int parse(String text) => Int(int.parse(text));

  @override
  Int? tryParse(String text) {
    int? parsed = int.tryParse(text);
    if (parsed == null) {
      return null;
    } else {
      return Int(parsed);
    }
  }
}