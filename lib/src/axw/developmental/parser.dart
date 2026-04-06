import 'package:xw/src/io/file.dart' show SyntaxError, ParseError;
import 'dart:core' hide Type;
import '../../mixins.dart' show Compare;
import 'ast.dart';
import 'scan.dart';
import '../../extension.dart' show StringExt;

enum Version with Compare<Version> {
  axw10("AXW1.0", "AXW1");

  final String tag;
  final String? otherTag;
  const Version(this.tag, [this.otherTag]);
  static Version parse(String text) {
    for (Version version in values) {
      if (version.tag == text || version.otherTag == text) {
        return version;
      }
    }
    throw ArgumentError.value(text, "text", "Invalid version");
  }

  @override
  bool operator <(Version other) => index < other.index;
}

final class Parser {
  final List<Token> tokens;
  late final Version version;

  int index = 0;

  Parser(this.tokens);

  static AXW parse(List<Token> tokens) => Parser(tokens).parseAXW();

  AXW parseAXW() {
    Header header = parseHeader();
    version = header.version;
    List<Declaration> declarations = parseDeclarations();
    return AXW(header, declarations);
  }

  Header parseHeader() {
    String init = parseInitial();
    Version version = Version.parse(init);
    return Header(version);
  }

  String parseInitial() {
    Token init = parseToken(.initial);
    Token token = parseToken();
    switch (token.type) {
      case .integer:
      case .float:
        parseToken(.semicolon);
      case _:
        throw this;
    }
    return r"AXW" + token.text!;
  }

  List<Declaration> parseDeclarations() {
    List<Declaration> declarations = [];
    Token? token;
    do {
      token = tryPreviewToken();
      if (token == null) {
        return declarations;
      } else if (token.type == TokenType.identifier) {
        declarations.add(parseDeclaration());
      } else {
        throw SyntaxError(token.text ?? token.type.alwaysString!, index);
      }
    } while (true);
  }

  Declaration parseDeclaration() {
    Id id = parseIdentifier();
    if (isToken(TokenType.identifier)) {
      Id identifier = parseIdentifier();
      parseToken(TokenType.equal);
      Type type = typeIdentifier(id);
      TypeExpr expression = parseTypeExpression(type);
      parseToken(TokenType.semicolon);
      return TypeDecl(type, identifier, expression);
    } else {
      parseToken(TokenType.equal);
      Expr expression = parseExpression();
      parseToken(TokenType.semicolon);
      return Declaration(id, expression);
    }
  }

  Expr parseExpression() {
    Token token = parseToken();
    switch (token.type) {
      case TokenType.string:
        return StrExpr(StringExt.parse(token.text!));
      case TokenType.integer:
        return IntExpr(int.parse(token.text!));
      case TokenType.boolean:
        return BoolExpr(bool.parse(token.text!));
      case _:
        throw this;
    }
  }

  Type typeIdentifier(Id identifier) => switch (identifier.identity) {
    "string" => Type.string,
    "int" => Type.int,
    String() => throw ArgumentError.value(
      identifier.toString(),
      "identifier",
      "not a type identifier",
    ),
  };

  TypeExpr parseTypeExpression(Type type) => switch (type) {
    Type.string => STE(parseToken(.string).text!),
    Type.int => ITE(int.parse(parseToken(.integer).text!)),
    Type.bool => BTE(bool.parse(parseToken(.boolean).text!)),
  };

  Id parseIdentifier() {
    Token token = parseToken(.identifier);

    return Id(token.text!);
  }

  Token parseToken([TokenType? type]) =>
      tryParseToken(type) ??
      (throw ArgumentError.value(type.toString(), "type"));

  Token? tryParseToken([TokenType? type]) {
    if (index < tokens.length) {
      Token token = tokens[index];
      if (type == null || type == token.type) {
        ++index;
        return token;
      }
    }
    return null;
  }

  bool isToken(TokenType type) => previewToken().type == type;

  Token previewToken() =>
      tryPreviewToken() ?? (throw RangeError.index(index, tokens));

  Token? tryPreviewToken() {
    if (index < tokens.length) {
      return tokens[index];
    }
    return null;
  }
}
