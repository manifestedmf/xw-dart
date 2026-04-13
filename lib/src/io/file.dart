import 'dart:io' as io;

/// Added in `2.8.1`.
class SyntaxError extends Error {
  final String char;
  final int? pos;
  final String? message;

  SyntaxError(this.char, [this.pos, this.message]);

  @override
  toString() {
    String extra = "";
    if (pos != null) {
      extra += " at $pos";
    }
    if (message != null) {
      extra += ": $message";
    }
    return "SyntaxError: '$char'$extra";
  }
}

/// Added in `2.8.1`.
class ParseError extends Error {
  final String section;
  final int? start;
  final int? end;
  final String? message;

  ParseError(this.section, [this.start, this.end, this.message]);

  @override
  toString() {
    String extra = "";
    if (start != null && end != null) {
      extra += " from: $start, to: $end";
    } else if (start != null && end == null) {
      extra += " from: $start";
    } else if (start == null && end != null) {
      extra += " to: $end";
    }
    if (message != null) {
      extra += ": $message";
    }
    return "ParseError: '$section'$extra";
  }
}
/// [I] is `input`,
///
/// [O] is `output` &
///
/// [P] is `position`.
///
/// Added in `2.8.1`.
abstract interface class File<I, O, P> {
  /*
  /// Should give out `false` if process does not want to write.
  ///
  /// Added in `2.8.1`.
  bool write(I input, P position);
  */

  O read(P position);

  /*
  /// Added in `2.8.1`.
  String readAsString([int start = 0, int? end]);
  */

  /*
  /// Returns `true` if the process allows to change the protectedness level.
  ///
  /// Added in `2.8.1`.
  bool protect();
  */

  /// Added in `2.8.1`.
  abstract final String address;

  /*
  /// Added in `2.8.1`.
  abstract bool _protected;
  */

  /*
  File get internal;
  */

  /*
  /// Added in `2.8.1`.
  File(String address, {required Encoding encoding});
  /// Added in `2.8.1`.
  File.unsecure(String address, {Encoding? encoding});
  */
}

/*
class _File implements File {
  @override
  final String address;

  @override
  String readAsString([int start = 0, int? end]) {
    // TODO: implement readAsString
    throw UnimplementedError();
  }

  @override
  bool write(String string) {
    _internal.writeAsStringSync(string);
    return true;
  }

  @override
  bool protect() {
    if (_protected) {
      return false;
    } else {
      return true;
    }
  }

  @override
  bool _protected;

  _File(this.address, {bool protected = false})
    : _internal = io.File(address),
      _protected = protected;

  io.File _internal;

  @override
  _File get internal => this;
}
 */

typedef txt = TextFile;

class TextFile implements File<String, String, int> {
  @override
  final String address;

  TextFile(this.address);
}

class CSV implements TextFile {}

class XML implements File<String, String, int> {}
