import 'dart:io' as io show File;
import 'file.dart';
import '../extension.dart' show StringExt, MapKV;
import 'dart:convert' show Encoding;
export 'dart:convert' hide Encoding;

/// Added in `2.8.1`.
class Json implements File {
  late JsonType _json;
  // TODO: make to Json to a async class
  //late Stream<List<int>> _contents;
  late String _contents;
  io.File _file;
  Encoding encoding;
  // late String _tempString;
  int _pos = 0;
  String get _char => _contents[_pos];
  bool get _isEOF => _pos >= _contents.length;

  @override
  final String address;

  Json(this.address, {required this.encoding}) : _file = io.File(address) {
    _contents = _file.readAsStringSync(encoding: encoding);
    _json = _parseJson();
  }

  JsonType get json => _json;

  @override
  toString({bool newlines = false}) => _json.toString(newlines: newlines);

  JsonType? operator [](String key) => (_json as JsonObject)[key];

  JsonType _parseJson() => _parseElement();

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
      char = _contents[_pos++];
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
    return int.parse(_contents.substring(_pos - amount, _pos), radix: 16);
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
      return _contents[_pos++];
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
    if (_contents.substring(_pos - 4, _pos) == r"true") {
      return JsonBoolean(true);
    } else {
      throw SyntaxError(_contents.substring(_pos - 4, _pos), _pos - 4);
    }
  }

  JsonBoolean _parseFalse() {
    _pos += 5;
    if (_contents.substring(_pos - 5, _pos) == r"false") {
      return JsonBoolean(false);
    } else {
      throw SyntaxError(_contents.substring(_pos - 5, _pos), _pos - 5);
    }
  }

  bool get _canParseNull => _char == r"n";

  JsonNull _parseNull() {
    _pos += 4;
    if (_contents.substring(_pos - 4, _pos) == r"null") {
      return JsonNull();
    } else {
      throw SyntaxError(_contents.substring(_pos - 4, _pos), _pos - 4);
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
