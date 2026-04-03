// ignore_for_file: prefer_final_fields

import 'dart:async';
import 'dart:io' as io show File;
import 'package:xw/core.dart';

import 'file.dart';
import '../extension.dart' show StringExt, MapKV;
import 'dart:convert' show Encoding, Utf8Codec;
import 'json_internal.dart';
export 'dart:convert' show AsciiCodec, Utf8Codec, Latin1Codec;

/// Added in `2.8.1`.
class Json implements File<JsonType, JsonType> {
  late JsonType _json;
  // TODO: make to Json to a async class
  late Stream<List<int>> _contents;
  io.File _file;
  final Encoding encoding;
  late String _string;
  int _pos = 0;
  JsonState _state = JsonState.unknown;
  late List<JsonLoc> _locations;
  String get _char => _string[_pos];
  bool get _isEOF => _pos >= _string.length;
  bool get _isFinished => _isFinishedCompleter.isCompleted;
  Completer<void> _isFinishedCompleter = Completer();

  @override
  final String address;

  Json(this.address, {required this.encoding}) : _file = io.File(address) {
    _contents = _file.openRead();
    _parseJson();
    _json = JsonObject({});
  }

  factory Json.unsafe(String address, {Encoding? encoding}) {
    encoding ??= Utf8Codec();
    return Json(address, encoding: encoding);
  }

  JsonType get json => _json;

  @override
  toString({bool newlines = false}) {
    if (!_isFinished) {
      return "Processing json...";
    } else {
      return _json.toString(newlines: newlines);
    }
  }

  Future<String> toStringAsync({bool newlines = false}) async {
    return _isFinishedCompleter.future.then(
      (_) => toString(newlines: newlines),
    );
  }

  JsonType? operator [](String key) => (_json as JsonObject)[key];

  Future<List<JsonLoc>> _locate() async {
    /// End is the place where the last character is
    int sListPos, sPos, eListPos, ePos, listPos;
    eListPos = ePos = sListPos = sPos = listPos = 0;
    JsonTypes? type = JsonTypes.array;
    String? contents = "";
    await for (List<int> bytes in _contents) {
      _string = encoding.decode(bytes);
      switch (_state) {
        case JsonState.whitespace:
        case JsonState.string:
          // TODO: Handle this case.
          throw UnimplementedError();
        case JsonState.escape:
          // TODO: Handle this case.
          throw UnimplementedError();
        case JsonState.object:
          // TODO: Handle this case.
          throw UnimplementedError();
        case JsonState.array:
          // TODO: Handle this case.
          throw UnimplementedError();
        case JsonState.number:
          // TODO: Handle this case.
          throw UnimplementedError();
        case JsonState.boolean:
          // TODO: Handle this case.
          throw UnimplementedError();
        case JsonState.nullV:
          // TODO: Handle this case.
          throw UnimplementedError();
        case JsonState.unknown:
          type = _findElementEntrance()!;
      }
      sListPos = listPos;
      sPos = _pos;
      var (contents:content, :position) = _findElementExit(type);
      ePos = position!; contents = content;
      eListPos = listPos;
      ++listPos;
      _pos = 0;
    }
    return [JsonLoc(sListPos, sPos, eListPos, ePos, type!, contents)];
  }

  JsonTypes? _findElementEntrance() {
    String? char = _skipWhitespaces();
    if (char == null) {
      return null;
    } else {
      return _getValueType(char) ??
          (throw SyntaxError(char, _pos, "Is not a value start"));
    }
  }

  /// Skips whitespaces.
  ///
  /// Returns the `String` if it skipped all and is now at a non-whitespace.
  ///
  /// Returns `null` if it got to the end before it skipped all whitespaces.
  ///
  /// Added in `2.8.1`.
  String? _skipWhitespaces() {
    if (_pos >= _string.length) {
      return null;
    }
    String char = _char;
    switch (char) {
      case r" ":
      case "\n":
      case "\r":
      case "\t":
        ++_pos;
        return _skipWhitespaces();
      case _:
        return char;
    }
  }

  static JsonTypes? _getValueType(String char) {
    switch (char) {
      case r"{":
        return JsonTypes.object;
      case r"[":
        return JsonTypes.array;
      case r'"':
        return JsonTypes.string;
      case "-":
      case "0":
      case "1":
      case "2":
      case "3":
      case "4":
      case "5":
      case "6":
      case "7":
      case "8":
      case "9":
        return JsonTypes.number;
      case "t":
        return JsonTypes.trueValue;
      case "f":
        return JsonTypes.falseValue;
      case "n":
        return JsonTypes.nullValue;
      case _:
        return null;
    }
  }

  // expects that the given position is at the element so "" would be 1
  // expects that _pos is set to be after the thing so _pos would be 2 in that case
  ({int? position, String? contents}) _findElementExit(JsonTypes type) {
    switch (type) {
      case JsonTypes.object:
        String? char = _skipWhitespaces();
        if (char == null) {
          return (position: null, contents: null);
        } else {
          return (position: null, contents: null);
        }
      case JsonTypes.array:
        return (position: null, contents: null);
      case JsonTypes.string:
        return _findStringExit("");
      case JsonTypes.number:
        String char = _char;
        if (char == r"-") {
          return _findNumberExit(part: 1, contents: char);
        } else if (char == r"0") {
          return _findNumberExit(part: 0, contents: char);
        } else {
          return _findNumberExit(part: 2, contents: char);
        }
      case JsonTypes.trueValue:
        return (position: _findBooleanExit(true), contents: null);
      case JsonTypes.falseValue:
        return (position: _findBooleanExit(false), contents: null);
      case JsonTypes.nullValue:
        return (position: _findNullExit(), contents: null);
    }
  }

  /// [contents], is the in contents of the string including fx `"\r"`,
  /// that needs to be converted, but if the json says `"te"`,
  /// then the return would be `te`.
  ({int? position, String? contents}) _findStringExit(
    String string, [
    bool escaped = false,
  ]) {
    ++_pos;
    if (_pos >= _string.length) {
      return (position: null, contents: null);
    }
    String char = _char;
    if (escaped) {
      switch (char) {
        case '"':
        case r"\":
        case "/":
        case "b":
        case "f":
        case "n":
        case "r":
        case "t":
          return _findStringExit(string + char);
        case "u":
          String? hex = _passHex();
          if (hex == null) {
            return (position: null, contents: string);
          }
          string += hex;
          hex = _passHex();
          if (hex == null) {
            return (position: null, contents: string);
          }
          string += hex;
          hex = _passHex();
          if (hex == null) {
            return (position: null, contents: string);
          }
          string += hex;
          hex = _passHex();
          if (hex == null) {
            return (position: null, contents: string);
          }
          string += hex;
          return _findStringExit(string);
        case _:
          throw SyntaxError(char, _pos, "Not a valid string escape");
      }
    } else {
      switch (char) {
        case r'"':
          return (position: _pos++, contents: string);
        case r"\":
          return _findStringExit(string + char, true);
        case _:
          return _findStringExit(string + char);
      }
    }
  }

  String? _passHex() {
    ++_pos;
    if (_pos >= _string.length) {
      return null;
    }
    String char = _char;
    int.parse(char, radix: 16);
    return char;
  }

  int? _findBooleanExit(
    bool boolean, [
    int position = 0,
  ]) {
    ++_pos;
    if (_pos >= _string.length) {
      return null;
    } else if (boolean) {
      switch (position) {
        case 0:
          if (_char == r"r") {
            return _findBooleanExit(boolean, position + 1);
          } else {
            throw SyntaxError(_char, _pos, "Misspelled \"true\" at 'r'");
          }
        case 1:
          if (_char == r"u") {
            return _findBooleanExit(boolean, position + 1);
          } else {
            throw SyntaxError(_char, _pos, "Misspelled \"true\" at 'u'");
          }
        case 2:
          if (_char == r"e") {
            return _pos++;
          } else {
            throw SyntaxError(_char, _pos, "Misspelled \"true\" at 'e'");
          }
        case _:
          throw RangeError.range(position, 0, 2, "position");
      }
    } else {
      switch (position) {
        case 0:
          if (_char == r"a") {
            return _findBooleanExit(boolean, position + 1);
          } else {
            throw SyntaxError(_char, _pos, "Misspelled \"false\" at 'a'");
          }
        case 1:
          if (_char == r"l") {
            return _findBooleanExit(boolean, position + 1);
          } else {
            throw SyntaxError(_char, _pos, "Misspelled \"false\" at 'l'");
          }
        case 2:
          if (_char == r"s") {
            return _findBooleanExit(boolean, position + 1);
          } else {
            throw SyntaxError(_char, _pos, "Misspelled \"false\" at 's'");
          }
        case 3:
          if (_char == r"e") {
            return _pos++;
          } else {
            throw SyntaxError(_char, _pos, "Misspelled \"false\" at 'e'");
          }
        case _:
          throw RangeError.range(position, 0, 3, "position");
      }
    }
  }

  int? _findNullExit([int position = 0]) {
    ++_pos;
    if (_pos >= _string.length) {
      return null;
    } else {
      switch (position) {
        case 0:
          if (_char == r"u") {
            return _findNullExit(position + 1);
          } else {
            throw SyntaxError(_char, _pos, "Misspelled \"null\" at 'u'");
          }
        case 1:
          if (_char == r"l") {
            return _findNullExit(position + 1);
          } else {
            throw SyntaxError(_char, _pos, "Misspelled \"null\" at index 2");
          }
        case 2:
          if (_char == r"l") {
            return _pos++;
          } else {
            throw SyntaxError(_char, _pos, "Misspelled \"null\" at index 3");
          }
        case _:
          throw RangeError.range(position, 0, 2, "position");
      }
    }
  }

  /// part: 0 is '0'
  ///
  /// part: 1 is '-'
  ///
  /// part: 2 is int
  ///
  /// part: 3 is 'x.'
  ///
  /// part: 4 is 'x.x'
  ///
  /// part: 5 is 'xe' | 'xE'
  ///
  /// part: 6 is 'xe-' | 'xE-' | 'xe+' | 'xE+'
  ///
  /// part: 7 is 'xex' | 'xEx'
  ({int? position, String? contents}) _findNumberExit({required int part, required String contents}) {
    ++_pos;
    if (_pos >= _string.length) {
      return (position: null, contents: contents);
    }
    String char = _char;
    switch (part) {
      case 0:
        switch (char) {
          case ".":
            return _findNumberExit(part: 3, contents: contents + char);
          case "e":
          case "E":
            return _findNumberExit(part: 5, contents: contents + char);
          case " ":
          case "\n":
          case "\t":
          case "\r":
          case ",":
          case "}":
          case "]":
            return (position: _pos - 1, contents: contents);
          case "0":
          case "1":
          case "2":
          case "3":
          case "4":
          case "5":
          case "6":
          case "7":
          case "8":
          case "9":
            throw SyntaxError(
              char,
              _pos,
              "Can't have any number after a single '0'",
            );
          case _:
            throw SyntaxError(char, _pos, "Unexpected char after '0'");
        }
      case 1:
        switch (char) {
          case "0":
            return _findNumberExit(part: 0, contents: contents + char);
          case "1":
          case "2":
          case "3":
          case "4":
          case "5":
          case "6":
          case "7":
          case "8":
          case "9":
            return _findNumberExit(part: 2, contents: contents + char);
          case _:
            throw SyntaxError(char, _pos, "Expected number after '-'");
        }
      case 2:
        switch (char) {
          case "0":
          case "1":
          case "2":
          case "3":
          case "4":
          case "5":
          case "6":
          case "7":
          case "8":
          case "9":
            return _findNumberExit(part: 2, contents: contents + char);
          case ".":
            return _findNumberExit(part: 3, contents: contents + char);
          case "e":
          case "E":
            return _findNumberExit(part: 5, contents: contents + char);
          case ",":
          case " ":
          case "\t":
          case "\n":
          case "\r":
          case "}":
          case "]":
            return (position: _pos - 1, contents: contents);
          case _:
            throw SyntaxError(
              char,
              _pos,
              "Expected number or termination after a digit",
            );
        }
      case 3:
        switch (char) {
          case "0":
          case "1":
          case "2":
          case "3":
          case "4":
          case "5":
          case "6":
          case "7":
          case "8":
          case "9":
            return _findNumberExit(part: 4, contents: contents + char);
          case _:
            throw SyntaxError(char, _pos, "Expected a number after '.'");
        }
      case 4:
        switch (char) {
          case "0":
          case "1":
          case "2":
          case "3":
          case "4":
          case "5":
          case "6":
          case "7":
          case "8":
          case "9":
            return _findNumberExit(part: 4, contents: contents + char);
          case "e":
          case "E":
            return _findNumberExit(part: 5, contents: contents + char);
          case ",":
          case " ":
          case "\t":
          case "\r":
          case "\n":
          case "}":
          case "]":
            return (position: _pos - 1, contents: contents);
          case _:
            throw SyntaxError(
              char,
              _pos,
              "Expected a number or termination after a fraction",
            );
        }
      case 5:
        switch (char) {
          case "0":
          case "1":
          case "2":
          case "3":
          case "4":
          case "5":
          case "6":
          case "7":
          case "8":
          case "9":
            return _findNumberExit(part: 7, contents: contents + char);
          case "-":
          case "+":
            return _findNumberExit(part: 6, contents: contents + char);
          case _:
            throw SyntaxError(
              char,
              _pos,
              "Expected a number or sign after a exponent",
            );
        }
      case 6:
        switch (char) {
          case "0":
          case "1":
          case "2":
          case "3":
          case "4":
          case "5":
          case "6":
          case "7":
          case "8":
          case "9":
            return _findNumberExit(part: 7, contents: contents + char);
          case _:
            throw SyntaxError(
              char,
              _pos,
              "Expected a number after a sign on a exponent",
            );
        }
      case 7:
        switch (char) {
          case "0":
          case "1":
          case "2":
          case "3":
          case "4":
          case "5":
          case "6":
          case "7":
          case "8":
          case "9":
            return _findNumberExit(part: 7, contents: contents + char);
          case ",":
          case " ":
          case "\n":
          case "\t":
          case "\r":
          case "}":
          case "]":
            return (position: _pos - 1, contents: contents);
          case _:
            throw SyntaxError(
              char,
              _pos,
              "Expected a numer or termination after a exponent",
            );
        }
      case _:
        throw RangeError.range(part, 0, 7);
    }
  }

  void _parseJson() async {
    _locations = await _locate();
    _json = _understand();
    _isFinishedCompleter.complete();
    /*await for (List<int> bytes in _contents) {
      _string = encoding.decode(bytes);
      switch (_state) {
        case JsonState.whitespace:
          // TODO: Handle this case.
          throw UnimplementedError();
        case JsonState.string:
          // TODO: Handle this case.
          throw UnimplementedError();
        case JsonState.escape:
          // TODO: Handle this case.
          throw UnimplementedError();
        case JsonState.object:
          // TODO: Handle this case.
          throw UnimplementedError();
        case JsonState.array:
          // TODO: Handle this case.
          throw UnimplementedError();
        case JsonState.number:
          // TODO: Handle this case.
          throw UnimplementedError();
        case JsonState.boolean:
          // TODO: Handle this case.
          throw UnimplementedError();
        case JsonState.nullV:
          // TODO: Handle this case.
          throw UnimplementedError();
        case JsonState.unknown:
          _json = _parseElement();
      }
    }*/
  }

  JsonType _understand() {
    for (JsonLoc loc in _locations) {
      switch (loc.type) {
        case JsonTypes.object:
          // TODO: Handle this case.
          throw UnimplementedError();
        case JsonTypes.array:
          // TODO: Handle this case.
          throw UnimplementedError();
        case JsonTypes.string:
          return JsonString(loc.contents!);
        case JsonTypes.number:
          return JsonNumber(num.parse(loc.contents!));
        case JsonTypes.trueValue:
          return JsonBoolean(true);
        case JsonTypes.falseValue:
          return JsonBoolean(false);
        case JsonTypes.nullValue:
          return JsonNull();
      }
    }
    return JsonString("");
  }

  JsonType _parseElement() {
    _tryParseWhitespace();
    JsonType type = _parseValue();
    _tryParseWhitespace();
    return type;
  }

  bool _tryParseWhitespace() {
    if (_isEOF) {
      return false;
    }
    switch (_char) {
      /*case "":
        _pos++;
        return true;*/
      case " ":
      case "\n":
      case "\r":
      case "\t":
        _pos++;
        _tryParseWhitespace();
        return true;
      case _:
        return false;
    }
  }

  JsonType _parseValue() {
    if (_canParseString) {
      return _parseString();
    } else if (_canParseNumber) {
      return _parseNumber();
    } else if (_isObjectEntry) {
      return _parseObject();
    } else if (_isArrayEntry) {
      return _parseArray();
    } else if (_canParseBoolean) {
      return _parseBoolean();
    } else if (_canParseNull) {
      return _parseNull();
    } else {
      throw SyntaxError(_char, _pos);
    }
  }

  bool get _canParseString => _char == r'"';

  JsonString _parseString() {
    _parseStringContainer();
    /*String string = _parseCharacters();
    _parseStringContainer();
    return JsonString(string);*/
    String string = "";
    String char;
    bool escaped = false;
    while (true) {
      char = _string[_pos++];
      if (!escaped && char == r'"') {
        return JsonString(string);
      } else if (!escaped && char == r"\") {
        escaped = escaped;
      } else if (!escaped) {
        string += char;
        // escaped is now only true
      } else {
        if (char == r'"' || char == r"\" || char == r"/") {
          string += char;
        } else if (char == r"b") {
          string += "\b";
        } else if (char == r"f") {
          string += "\f";
        } else if (char == r"n") {
          string += "\n";
        } else if (char == r"r") {
          string += "\r";
        } else if (char == r"t") {
          string += "\t";
        } else if (char == r"u") {
          string += String.fromCharCode(_parseHex(4));
        }
        escaped = false;
      }
    }
  }

  void _parseStringContainer() {
    if (_canParseString) {
      _pos++;
    } else {
      throw SyntaxError(_char, _pos);
    }
  }

  /*
  String _parseCharacters() {
    if (_contents[_pos++] == "") {
      return "";
    } else {
      return _parseCharacter() + _parseCharacters();
    }
  }

  String _parseCharacter() {
    if (_char)
  }
   */

  int _parseHex(int amount) {
    _pos += amount;
    return int.parse(_string.substring(_pos - amount, _pos), radix: 16);
  }

  bool get _canParseNumber => _isMinus || _isDigit;

  bool get _isMinus => _char == r"-";

  JsonNumber _parseNumber() => JsonNumber(
    num.parse(_parseInteger() + _tryParseFraction() + _tryParseExponent()),
  );

  /*JsonNumber _parseNumber() {
    bool isSigned = false;
    bool zeroFirst = false;
    if (_isMinus) {
      isSigned = true;
      ++_pos;
    } else if (_char == r"0") {
      zeroFirst == true;
    }
    num number = 0;
    String char;
    while (true) {
      char = _contents[_pos++];
      switch
    }
  }*/

  String _parseInteger() {
    String string = "";
    if (_isMinus) {
      string = r"-";
      _pos++;
    }
    if (_isZero) {
      string += "0";
      _pos++;
    } else if (_isDigit) {
      string += _parseDigits();
    } else {
      throw SyntaxError(_char, _pos, "Expected a digit");
    }
    return string;
  }

  bool get _isZero => _char == r"0";

  String _parseDigits() {
    String string = _parseDigit();
    if (_isDigit) {
      string += _parseDigits();
    }
    return string;
  }

  bool get _isDigit => _char.isDigit;

  String _parseDigit() {
    if (_isDigit) {
      return _string[_pos++];
    } else {
      throw SyntaxError(_char, _pos);
    }
  }

  String _tryParseFraction() {
    if (_isEOF) {
      return r"";
    } else if (_char == r".") {
      ++_pos;
      return ".${_parseDigits()}";
    } else {
      return r"";
    }
  }

  String _tryParseExponent() {
    if (_isEOF) {
      return r"";
    } else if (_char == r"e" || _char == r"E") {
      return "e${_tryParseSign()}${_parseDigits()}";
    } else {
      return r"";
    }
  }

  String _tryParseSign() {
    if (_isEOF) {
      return r"";
    } else if (_isMinus || _char == r"+") {
      return _char;
    } else {
      return r"";
    }
  }

  bool get _isObjectEntry => _char == r"{";
  bool get _isObjectExit => _char == r"}";

  JsonObject _parseObject() {
    _parseObjectEntry();
    _tryParseWhitespace();
    if (_isObjectExit) {
      _parseObjectExit();
      return JsonObject({});
    } else {
      Map<String, JsonType> members = _parseMembers();
      _parseObjectExit();
      return JsonObject(members);
    }
  }

  void _parseObjectEntry() {
    if (_isObjectEntry) {
      ++_pos;
    } else {
      throw SyntaxError(_char, _pos);
    }
  }

  void _parseObjectExit() {
    if (_isObjectExit) {
      ++_pos;
    } else {
      throw SyntaxError(_char, _pos);
    }
  }

  Map<String, JsonType> _parseMembers() {
    return Map.fromEntries(_parseMembersPrivate());
  }

  List<MapEntry<String, JsonType>> _parseMembersPrivate() {
    List<MapEntry<String, JsonType>> entries = [_parseMember()];
    if (_isComma) {
      ++_pos;
      entries.addAll(_parseMembersPrivate());
    }
    return entries;
  }

  bool get _isComma => _char == r",";

  MapEntry<String, JsonType> _parseMember() {
    _tryParseWhitespace();
    JsonString string = _parseString();
    _tryParseWhitespace();
    _parseColon();
    return MapEntry(string.value, _parseElement());
  }

  void _parseColon() {
    if (_char == r":") {
      ++_pos;
    } else {
      throw SyntaxError(_char, _pos);
    }
  }

  bool get _isArrayEntry => _char == r"[";
  bool get _isArrayExit => _char == r"]";

  JsonArray _parseArray() {
    _parseArrayEntry();
    _tryParseWhitespace();
    if (_isArrayExit) {
      _parseArrayExit();
      return JsonArray([]);
    } else {
      List<JsonType> elements = _parseElements();
      _parseArrayExit();
      return JsonArray(elements);
    }
  }

  void _parseArrayEntry() {
    if (_isArrayEntry) {
      ++_pos;
    } else {
      throw SyntaxError(_char, _pos);
    }
  }

  void _parseArrayExit() {
    if (_isArrayExit) {
      ++_pos;
    } else {
      throw SyntaxError(_char, _pos);
    }
  }

  List<JsonType> _parseElements() {
    List<JsonType> elements = [_parseElement()];
    if (_isComma) {
      ++_pos;
      elements.addAll(_parseElements());
    }
    return elements;
  }

  bool get _canParseBoolean => _isTrue || _isFalse;
  bool get _isTrue => _char == r"t";
  bool get _isFalse => _char == r"f";

  JsonBoolean _parseBoolean() {
    if (_isTrue) {
      return _parseTrue();
    } else {
      return _parseFalse();
    }
  }

  JsonBoolean _parseTrue() {
    _pos += 4;
    if (_string.substring(_pos - 4, _pos) == r"true") {
      return JsonBoolean(true);
    } else {
      throw SyntaxError(_string.substring(_pos - 4, _pos), _pos - 4);
    }
  }

  JsonBoolean _parseFalse() {
    _pos += 5;
    if (_string.substring(_pos - 5, _pos) == r"false") {
      return JsonBoolean(false);
    } else {
      throw SyntaxError(_string.substring(_pos - 5, _pos), _pos - 5);
    }
  }

  bool get _canParseNull => _char == r"n";

  JsonNull _parseNull() {
    _pos += 4;
    if (_string.substring(_pos - 4, _pos) == r"null") {
      return JsonNull();
    } else {
      throw SyntaxError(_string.substring(_pos - 4, _pos), _pos - 4);
    }
  }
}

/// [I] is `internal`.
///
/// Added in `2.8.1`.
sealed class JsonType<I> {
  /// Added in `2.8.1`.
  const JsonType();

  /// Added in `2.8.1`.
  I get value;

  /// Added in `2.8.1`.
  //set value(I val);

  /// Added in `2.8.1`.
  static JsonType<I> create<I>(I val) {
    if (val is num) {
      return JsonNumber(val) as JsonType<I>;
    } else if (val is String) {
      return JsonString(val) as JsonType<I>;
    } else if (val is bool) {
      return JsonBoolean(val) as JsonType<I>;
    } else if (val is List<JsonType>) {
      return JsonArray(val) as JsonType<I>;
    } else if (val is Map<String, JsonType>) {
      return JsonObject(val) as JsonType<I>;
    } else if (val == null) {
      return JsonNull() as JsonType<I>;
    } else {
      throw ArgumentError.value(val, "val", "No Json type matching that value");
    }
  }

  /// Added in `2.8.1`.
  JsonType<I> copy() => create(value);

  /// Added in `2.8.1`.
  @override
  String toString({bool newlines = false, int spaces = 0}) => value.toString();

  /// Added in `2.8.1`.
  @override
  int get hashCode => value.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JsonType<I> &&
          runtimeType == other.runtimeType &&
          value == other.value;
}

/// Added in `2.8.1`.
final class JsonNumber extends JsonType<num> {
  /// Added in `2.8.1`.
  final num number;

  const JsonNumber(this.number);

  @override
  num get value => number;

  /*@override
  set value(num val) {
    number = val;
  }*/
}

/// Added in `2.8.1`.
final class JsonString extends JsonType<String> {
  final String string;

  const JsonString(this.string);

  @override
  String get value => string;

  /*@override
  set value(String val) {
    string = val;
  }*/

  @override
  String toString({bool newlines = false, int spaces = 0}) => '"$string"';
}

/// Added in `2.8.1`.
final class JsonBoolean extends JsonType<bool> {
  final bool boolean;

  const JsonBoolean(this.boolean);

  @override
  bool get value => boolean;

  /*@override
  set value(bool val) {
    boolean = val;
  }*/
}

/// Added in `2.8.1`.
final class JsonArray extends JsonType<List<JsonType>> {
  final List<JsonType> array;

  const JsonArray(this.array);

  @override
  List<JsonType> get value => array;

  /*@override
  set value(List<JsonType> val) {
    array = val;
  }*/

  @override
  String toString({bool newlines = false, int spaces = 0}) {
    if (!newlines) {
      return array.toString();
    } else {
      if (array.isEmpty) {
        return "[]";
      }
      spaces += 2;
      String string =
          "[\n${" " * spaces}"
          "${array.first.toString(newlines: true, spaces: spaces)}";
      for (int index = 1; index < array.length; index++) {
        string +=
            ",\n"
            "${" " * spaces}"
            "${array[index].toString(newlines: true, spaces: spaces)}";
      }
      return "$string\n${" " * (spaces - 2)}]";
    }
  }

  JsonType operator [](int index) => array[index];
  void operator []=(int index, JsonType type) => array[index] = type;
}

/// Added in `2.8.1`.
final class JsonObject extends JsonType<Map<String, JsonType>> {
  final Map<String, JsonType> object;

  const JsonObject(this.object);

  @override
  Map<String, JsonType> get value => object;

  /*@override
  set value(Map<String, JsonType> val) {
    object = val;
  }*/

  @override
  String toString({bool newlines = false, int spaces = 0}) {
    if (!newlines) {
      String string = "{";
      for (var current in object.entries) {
        string += "\"${current.key}\": ${current.value}";
      }
      return "$string}";
    } else {
      if (object.isEmpty) {
        return "{}";
      }
      spaces += 2;
      String string =
          "{\n${" " * spaces}${object.firstKey}: "
          "${object.firstValue.toString(newlines: true, spaces: spaces)}";
      for (int index = 1; index < object.length; index++) {
        string +=
            ",\n"
            "${" " * spaces}${object.keys.elementAt(index)}: "
            "${object.values.elementAt(index).toString(newlines: true, spaces: spaces)}";
      }
      return "$string\n${" " * (spaces - 2)}}";
    }
  }

  JsonType? operator [](String key) => object[key];
  void operator []=(String key, JsonType value) => object[key] = value;
}

/// Added in `2.8.1`.
final class JsonNull extends JsonType<Null> {
  const JsonNull();

  @override
  Null get value => null;

  /*@override
  set value(Null val) {}*/
}
