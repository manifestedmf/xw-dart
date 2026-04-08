import 'dart:core'
    show
        int,
        String,
        List,
        StringBuffer,
        ArgumentError,
        bool,
        num,
        Map,
        MapEntry;
import 'file.dart' show SyntaxError;
import '../extension.dart' show StringExt;
import 'json.dart' hide Json;

enum JsonTypes {
  leftBrace(),
  rightBrace(),
  leftBracket(),
  rightBracket(),
  string(),
  number(),
  trueValue(),
  falseValue(),
  nullValue(),
  comma(),
  colon(),
}

/*
final class JsonLoc {
  final int startList;
  final int startPos;
  final int endList;
  final int endPos;
  final JsonTypes type;
  final String? contents;

  const JsonLoc(
    this.startList,
    this.startPos,
    this.endList,
    this.endPos,
    this.type, [
    this.contents,
  ]);
}*/

final class Token {
  final JsonTypes type;
  final String? content;

  const Token(this.type, [this.content]);
}

sealed class State {}

final class JsonScanner {
  final String contents;
  List<Token> tokens = [];

  int index = 0;

  JsonScanner(this.contents) {
    scanJson();
  }

  static List<Token> scan(String contents) => JsonScanner(contents).tokens;

  void scanJson() {
    scanElement();
  }

  void scanElement() {
    scanWs();
    scanValue();
    scanWs();
  }

  void scanWs() {
    switch (tryScanChar()) {
      case " ":
      case "\n":
      case "\r":
      case "\t":
        ++index;
        scanWs();
      case _:
        break;
    }
  }

  void scanValue() {
    String char = scanChar();
    switch (char) {
      case '"':
        scanString();
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
        scanNumber(char);
      case "{":
        scanObject();
      case "[":
        scanArray();
      case "t":
        scanTrue();
      case "f":
        scanFalse();
      case "n":
        scanNull();
    }
  }

  void scanString() {
    ++index;
    StringBuffer buffer = StringBuffer();
    String char = scanChar();
    while (char != '"') {
      switch (char) {
        case r"\":
          ++index;
          char = scanChar();
          switch (char) {
            case r'"':
            case r"\":
            case r"/":
              buffer.write(char);
            case r"b":
              buffer.write("\b");
            case r"f":
              buffer.write("\f");
            case r"n":
              buffer.write("\n");
            case r"r":
              buffer.write("\r");
            case r"t":
              buffer.write("\t");
            case r"u":
              String hex = contents.substring(index + 1, index + 5);
              index += 4;
              buffer.write(String.fromCharCode(int.parse(hex, radix: 16)));
            case String():
              throw SyntaxError(char, index, "Invalid escape");
          }
        case String():
          buffer.write(char);
      }
      ++index;
      char = scanChar();
    }
    tokens.add(Token(.string, buffer.toString()));
    ++index;
  }

  void scanNumber(String char) {
    tokens.add(
      Token(.number, scanInteger(char) + scanFraction() + scanExponent()),
    );
  }

  String scanInteger(String char) {
    if (char == r"-") {
      ++index;
      return char + scanSigned(scanChar());
    } else {
      return scanSigned(char);
    }
  }

  String scanSigned(String char) {
    if (char == r"0") {
      return char;
    } else if (char.isDigit) {
      ++index;
      String c = scanChar();
      if (c.isDigit) {
        return char + scanDigits();
      } else {
        return char;
      }
    } else {
      throw SyntaxError(char, index);
    }
  }

  String scanDigits() {
    String digit = scanDigit();
    if (scanChar().isDigit) {
      return digit + scanDigits();
    } else {
      return digit;
    }
  }

  String scanDigit() {
    String char = scanChar();
    if (char == r"0") {
      ++index;
      return char;
    } else {
      return scanOneNine(char);
    }
  }

  String scanOneNine(String char) {
    ++index;
    switch (char) {
      case "1":
      case "2":
      case "3":
      case "4":
      case "5":
      case "6":
      case "7":
      case "8":
      case "9":
        return char;
      case String():
        throw SyntaxError(char, index - 1, "Invalid one through nine");
    }
  }

  String scanFraction() {
    String char = scanChar();
    if (char != r".") {
      return "";
    } else {
      ++index;
      return char + scanDigits();
    }
  }

  String scanExponent() {
    String char = scanChar();
    if (char != r"e" && char != r"E") {
      return "";
    } else {
      ++index;
      return char + scanSign() + scanDigits();
    }
  }

  String scanSign() {
    String char = scanChar();
    if (char == r"+" || char == r"-") {
      ++index;
      return char;
    } else {
      return "";
    }
  }

  void scanObject() {
    ++index;
    tokens.add(Token(.leftBrace));
    scanWs();
    if (scanChar() == r"}") {
      ++index;
      tokens.add(Token(.rightBrace));
    } else {
      scanMembers();
      ++index;
      tokens.add(Token(.rightBrace));
    }
  }

  void scanMembers() {
    scanMember();
    if (scanChar() == r",") {
      tokens.add(Token(.comma));
      ++index;
      scanMembers();
    }
  }

  void scanMember() {
    scanWs();
    scanString();
    scanWs();
    if (scanChar() != r":") {
      throw SyntaxError(scanChar(), index, "Expected ':'");
    }
    tokens.add(Token(.colon));
    ++index;
    scanElement();
  }

  void scanArray() {
    ++index;
    tokens.add(Token(.leftBracket));
    scanWs();
    if (scanChar() == r"]") {
      ++index;
      tokens.add(Token(.rightBracket));
    } else {
      scanElements();
      ++index;
      tokens.add(Token(.rightBracket));
    }
  }

  void scanElements() {
    scanElement();
    if (scanChar() != r",") {
      return;
    }
    tokens.add(Token(.comma));
    ++index;
    scanElements();
  }

  void scanTrue() {
    ++index;
    String char = scanChar();
    if (char != "r") {
      throw SyntaxError(char, index, "Expected 'r' at index 1 of 'true'");
    }
    ++index;
    char = scanChar();
    if (char != "u") {
      throw SyntaxError(char, index, "Expected 'u' at index 2 of 'true'");
    }
    ++index;
    char = scanChar();
    if (char != "e") {
      throw SyntaxError(char, index, "Expected 'e' at index 3 of 'true'");
    }
    ++index;
    tokens.add(Token(.trueValue));
  }

  void scanFalse() {
    ++index;
    String char = scanChar();
    if (char != "a") {
      throw SyntaxError(char, index, "Expected 'a' at index 1 of 'false'");
    }
    ++index;
    char = scanChar();
    if (char != "l") {
      throw SyntaxError(char, index, "Expected 'l' at index 2 of 'false'");
    }
    ++index;
    char = scanChar();
    if (char != "s") {
      throw SyntaxError(char, index, "Expected 's' at index 3 of 'false'");
    }
    ++index;
    char = scanChar();
    if (char != "e") {
      throw SyntaxError(char, index, "Expected 'e' at index 4 of 'false'");
    }
    ++index;
    tokens.add(Token(.falseValue));
  }

  void scanNull() {
    ++index;
    String char = scanChar();
    if (char != "u") {
      throw SyntaxError(char, index, "Expected 'u' at index 1 of 'null'");
    }
    ++index;
    char = scanChar();
    if (char != "l") {
      throw SyntaxError(char, index, "Expected 'l' at index 2 of 'null'");
    }
    ++index;
    char = scanChar();
    if (char != "l") {
      throw SyntaxError(char, index, "Expected 'l' at index 3 of 'null'");
    }
    ++index;
    tokens.add(Token(.nullValue));
  }

  String scanChar() => contents[index];

  String? tryScanChar() {
    if (index < contents.length) {
      return contents[index];
    }
    return null;
  }
}

final class JsonParser {
  final List<Token> tokens;
  late JsonType contents;

  int index = 0;

  JsonParser(this.tokens) {
    parseJson();
  }

  static JsonType parse(List<Token> tokens) => JsonParser(tokens).contents;

  void parseJson() {
    contents = parseElement();
  }

  JsonType parseElement() {
    Token token = previewToken();
    switch (token.type) {
      case .leftBrace:
        return parseObject();
      case .leftBracket:
        return parseArray();
      case .string:
        return parseString();
      case .number:
        return parseNumber();
      case .trueValue:
        return parseTrue();
      case .falseValue:
        return parseFalse();
      case .nullValue:
        return parseNull();
      case .rightBracket:
        throw SyntaxError("]");
      case .rightBrace:
        throw SyntaxError("}");
      case JsonTypes.comma:
        throw SyntaxError(",");
      case JsonTypes.colon:
        throw SyntaxError(":");
    }
  }

  JsonObject parseObject() {
    parseToken(.leftBrace);
    Token token = previewToken();
    if (token.type == .rightBrace) {
      parseToken(.rightBrace);
      return JsonObject({});
    } else {
      Map<String, JsonType> map = parseMembers();
      parseToken(.rightBrace);
      return JsonObject(map);
    }
  }

  Map<String, JsonType> parseMembers() =>
      Map.fromEntries(parseMembersInternal());

  List<MapEntry<String, JsonType>> parseMembersInternal() {
    List<MapEntry<String, JsonType>> entries = [parseMember()];
    if (previewToken().type == .comma) {
      parseToken(.comma);
      return entries..addAll(parseMembersInternal());
    } else {
      return entries;
    }
  }

  MapEntry<String, JsonType> parseMember() {
    String string = parseToken(.string).content!;
    parseToken(.colon);
    return MapEntry(string, parseElement());
  }

  JsonArray parseArray() {
    parseToken(.leftBracket);
    if (previewToken().type == .rightBracket) {
      parseToken(.rightBracket);
      return JsonArray([]);
    } else {
      List<JsonType> elements = parseElements();
      parseToken(.rightBracket);
      return JsonArray(elements);
    }
  }

  List<JsonType> parseElements() {
    List<JsonType> elements = [parseElement()];
    if (previewToken().type == .comma) {
      parseToken(.comma);
      return elements..addAll(parseElements());
    } else {
      return elements;
    }
  }

  JsonString parseString() => JsonString(parseToken(.string).content!);

  JsonNumber parseNumber() =>
      JsonNumber(num.parse(parseToken(.number).content!));

  JsonBoolean parseTrue() {
    parseToken(.trueValue);
    return JsonBoolean(true);
  }

  JsonBoolean parseFalse() {
    parseToken(.falseValue);
    return JsonBoolean(false);
  }

  JsonNull parseNull() {
    parseToken(.nullValue);
    return JsonNull();
  }

  Token parseToken([JsonTypes? type]) {
    Token token = tokens[index];
    if (type == null || type == token.type) {
      ++index;
      return token;
    }
    throw this;
  }

  Token? tryParseToken([JsonTypes? type]) {
    if (index < tokens.length) {
      Token token = tokens[index];
      if (type == null || type == token.type) {
        ++index;
        return token;
      }
    }
    return null;
  }

  Token previewToken() => tokens[index];

  Token? tryPreviewToken() {
    if (index < tokens.length) {
      return tokens[index];
    }
    return null;
  }
}
