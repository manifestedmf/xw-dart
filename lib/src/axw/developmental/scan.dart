import 'dart:io' show File;
import 'dart:convert' show Encoding;
import '../../extension.dart' show StringExt;

enum TokenType {
  initial(true, r"AXW"),
  identifier(false),
  period(true, "."),
  integer(false),
  semicolon(true, ";"),
  equal(true, "="),
  float(false),
  boolean(false),
  string(false);

  final bool isTextUseless;
  final String? alwaysString;
  const TokenType(this.isTextUseless, [this.alwaysString]);

  @override
  toString() => name;
}

final class Token {
  final String? text;
  final TokenType type;

  const Token(this.type, [this.text]);

  @override
  toString() => (text == null) ? '\$$type' : '"$text" \$$type';
}

enum State {
  whitespace(null, {" ", "\n", "\t", "\r"}),
  identifier(.identifier),
  integer(.integer, {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9"}),
  semicolon(.semicolon, {";"}),
  equal(.equal, {"="}),
  period(.period, {"."}),
  t(.identifier, {"t"}),
  tr(.identifier),
  tru(.identifier),
  trueBool(.boolean),
  f(.identifier, {"f"}),
  fa(.identifier),
  fal(.identifier),
  fals(.identifier),
  falseBool(.boolean),
  string(.string);

  final TokenType? type;
  final bool error;
  final Set<String> chars;
  const State(this.type, [this.chars = const {}]) : error = false;
  const State.error() : type = null, error = true, chars = const {};

  @override
  toString() {
    if (error) {
      return "$name(error)";
    } else {
      return "$name[$type]";
    }
  }
}

enum CharType {
  integer("identifier"),
  equal("equal", "="),

  /// semicolon `;`
  sc("semicolon", ";"),
  period("period", "."),
  t("char(t)", "t"),
  r("char(r)", "r"),
  u("char(u)", "u"),
  e("char(e)", "e"),
  f("char(f)", "f"),
  a("char(a)", "a"),
  l("char(l)", "l"),
  s("char(s)", "s"),
  quote("double quote", '"'),
  text("text"),
  ws("whitespace");

  final String title;
  final String? char;

  const CharType(this.title, [this.char]);

  @override
  toString() => (char == null) ? title : "$title{'$char'}";
}

class Scanner {
  //Stream<Token> stream = Stream.empty();
  List<Token> tokens = [];
  String contents;

  int index = 0;
  int start = 0;

  State state = .whitespace;

  Scanner(this.contents);
  static List<Token> scan(String input) {
    Scanner scanner = Scanner(input)..scanContents();
    return scanner.tokens;
  }

  static Future<List<Token>> scanFile(
    String address, {
    required Encoding encoding,
  }) async {
    Scanner scanner = Scanner(
      await File(address).readAsString(encoding: encoding),
    )..scanContents();
    return scanner.tokens;
  }

  void scanContents() {
    String char;
    contents = contents.trimLeft();
    if (contents.substring(0, 3) != r"AXW") {
      throw this;
    } else {
      index += 3;
      tokens.add(Token(.initial, r"AXW"));
    }
    while (index < contents.length) {
      char = contents[index];
      CharType type = character(char);
      switch (type) {
        case CharType.integer:
          // TODO: Handle this case.
          throw UnimplementedError();
        case CharType.equal:
          // TODO: Handle this case.
          throw UnimplementedError();
        case CharType.sc:
          // TODO: Handle this case.
          throw UnimplementedError();
        case CharType.period:
          // TODO: Handle this case.
          throw UnimplementedError();
        case CharType.t:
          // TODO: Handle this case.
          throw UnimplementedError();
        case CharType.r:
          // TODO: Handle this case.
          throw UnimplementedError();
        case CharType.u:
          // TODO: Handle this case.
          throw UnimplementedError();
        case CharType.e:
          // TODO: Handle this case.
          throw UnimplementedError();
        case CharType.f:
          // TODO: Handle this case.
          throw UnimplementedError();
        case CharType.a:
          // TODO: Handle this case.
          throw UnimplementedError();
        case CharType.l:
          // TODO: Handle this case.
          throw UnimplementedError();
        case CharType.s:
          // TODO: Handle this case.
          throw UnimplementedError();
        case CharType.quote:
          // TODO: Handle this case.
          throw UnimplementedError();
        case CharType.text:
          // TODO: Handle this case.
          throw UnimplementedError();
        case CharType.ws:
          if (state == .string)
          flush(.whitespace);
      }
    }
  }

  String get substring => contents.substring(start, index);

  void init(State input) {
    state = input;
    start = index;
  }

  void flush(State input) {
    if (state.error) {
      throw this;
    }
    TokenType? type = state.type;
    if (type != null) {
      tokens.add(Token(type, substring));
    }
    init(input);
  }

  @override
  String toString() =>
      'Scanner{tokens: $tokens, contents: $contents, index: $index, '
      'start: $start, state: $state}';

  static CharType character(String char) => switch (char) {
    "0" => .integer,
    "1" => .integer,
    "2" => .integer,
    "3" => .integer,
    "4" => .integer,
    "5" => .integer,
    "6" => .integer,
    "7" => .integer,
    "8" => .integer,
    "9" => .integer,
    "=" => .equal,
    ";" => .sc,
    "." => .period,
    " " => .ws,
    "\n" => .ws,
    "\r" => .ws,
    "\t" => .ws,
    "t" => .t,
    "r" => .r,
    "u" => .u,
    "e" => .e,
    "f" => .f,
    "a" => .a,
    "l" => .l,
    "s" => .s,
    String() => .text,
  };
}
