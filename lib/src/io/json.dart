import 'dart:io' as io show File;
import 'file.dart';
import '../extension.dart' show StringExt;
import 'dart:convert' show Encoding;
export 'dart:convert';

/// Added in `2.8.1`.
class Json implements File {
  late Map<String, JsonType> _json;
  // TODO: make to Json to a async class
  //late Stream<List<int>> _contents;
  late String _contents;
  io.File _file;
  Encoding encoding;
  // late String _tempString;
  int _pos = 0;
  String get _char => _contents[_pos];

  @override
  final String address;

  Json(this.address, {required this.encoding}) : _file = io.File(address) {
    _contents = _file.readAsStringSync(encoding: encoding);
    _json = {};
    _parseJson();
  }

  void _parseJson() {
    _parseElement();
  }

  void _parseElement() {
    _tryParseWhitespace();
    _parseValue();
    _tryParseWhitespace();
  }

  bool _tryParseWhitespace() {
    switch (_char) {
      /*case "":
        _pos++;
        return true;*/
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

  void _parseValue() {
    _tryParseWhitespace();
    if (_canParseString) {
      _parseString();
    } else if (_canParseNumber) {
      _parseNumber();
    } else if (_isObjectEntry) {
      _parseObject();
    }
    _tryParseWhitespace();
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
    String string;
    if (_isMinus) {
      string = r"-";
      _pos++;
    }
    if (_isOneNine) {
      string = _parseOneNine() + _parseDigits();
    } else if (_isDigit) {
      string = _parseDigit();
    } else {
      throw SyntaxError(_char, _pos, "Expected a digit");
    }
    return string;
  }

  bool get _isOneNine => _isDigit && _char != r"0";

  String _parseOneNine() {
    if (_isOneNine) {
      return _contents[_pos++];
    } else {
      throw SyntaxError(_char, _pos);
    }
  }

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
      return _char;
    } else {
      throw SyntaxError(_char, _pos);
    }
  }

  String _tryParseFraction() {
    if (_char == r".") {
      ++_pos;
      return ".${_parseDigits()}";
    } else {
      return r"";
    }
  }

  String _tryParseExponent() {
    if (_char == r"e" || _char == r"E") {
      return "e${_tryParseSign()}${_parseDigits()}";
    } else {
      return r"";
    }
  }

  String _tryParseSign() {
    if (_isMinus || _char == r"+") {
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
    if (_isObjectExit)
  }

  void _parseObjectEntry() {
    if (_isObjectEntry) {
      ++_pos;
    } else {
      throw SyntaxError(_char, _pos);
    }
  }
}

/// [I] is `internal`.
///
/// Added in `2.8.1`.
sealed class JsonType<I> {
  /// Added in `2.8.1`.
  JsonType();

  /// Added in `2.8.1`.
  I get value;
  /// Added in `2.8.1`.
  set value(I val);
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
}

/// Added in `2.8.1`.
final class JsonNumber extends JsonType<num> {
  /// Added in `2.8.1`.
  num number;

  JsonNumber(this.number);

  @override
  num get value => number;
  @override
  set value(num val) {
    number = val;
  }

  @override
  String toString() => number.toString();
}

/// Added in `2.8.1`.
final class JsonString extends JsonType<String> {
  String string;

  JsonString(this.string);

  @override
  String get value => string;

  @override
  set value(String val) {
    string = val;
  }

  @override
  String toString() => '"$string"';
}

/// Added in `2.8.1`.
final class JsonBoolean extends JsonType<bool> {
  bool boolean;

  JsonBoolean(this.boolean);

  @override
  bool get value => boolean;

  @override
  set value(bool val) {
    boolean = val;
  }

  @override
  String toString() => boolean.toString();
}

/// Added in `2.8.1`.
final class JsonArray extends JsonType<List<JsonType>> {
  List<JsonType> array;

  JsonArray(this.array);

  @override
  List<JsonType> get value => array;

  @override
  set value(List<JsonType> val) {
    array = val;
  }

  @override
  String toString() => array.toString();
}

/// Added in `2.8.1`.
final class JsonObject extends JsonType<Map<String, JsonType>> {
  Map<String, JsonType> object;

  JsonObject(this.object);

  @override
  Map<String, JsonType> get value => object;

  @override
  set value(Map<String, JsonType> val) {
    object = val;
  }

  @override
  String toString() => object.toString();
}

/// Added in `2.8.1`.
final class JsonNull extends JsonType<Null> {
  JsonNull();

  @override
  Null get value => null;

  @override
  set value(Null val) {}

  @override
  String toString() => "null";
}
