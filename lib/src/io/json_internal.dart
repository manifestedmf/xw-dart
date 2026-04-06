import 'dart:core'
    show int, String, List, StringBuffer, ArgumentError, bool, num;
import 'file.dart' show SyntaxError;
import '../extension.dart' show StringExt;


enum JsonTypes {
  objectStart(),
  objectEnd(),
  arrayStart(),
  arrayEnd(),
  string(),
  number(),
  trueValue(),
  falseValue(),
  nullValue(),
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
  /*
  String scanNumber(String char) {
    if (char == r"-") {
      ++index;
      return r"-" + scanAfterMinus(scanChar());
    } else if (char.isDigit) {
      return scanAfterMinus(char);
    } else {
      throw SyntaxError(char, index, "Invalid number");
    }
    /*switch (char) {
      case "-":
        ++index;
        return r"-" + scanSigned();
      case "0":
        return r"0" + scanFraction() + scanExponent();
      case "1":
      case "2":
      case "3":
      case "4":
      case "5":
      case "6":
      case "7":
      case "8":
      case "9":
    }*/
  }

  String scanAfterMinus(String char) {
    if (char == r"0") {
      return r"0" + scanFraction() + scanExponent();
    } else if (char.isDigit) {
      return scanDigits(char) + scanFraction() + scanExponent();
    } else {
      throw SyntaxError(char, index, "Invalid number");
    }
  }

  String scanDigits(String input) {
    ++index;
    String char = scanChar();
    if (char.isDigit) {
      return
    }
  }
  */

  void scanNumber(String char) {
    tokens.add(Token(.number, scanInteger(char) + scanFraction() + scanExponent()));
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
    tokens.add(Token(.objectStart));
    scanWs();
    if (scanChar() == r"}") {
      ++index;
      tokens.add(Token(.objectEnd));
    } else {
      scanMembers();
      ++index;
      tokens.add(Token(.objectEnd));
    }
  }

  void scanMembers() {
    scanMember();
    if (scanChar() == r",") {
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
    ++index;
    scanElement();
  }

  void scanArray() {
    ++index;
    tokens.add(Token(.arrayStart));
    scanWs();
    if (scanChar() == r"]") {
      ++index;
      tokens.add(Token(.arrayEnd));
    } else {
      scanElements();
      ++index;
      tokens.add(Token(.arrayEnd));
    }
  }

  void scanElements() {
    scanElement();
    if (scanChar() != r",") {
      throw SyntaxError(scanChar(), index, "Expected ','");
    }
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

  /*String scanNumber(String char, [bool signed = false]) {
    StringBuffer buffer = StringBuffer();
    buffer.write(char);
    ++index;
    if (char == r"-") {
      buffer.write(scanNumber(scanChar()));
      return buffer.toString();
    } else if (char == r"0") {
      buffer.write(scanFraction(false));
      return buffer.toString();
    } else if (char.isDigit) {
      String? char;
      while (true) {
        char = tryScanChar();
        switch (char) {
          case null:
            return buffer.toString();
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
            buffer.write(char);
          case ".":
          case "e":
          case "E":
            buffer.write(scanFraction(true));
          case String():
            return buffer.toString();
        }
        ++index;
      }
    } else {
      throw ArgumentError.value(char, "char");
    }
  }*/

  String scanChar() => contents[index];

  String? tryScanChar() {
    if (index < contents.length) {
      return contents[index];
    }
    return null;
  }
}
