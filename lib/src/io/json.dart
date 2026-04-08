// ignore_for_file: prefer_final_fields

import 'dart:async';
import 'dart:io' as io show File;
import 'package:xw/core.dart';

import 'file.dart';
import '../extension.dart' show StringExt, MapKV;
import 'dart:convert' show Encoding, utf8;
import 'json_internal.dart';

/// Added in `2.8.1`.
class Json implements File<JsonType, JsonType> {
  late JsonType _json;
  // TODO: make to Json to a async class
  //late Stream<List<int>> _contents;
  late String _contents;
  io.File _file;
  final Encoding encoding;
  //late String _string;
  int _pos = 0;
  /*String get _char => _string[_pos];
  bool get _isEOF => _pos >= _string.length;*/
  bool get _isFinished => _isFinishedCompleter.isCompleted;
  Completer<void> _isFinishedCompleter = Completer();

  @override
  final String address;

  Json(this.address, {required this.encoding}) : _file = io.File(address) {
    _contents = _file.readAsStringSync(encoding: encoding);
    List<Token> tokens = JsonScanner.scan(_contents);
    _json = JsonParser.parse(tokens);
    _isFinishedCompleter.complete();
  }

  factory Json.unsafe(String address, {Encoding encoding = utf8}) =>
      Json(address, encoding: encoding);

  //JsonType get json => _json;

  @override
  toString({bool newlines = false}) {
    if (!_isFinished) {
      return "Json('$address')";
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
      List<MapEntry<String, JsonType>> entries = object.entries.toList();
      String string = "{";
      MapEntry<String, JsonType> entry;
      if (entries.isNotEmpty) {
        entry = entries[0];
        string += "\"${entry.key}\": ${entry.value}";
      }
      for (int index = 1; index < entries.length; index++) {
        entry = entries[index];
        string += ", \"${entry.key}\": ${entry.value}";
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
