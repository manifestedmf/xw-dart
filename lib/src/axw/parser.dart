// ignore_for_file: constant_identifier_names

import '../mixins.dart';
import '../../math.dart';
import 'ast.dart';
import 'scan.dart';


enum Version with Compare<Version> {
  AXW10("AXW1.0","AXW1"),
  AXW11("AXW1.1"),
  AXW12("AXW1.2"),
  AXW13("AXW1.3"),
  AXW14("AXW1.4"),
  AXW20("AXW2.0","AXW2"),
  AXW21("AXW2.1"),
  ;
  final String tag;
  final String? otherTag;
  const Version(this.tag,[this.otherTag]);
  static Version parse(String text) {
    for (Version version in values) {
      if (version.tag == text) {return version;}
    }
    throw "unknown version $text";
  }
  @override
  bool operator <(Version other) => index < other.index;
}

/// comments for methods in this class is
///
/// ()* for 0 or more
///
/// ()+ for 1 or more
///
/// ()? for 0 or 1
///
/// | for or
///
/// & for and (already presumed)
class Parser {
  final List<Token> tokens;
  late final Version version;

  int index = 0;

  Parser(this.tokens);
  static Manager parse(List<Token> tokens) {
    Parser parser = Parser(tokens);
    return parser.parseManager();
  }

  /// grammar:
  ///
  /// [Header]
  ///
  /// [Declaration]*
  Manager parseManager() {
    Header header = parseHeader();
    version = header.version;
    // version = Version.parse(header.version);
    List<Declaration> declarations = [];
    while (index < tokens.length) {
      declarations.add(parseDeclaration());
    }
    return Manager(header,declarations);
  }

  /// grammar:
  ///
  /// `Magic`[Identifier] ( `.` [int] )? `;`
  ///
  /// should not allow for "AXW2 . 0;" to be true
  Header parseHeader() {
    String text = parseToken(TokenType.identifier).text;
    if (isNextToken(TokenType.period)) {
      parseToken();
      text += ".${parseToken(TokenType.integer).text}";
    }
    parseToken(TokenType.semicolon);
    Version version = Version.parse(text);
    return Header(version);
    // Identifier identifier = parseIdentifier();
    // parseToken(TokenType.semicolon);
    // return Header(identifier);
  }

  /// grammar:
  ///
  /// [text]
  Identifier parseIdentifier() {
    Token token = parseToken(TokenType.identifier);
    return Identifier(token.text);
  }

  /// grammar:
  ///
  /// [Identifier] `=` [Expression] `;`
  ///
  /// | `Struct` [Identifier] `{`
  ///
  /// [StructFieldDeclaration]*
  ///
  /// `};`
  ///
  /// | `enum` [Identifier] `{`
  ///
  /// [EnumFieldDeclaration]
  ///
  /// ( `,` [EnumFieldDeclaration]* ) `};`
  Declaration parseDeclaration() {
    Identifier identifier = parseIdentifier();
    if (identifier.name == "Struct") {
      return parseStructDeclaration();
    }
    else if (identifier.name == "enum" && version >= Version.AXW20) {
      return parseEnumDeclaration();
    }
    else {
      return parseExpressionDeclaration(identifier);
    }
  }

  /// grammar:
  ///
  /// [Identifier] `=` [Expression] `;`
  ExpressionDeclaration parseExpressionDeclaration(Identifier identifier) {
    parseToken(TokenType.equal);
    Token token = previewToken();
    Expression expression;
    if (token.type == TokenType.semicolon) {expression = VoidExp();}
    else {expression = parseExpression();}
    parseToken(TokenType.semicolon);
    return ExpressionDeclaration(identifier, expression);
  }

  /// grammar:
  ///
  /// `Struct` [Identifier] `{`
  ///
  /// [StructFieldDeclaration]*
  ///
  /// `};`
  StructDeclaration parseStructDeclaration() {
    Identifier identifier = parseIdentifier();
    List<StructFieldDeclaration> fields = [];
    parseToken(TokenType.leftBrace);
    while (previewToken().type != TokenType.rightBrace) {
      fields.add(parseStructField());
    }
    parseToken(TokenType.rightBrace);
    parseToken(TokenType.semicolon);
    return StructDeclaration(identifier, fields);
  }

  /// grammar:
  ///
  /// [Identifier] ( `=` [Expression] )? `;`
  StructFieldDeclaration parseStructField() {
    Identifier identifier = parseIdentifier();
    Expression? expression;
    Token token = previewToken();
    if (token.type == TokenType.equal) {
      parseToken(TokenType.equal);
      expression = parseExpression();
    }
    parseToken(TokenType.semicolon);
    return StructFieldDeclaration(identifier, expression);
  }

  /// grammar:
  ///
  /// `enum` [Identifier] `{`
  ///
  /// [EnumFieldDeclaration]
  ///
  /// ( `,` [EnumFieldDeclaration] )*
  ///
  /// `};`
  EnumDeclaration parseEnumDeclaration() {
    Identifier identifier = parseIdentifier();
    List<EnumFieldDeclaration> fields = [];
    parseToken(TokenType.leftBrace);
    fields.add(parseEnumField());
    while (previewToken().type == TokenType.comma) {
      parseToken(TokenType.comma);
      fields.add(parseEnumField());
    }
    parseToken(TokenType.rightBrace);
    parseToken(TokenType.semicolon);
    return EnumDeclaration(identifier,fields);
  }

  /// grammar:
  ///
  /// [Identifier]
  EnumFieldDeclaration parseEnumField() {
    Identifier identifier = parseIdentifier();
    return EnumFieldDeclaration(identifier);
  }

  /// grammar:
  ///
  /// [IntegerExp]
  ///
  /// | [HexadecimalExp]
  ///
  /// | [BinaryExp]
  ///
  /// | [FloatExp]
  ///
  /// | [StringExp]
  ///
  /// | [CharExp]
  ///
  /// | [ListExp]
  ///
  /// | [DictExp]
  Expression parseExpression() {
    Token token = parseToken();
    String text = token.text;
    switch (token.type) {
      case TokenType.integer:
        return IntegerExp(int.parse(text));
      case TokenType.hexadecimal:
        if (text.length <= 2) {throw IncompleteToken("hexadecimal cannot be just be 0x");}
        return HexadecimalExp(text.substring(2));
      case TokenType.binary:
        if (text.length <= 2) {throw IncompleteToken("binary cannot be just be 0n");}
        return BinaryExp(text.substring(2));
      case TokenType.float:
        int position = text.indexOf('.');
        String integerText = text.substring(0,position) + text.substring(position+1);
        int integer = int.parse(integerText);
        int denominator = pow(10,text.substring(position+1).length).toInt();
        return FloatExp(Fraction.compressed(integer,denominator));
      case TokenType.string:
        return StringExp(text.substring(1,text.length-1));
      case TokenType.char:
        return CharExp(text.substring(1,text.length-1));
      case TokenType.leftBrace:
        return parseDictRest();
      case TokenType.leftBracket:
        return parseListRest();
      case TokenType.identifier:
        return VarExp(text);
      case TokenType.none:
        return VoidExp();
      case TokenType.bool:
        return BoolExp(bool.parse(text));
      case _:
        throw "expected expression got ${token.type}";
    }
  }

  /// grammar:
  ///
  /// [[] ( [Expression] ( `,` [Expression] )* )? `]`
  ListExp parseListRest() { // already consumed [
    List<Expression> list = [];
    Token token = previewToken();
    while (token.type != TokenType.rightBracket) { // != ]
      list.add(parseExpression());
      token = previewToken();
      if (token.type == TokenType.comma) {
        index++;
      }
      else if (token.type != TokenType.rightBracket) {
        throw "expected ',' or ']' after $token";
      }
    }
    index++;
    return ListExp(list);
  }

  /// grammar:
  ///
  /// `{` ( [Identifier] `:` [Expression]
  ///
  /// ( `,` [Identifier] `:` [Expression] )* )? `}`
  DictExp parseDictRest() { // already consumed {
    Map<Identifier,Expression> dict = {};
    Token token = previewToken();
    while (token.type != TokenType.rightBrace) { // != }
      Identifier key = parseIdentifier();
      parseToken(TokenType.colon);
      Expression value = parseExpression();
      token = previewToken();
      if (token.type == TokenType.comma) {
        index++;
      }
      else if (token.type != TokenType.rightBrace) {
        throw "expected ',' or '}' after $token";
      }
      dict[key] = value;
    }
    index++;
    return DictExp(dict);
  }

  /// gives back the [Token] and goes forward on the [index]
  ///
  /// if the [type] is the not the expected [type], the in crashes
  Token parseToken([TokenType? type]) => tryParseToken(type) ?? (throw "expected $type at $index");

  /// gives back the [Token]
  ///
  /// if the [type] is the expected [type], then it goes forward on the [index] returns the [Token]
  ///
  /// else it crashes
  Token? tryParseToken([TokenType? type]) {
    if (index < tokens.length) {
      Token token = tokens[index];
      if (type == null || token.type == type) {
        index++;
        return token;
      }
    }
    return null;
  }

  /// gives back the [Token] without going forward
  ///
  /// if the end of [tokens] is at this point, then it crashes
  Token previewToken() => tryPreviewToken() ?? (throw "there is no next token at $index");

  /// gives back the [Token] without going forward
  ///
  /// if the end of [tokens] is at this point, then it returns [null]
  Token? tryPreviewToken() {
    if (index < tokens.length) {
      return tokens[index];
    }
    return null;
  }

  bool isNextToken(TokenType type) => previewToken().type == type;
}

/*class _ParserDemo {

  final List<Token> tokens;

  int index = 0;

  _ParserDemo(this.tokens);
  static Manager parse(List<Token> tokens) {
    _ParserDemo parser = _ParserDemo(tokens);
    return parser.parseManager();
  }


  /// grammar:
  ///
  /// [Header]
  ///
  /// [Declaration]*
  Manager parseManager() {
    Header header = parseHeader();
    List<Declaration> declarations = [];
    while (index < tokens.length) {
      declarations.add(parseDeclaration());
    }
    return Manager(header,declarations);
  }

  /// grammar:
  ///
  /// [Identifier] `;`
  Header parseHeader() {
    Identifier identifier = parseIdentifier();
    parseToken(TokenType.semicolon);
    return Header(identifier);
  }

  /// grammar:
  ///
  /// [text]
  Identifier parseIdentifier() {
    Token token = parseToken(TokenType.identifier);
    return Identifier(token.text);
  }

  /// grammar:
  ///
  /// [Identifier] `=` [Expression] `;`
  Declaration parseDeclaration() {
    Identifier identifier = parseIdentifier();
    parseToken(TokenType.equal);
    Expression expression = parseExpression();
    parseToken(TokenType.semicolon);
    return Declaration(identifier, expression);
  }

  /// grammar:
  ///
  /// [IntegerExp]
  ///
  /// | [HexadecimalExp]
  ///
  /// | [BinaryExp]
  ///
  /// | [FloatExp]
  ///
  /// | [StringExp]
  ///
  /// | [CharExp]
  ///
  /// | [ListExp]
  ///
  /// | [DictExp]
  Expression parseExpression() {
    Token token = parseToken();
    String text = token.text;
    switch (token.type) {
      case TokenType.integer:
        return IntegerExp(int.parse(text));
      case TokenType.hexadecimal:
        return HexadecimalExp(text.substring(2));
      case TokenType.binary:
        return BinaryExp(text.substring(2));
      case TokenType.float:
        int position = text.indexOf('.');
        String integerText = text.substring(0,position) + text.substring(position+1);
        int integer = int.parse(integerText);
        int denominator = pow(10,text.substring(position+1).length).toInt();
        return FloatExp(Fraction(integer,denominator));
      case TokenType.string:
        return StringExp(text.substring(1,text.length-1));
      case TokenType.char:
        return CharExp(text.substring(1,text.length-1));
      case TokenType.leftBrace:
        return parseDictRest();
      case TokenType.leftBracket:
        return parseListRest();
      case _:
        throw "expected expression got ${token.type}";
    }
  }

  /// grammar:
  ///
  /// [[] ( [Expression] ( `,` [Expression] )* )? `]`
  ListExp parseListRest() { // already consumed [
    List<Expression> list = [];
    Token token = previewToken();
    while (token.type != TokenType.rightBracket) { // != ]
      list.add(parseExpression());
      token = previewToken();
      if (token.type == TokenType.comma) {
        index++;
      }
      else if (token.type != TokenType.rightBracket) {
        throw "expected ',' or ']' after $token";
      }
    }
    index++;
    return ListExp(list);
  }

  /// grammar:
  ///
  /// `{` ( [Identifier] `:` [Expression]
  ///
  /// ( `,` [Identifier] `:` [Expression] )* )? `}`
  DictExp parseDictRest() { // already consumed {
    Map<Identifier,Expression> dict = {};
    Token token = previewToken();
    while (token.type != TokenType.rightBrace) { // != }
      Identifier key = parseIdentifier();
      parseToken(TokenType.colon);
      Expression value = parseExpression();
      token = previewToken();
      if (token.type == TokenType.comma) {
        index++;
      }
      else if (token.type != TokenType.rightBrace) {
        throw "expected ',' or '}' after $token";
      }
      dict[key] = value;
    }
    index++;
    return DictExp(dict);
  }

  Token parseToken([TokenType? type]) => tryParseToken(type) ?? (throw "expected $type at $index");

  Token? tryParseToken([TokenType? type]) {
    if (index < tokens.length) {
      Token token = tokens[index];
      if (type == null || token.type == type) {
        index++;
        return token;
      }
    }
    return null;
  }

  Token previewToken() => tryPreviewToken() ?? (throw "there is no next token at $index");

  Token? tryPreviewToken() {
    if (index < tokens.length) {
      return tokens[index];
    }
    return null;
  }
}*/