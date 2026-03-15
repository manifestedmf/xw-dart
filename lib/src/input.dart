import 'dart:io' show stdin, systemEncoding;
import 'dart:convert' show Encoding;

/// Gets the next inputted line.
///
/// Added in `2.8`.
String getNextString({
  Encoding encoding = systemEncoding,
  bool retainNewlines = false,
}) => stdin.readLineSync(encoding: encoding, retainNewlines: retainNewlines)!;

/// Added in `2.8`.
int getNextInt() {
  int? parsed;
  do {
    parsed = int.tryParse(getNextString());
  } while (parsed == null);
  return parsed;
}

/// Added in `2.8`.
bool getNextBool({bool caseSensitive = true}) {
  bool? parsed;
  do {
    parsed = bool.tryParse(getNextString(), caseSensitive: caseSensitive);
  } while (parsed == null);
  return parsed;
}
