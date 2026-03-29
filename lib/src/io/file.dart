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
    return "Unexpected character: '$char'$extra";
  }
}

/// Added in `2.8.1`.
abstract interface class File {
  /*
  /// Should give out `false` if process does not want to write.
  ///
  /// Added in `2.8.1`.
  bool write(String string);
  */

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
  File(String address, {bool protected});
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
