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
  // TODO: make items not always previewChar() fx scanNumber
  final String contents;
  List<Token> tokens = [];

  int index = 0;

  JsonScanner(this.contents) {
    while (index < contents.length) {
      scanElement();
    }
  }

  static List<Token> scan(String contents) => JsonScanner(contents).tokens;

  void scanItem() {
    switch (previewChar()) {
      case r"{":
        parseChar();
        tokens.add(Token(.leftBrace));
      case r"}":
        parseChar();
        tokens.add(Token(.rightBrace));
      case r"[":
        parseChar();
        tokens.add(Token(.leftBracket));
      case r"]":
        parseChar();
        tokens.add(Token(.rightBracket));
      case r'"':
        scanString();
      case r"0":
      case r"1":
      case r"2":
      case r"3":
      case r"4":
      case r"5":
      case r"6":
      case r"7":
      case r"8":
      case r"9":
      case r"-":
        scanNumber();
      case r"t":
        parseChar();
        parseChar("r");
        parseChar("u");
        parseChar("e");
        tokens.add(Token(.trueValue));
      case r"f":
        parseChar();
        parseChar("a");
        parseChar("l");
        parseChar("s");
        parseChar("e");
        tokens.add(Token(.falseValue));
      case r"n":
        parseChar();
        parseChar("u");
        parseChar("l");
        parseChar("l");
        tokens.add(Token(.nullValue));
      case r":":
        parseChar();
        tokens.add(Token(.colon));
      case r",":
        parseChar();
        tokens.add(Token(.comma));
      case String():
        throw SyntaxError(previewChar(), index, "Invalid starter character");
    }
  }

  void scanElement() {
    scanWs();
    scanItem();
    scanWs();
  }

  void scanWs() {
    if (tryParseChar(" \n\r\t") == null) {
      return;
    } else {
      scanWs();
    }
  }

  void scanNumber() {
    String integer = scanInteger();
    String fraction = scanFraction();
    String exponent = scanExponent();
    tokens.add(Token(.number, integer + fraction + exponent));
  }

  String scanInteger() {
    String char = previewChar();
    if (char == r"-") {
      ++index;
      return char + scanInt();
    } else {
      return scanInt();
    }
  }

  String scanInt() {
    String char = previewChar();
    if (char == r"0") {
      return char;
    } else {
      return scanDigits();
    }
  }

  String scanDigits() {
    String digit = scanDigit();
    StringBuffer digits = StringBuffer(digit);
    String char = previewChar();
    while (char.isDigit) {
      digits.write(char);
      ++index;
      char = previewChar();
    }
    return digits.toString();
  }

  String scanDigit() => parseChar("0123456789");

  String scanFraction() {
    String dot = previewChar();
    if (dot == r".") {
      ++index;
      return dot + scanDigits();
    } else {
      return "";
    }
  }

  String scanExponent() {
    String e = previewChar();
    if (e == r"e" || e == r"E") {
      ++index;
      return e + scanSign() + scanDigits();
    } else {
      return "";
    }
  }

  String scanSign() {
    String sign = previewChar();
    if (sign == r"+" || sign == r"+") {
      return sign;
    } else {
      return "";
    }
  }

  /*void scanInt() {
    String char = parseChar();
    String? testChar;
    StringBuffer buffer = StringBuffer(char);

    /// booleans & 1 (is signed)
    /// booleans & 1 << 1 >> 1 (isFraction)
    /// booleans & 1 << 2 >> 2 (passed .)
    /// booleans & 1 << 3 >> 3 (passed e)
    /// booleans & 1 << 4 >> 4 (passed sign)
    int booleans = 0;
    /*
    bool isSigned() => (booleans & 0x01) == 1;
    void setAsSigned() {
      booleans |= 0x01;
    }*/
    bool isFraction() => ((booleans & 0x02) >> 1) == 1;
    void setAsFraction() {
      booleans |= 0x02;
    }

    bool inDecimals() => ((booleans & 0x04) >> 2) == 1;
    void setInDecimals() {
      booleans |= 0x04;
    }

    bool passedE() => ((booleans & 0x08) >> 3) == 1;
    void setAsPassedE() {
      booleans |= 0x08;
    }

    bool passedSign() => ((booleans & 0x10) >> 4) == 1;
    void setAsPassedSign() {
      booleans |= 0x10;
    }

    if (char == r"-") {
      /*setAsSigned();*/
      char = parseChar();
    }
    if (char == r"0") {
      setAsFraction(); // 2
    }
    while (!inDecimals() && !isFraction() && !passedE()) {
      testChar = tryPreviewChar();
      if (testChar == r".") {
        buffer.write(parseChar());
        setInDecimals();
      } else if (testChar == r"e" || testChar == r"E") {
        buffer.write(parseChar());
        setAsPassedE();
      }
      if (testChar == null || !testChar.isDigit) {
        tokens.add(Token(.number, buffer.toString()));
        return;
      } else {
        buffer.write(parseChar());
      }
    }
  }*/

  void scanString() {
    ++index;
    StringBuffer buffer = StringBuffer();
    String char = previewChar();
    while (char != '"') {
      switch (char) {
        case r"\":
          ++index;
          char = parseChar();
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
              buffer.writeCharCode(int.parse(hex, radix: 16));
            case String():
              throw SyntaxError(char, index, "Invalid escape");
          }
        case String():
          buffer.write(char);
      }
      ++index;
      char = previewChar();
    }
    tokens.add(Token(.string, buffer.toString()));
    ++index;
  }

  String parseChar([String? chars]) =>
      tryParseChar(chars) ??
      (throw SyntaxError(contents[index], index, "Isn't one in \"$chars\""));

  String? tryParseChar([String? chars]) {
    if (index < contents.length) {
      String char = contents[index];
      if (chars == null || chars.contains(char)) {
        ++index;
        return char;
      }
    }
    return null;
  }

  String previewChar() => contents[index];

  String? tryPreviewChar() {
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
      Map<JsonString, JsonType> map = parseMembers();
      parseToken(.rightBrace);
      return JsonObject(map);
    }
  }

  Map<JsonString, JsonType> parseMembers() =>
      Map.fromEntries(parseMembersInternal());

  List<MapEntry<JsonString, JsonType>> parseMembersInternal() {
    List<MapEntry<JsonString, JsonType>> entries = [parseMember()];
    if (previewToken().type == .comma) {
      parseToken(.comma);
      return entries..addAll(parseMembersInternal());
    } else {
      return entries;
    }
  }

  MapEntry<JsonString, JsonType> parseMember() {
    String string = parseToken(.string).content!;
    parseToken(.colon);
    return MapEntry(JsonString(string), parseElement());
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
