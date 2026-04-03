enum TokenType {
  identifier(false),
  period(true, "."),
  integer(false),
  semicolon(true, ";");

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
  toString() => '"$text" \$$type';
}
