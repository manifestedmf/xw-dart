import 'ast.dart';

class World {
  static World build(Manager manager) {
    World world = World();
    Map<String, Definition> environment = {};
    for (Declaration declaration in manager.declarations) {
      String name = declaration.id.name;
      if (environment.containsKey(name)) {
        throw "can't name '$name' twice";
      }
      switch (declaration) {
        case ExpressionDeclaration(): {
          environment[name] = ValueDefinition(name,evaluate(declaration.exp,environment));
        }
        case StructDeclaration(): {
          environment[name] = StructDefinition(name,declaration);
        }
        case EnumDeclaration():
        // TODO: Handle this case.
          throw UnimplementedError();
      }
    }
    return world;
  }
  static Expression evaluate(Expression expression,Map<String,Definition> environment) {
    switch (expression) {
      case VarExp(): {
        Definition? definition = environment[expression.id.name];
        switch (definition) {
          case null: {throw "'${expression.id.name}' doesn't exist";}
          case ValueDefinition(): {return definition.value;}
          case StructDefinition(): {return definition.struct;}
        }
      }
      case _: {return expression;}
    }
  }
}

sealed class Definition {
  String get name;
}

class ValueDefinition extends Definition {
  @override
  final String name;
  final Expression value;

  ValueDefinition(this.name,this.value);
}

class StructDefinition extends Definition {
  @override
  final String name;
  final StructDeclaration struct;

  StructDefinition(this.name,this.struct);
}

sealed class Value {

}

class StructValue extends Value {
  final StructDefinition definition;

  StructValue(this.definition);
}

class Struct {}

class IntegerValue extends Value {
  final int value;

  IntegerValue(this.value);
}