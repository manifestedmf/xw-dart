import 'package:xw/src/io/file.dart' show SyntaxError;

import '../../mixins.dart' show Compare;
import 'ast.dart';
import 'scan.dart';

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
    String ver = parseToken(TokenType.identifier).text!;
    if (isNextToken(TokenType.period)) {
      parseToken();
      ver += ".${parseToken(TokenType.integer).text!}";
    }
    parseToken(TokenType.semicolon);
    Version version = Version.parse(ver);
    return Header(version);
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
    Identifier identifier = parseIdentifier();
  }



  Identifier parseIdentifier() {
    Token token = parseToken(TokenType.identifier);

    return Identifier(token.text!);
  }

  Token parseToken([TokenType? type]) =>
      tryParseToken(type) ?? (throw ArgumentError.value(type, "type"));

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

  bool isNextToken(TokenType type) => previewToken().type == type;

  Token previewToken() => tryPreviewToken() ?? (throw RangeError.index(index, tokens));

  Token? tryPreviewToken() {
    if (index < tokens.length) {
      return tokens[index];
    }
    return null;
  }
}
