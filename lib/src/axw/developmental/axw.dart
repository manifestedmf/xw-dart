import 'scan.dart';
import 'parser.dart';
import 'ast.dart';
import 'dart:io' show File;
import 'dart:convert' show utf8, Encoding;

sealed class AXW<N extends AXW<N>> {
  Version get version => _body.header.version;
  File _file;
  final String address;
  late Scanner _scanner;
  late Parser _parser;
  late Body _body;
  final Encoding encoding;

  AXW(this.address, {required this.encoding}) : _file = File(address) {
    _runAXW();
  }

  AXW.unsecure(this.address, {this.encoding = utf8}) : _file = File(address) {
    _runAXW();
  }

  Future<void> _runAXW() async {
    _scanner = Scanner(await _file.readAsString(encoding: encoding))
      ..scanContents();
    _parser = Parser(_scanner.tokens);
    _body = _parser.parseAXW();
  }

  Expr? elementWith(Id identifier) {
    for (Declaration declaration in _body.declarations) {
      if (declaration.identifier == identifier) {
        return declaration.expression;
      }
    }
    return null;
  }

  StrExpr? stringWith(Id identifier) {
    Expr? expr = elementWith(identifier);
    if (expr is StrExpr || expr == null) {
      return expr as StrExpr?;
    } else {
      throw ArgumentError.value(identifier, "identifier", "Is not a string");
    }
  }

  IntExpr? integerWith(Id identifier) {
    Expr? expr = elementWith(identifier);
    if (expr is IntExpr || expr == null) {
      return expr as IntExpr?;
    } else {
      throw ArgumentError.value(identifier, "identifier", "Is not a integer");
    }
  }

  Set<Id> elementsWith(Expr expr) {
    Set<Id> identifiers = {};
    for (Declaration declaration in _body.declarations) {
      if (declaration.expression == expr) {
        identifiers.add(declaration.identifier);
      }
    }
    return identifiers;
  }

  Set<Id> stringsWith(StrExpr string) => elementsWith(string);
  Set<Id> integersWith(IntExpr integer) => elementsWith(integer);

  Declaration elementAt(int index) => _body.declarations[index];
  Declaration stringAt(int index) {
    Declaration decl = elementAt(index);
    if (decl.expression is StrExpr) {
      return decl;
    } else {
      throw ArgumentError.value(decl, "identifier", "Is not a string");
    }
  }

  bool changeElementWith(Id identifier, Expr expr);
  bool changeStringWith(Id identifier, StrExpr string) {
    if (typeOf(identifier) != Type.string) {
      throw ArgumentError.value(identifier, "identifier", "Is not a string");
    } else {
      return changeElementWith(identifier, string);
    }
  }

  bool changeIntegerWith(Id identifier, IntExpr integer) {
    if (typeOf(identifier) != Type.int) {
      throw ArgumentError.value(identifier, "identifier", "Is not a integer");
    } else {
      return changeElementWith(identifier, integer);
    }
  }

  Type? typeOf(Id identifier) => switch (elementWith(identifier)) {
    StringExpression() => .string,
    IntExpression() => .int,
    null => null,
  };

  Expr operator [](String string) => elementWith(Id(string))!;
  void operator []=(String string, Object? object) =>
      changeElementWith(Identifier(string), Expr.parse(object));

  N upgrade();
}

final class AXW10 extends AXW<AXW10> {
  @override
  Version get version => Version.axw10;

  AXW10(super.address, {required super.encoding});
  AXW10.unsecure(super.address, {super.encoding = utf8}) : super.unsecure();

  @override
  bool changeElementWith(Id identifier, Expr<dynamic> expr) {
    // TODO: implement changeElementWith
    throw UnimplementedError();
  }

  @override
  AXW10 upgrade() => AXW10(address, encoding: encoding);
}

/*
final class AXW11 extends AXW implements AXW10 {
  @override
  void changeElementWith(Id identifier, Expr<dynamic> expr) {
    // TODO: implement changeElementWith
  }

  @override
  Expr<dynamic> elementWith(Id identifier) {
    // TODO: implement elementWith
    throw UnimplementedError();
  }

  @override
  Set<Identifier> elementsWith(Expr<dynamic> expr) {
    // TODO: implement elementsWith
    throw UnimplementedError();
  }

  @override
  // TODO: implement version
  Version get version => throw UnimplementedError();

}

final class AXW12 extends AXW implements AXW11 {

}*/
