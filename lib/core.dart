/// a library package intended to give the most-used elements of XW;
library;

export 'math.dart';
export 'date.dart' hide hAdder;
export 'mixins.dart';
export 'extension.dart';
export 'standard.dart';

class UnexpectedError extends Error {
  final Object? message;

  UnexpectedError([this.message]);
}