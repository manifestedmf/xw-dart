import 'dart:core' show List, String, override, int, ArgumentError, bool;

// Current AXW1.0 ast
//
// axw
//    header
//    header declarations
//
// header
//    ws "AXW1" ws ";" ws
//    ws "AXW1.0" ws ";" ws
//
// declarations
//    declaration
//    declaration declarations
//
// declaration
//    ws identifier ws "=" expression ";" ws
//    ws type ws identifier ws "=" type_expression ";" ws
//
// expression
//    ws value ws
//
// value
//    string
//    int
//
// string
//    characters
//
// characters
//    character
//    character characters
//
// character
//    '0020' . '10FFFF' - '"' - "\"
//    "\" escape
//
// escape
//    '"'
//    "\"
//    "n"
//    "t"
//    "r"
//    "f"
//    "b"
//
// int
//    digit
//    digit int
//
// digit
//    "0" . "9"
//
// type
//    "string"
//    "int"
//
// type_expression
//    "string" -> string
//    "int" -> int
//
// identifier
//    characters

import 'parser.dart' show Version;

typedef TypeDecl = TypeDeclaration;
typedef Expr<I> = Expression<I>;
typedef TypeExpr<I> = TypeExpression<I>;
typedef StrExpr = StringExpression;
typedef IntExpr = IntExpression;
typedef BoolExpr = BoolExpression;
typedef STE = StringTypeExpression;
typedef ITE = IntTypeExpression;
typedef BTE = BoolTypeExpression;
typedef Id = Identifier;
typedef Body = AXW;

final class AXW {
  final Header header;
  final List<Declaration> declarations;

  const AXW(this.header, this.declarations);

  @override
  toString({bool newline = false}) {
    if (newline) {
      return "$header\n${declarations.join("\n")}";
    } else {
      return "$header ${declarations.join(" ")}";
    }
  }
}

final class Header {
  Version get version => Version.axw10;
  const Header(Version version);

  @override
  toString() => "${version.tag};";
}

final class Declaration {
  final Id identifier;
  final Expr expression;

  const Declaration(this.identifier, this.expression);

  @override
  toString() => "'$identifier' = $expression;";
}

final class TypeDeclaration implements Declaration {
  @override
  final Id identifier;
  final Type type;
  @override
  final TypeExpr expression;

  const TypeDeclaration(this.type, this.identifier, this.expression);

  @override
  toString() => "$type '$identifier' = $expression;";
}

enum Type {
  string("string"),
  int("int"),
  bool("bool");

  final String annotation;

  const Type(this.annotation);
  @override
  toString() => annotation;
}

sealed class Expression<I> {
  I get internal;
  const Expression();

  static Expr<I> parse<I>(I input) =>
      tryParse(input) ?? (throw ArgumentError.value(input, "input"));

  static Expr<I>? tryParse<I>(I input) {
    if (input is String) {
      return StrExpr(input) as Expr<I>;
    } else if (input is int) {
      return IntExpr(input) as Expr<I>;
    } else {
      return null;
    }
  }

  @override
  toString() => internal.toString();
}

final class StringExpression extends Expr<String> {
  final String string;
  const StringExpression(this.string);

  @override
  String get internal => string;

  @override
  toString() => '"$string"';
}

final class IntExpression extends Expr<int> {
  final int integer;
  const IntExpression(this.integer);

  @override
  int get internal => integer;

  @override
  toString() => integer.toString();
}

final class BoolExpression extends Expr<bool> {
  final bool boolean;
  const BoolExpression(this.boolean);

  @override
  bool get internal => boolean;

  @override
  toString() => boolean.toString();
}

sealed class TypeExpression<I> extends Expr<I> {
  Type get type;
  const TypeExpression();
}

final class StringTypeExpression extends StrExpr implements TypeExpr<String> {
  @override
  Type get type => Type.string;

  const StringTypeExpression(super.string);
}

final class IntTypeExpression extends IntExpr implements TypeExpr<int> {
  @override
  Type get type => Type.int;

  const IntTypeExpression(super.integer);
}

final class BoolTypeExpression extends BoolExpr implements TypeExpr<bool> {
  @override
  Type get type => Type.bool;

  const BoolTypeExpression(super.boolean);
}

final class Identifier {
  final String identity;

  const Identifier(this.identity);

  @override
  toString() => identity;
}
