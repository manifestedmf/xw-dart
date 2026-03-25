import 'dart:io' show stdin, systemEncoding;
import 'dart:convert' show Encoding;
export 'dart:convert' show Encoding;

/*class InputError extends Error {
  final Type? expected;
  final dynamic gotten;
  final dynamic message;

  InputError({});
}*/

/// Gets the next inputted line.
///
/// Added in `2.8`.
String getNextString({
  Encoding encoding = systemEncoding,
  bool retainNewlines = false,
}) => stdin.readLineSync(encoding: encoding, retainNewlines: retainNewlines)!;

/// If [forced] is `true`, and the next input is not a [int],
/// then it throws [throwing].
///
/// Added in `2.8`.
int getNextInt({bool forced = false, dynamic throwing}) {
  if (forced) {
    return int.tryParse(getNextString()) ?? (throw throwing);
  } else {
    int? parsed;
    do {
      parsed = int.tryParse(getNextString());
    } while (parsed == null);
    return parsed;
  }
}

/// If [forced] is `true`, and the next input is not a [int],
/// then it throws [throwing].
///
/// Added in `2.8`.
bool getNextBool({
  bool caseSensitive = true,
  bool forced = false,
  dynamic throwing,
}) {
  if (forced) {
    return bool.tryParse(getNextString(), caseSensitive: caseSensitive) ??
        (throw throwing);
  } else {
    bool? parsed;
    do {
      parsed = bool.tryParse(getNextString(), caseSensitive: caseSensitive);
    } while (parsed == null);
    return parsed;
  }
}

/// If [forced] is `true`, and the next input is not a [int],
/// then it throws [throwing].
///
/// Added in `2.8`.
double getNextDouble({bool forced = false, dynamic throwing}) {
  if (forced) {
    return double.tryParse(getNextString()) ?? (throw throwing);
  } else {
    double? parsed;
    do {
      parsed = double.tryParse(getNextString());
    } while (parsed == null);
    return parsed;
  }
}
