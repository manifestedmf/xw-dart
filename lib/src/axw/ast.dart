import '../math/math.dart';
import '../mixins.dart';
import 'parser.dart';

/// grammar:
///
/// [Header]
///
/// [Declaration]*
///
/// ` `
///
/// added in Version: `AXW1.0` `;`
class Manager {
  final Header header;
  final List<Declaration> declarations; // declarations

  Manager(this.header,this.declarations);

  @override
  toString() => "$header `,` ${declarations.join(" ")}";
}


/// grammar:
///
/// ( [Identifier] ( `.` [Integer] )? `;` )
///
/// ` `
///
/// added in Version: `AXW1.0` `;`
class Header {
  final Version version; // identifier

  Header(this.version);

  @override
  toString() => "$version;";
}

/// added in Version: `AXW1.0` `;`
sealed class Declaration {
  abstract final Identifier id;

  String textRepr();
}

/// grammar:
///
/// [Identifier] `=` [Expression] `;`
///
/// ` `
///
/// added in Version: `AXW1.0` `;`
class ExpressionDeclaration extends Declaration {
  @override
  final Identifier id;
  final Expression exp;

  ExpressionDeclaration(this.id,this.exp);

  @override
  toString() => "$id = $exp;";

  @override
  textRepr() => "[$id=$exp]";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ExpressionDeclaration && runtimeType == other.runtimeType &&
              id == other.id && exp == other.exp;

  @override
  int get hashCode => id.hashCode ^ exp.hashCode;
}

/// grammar:
///
/// `Struct` [Identifier] `{`
///
///   [StructFieldDeclaration]*
///
/// `};`
///
/// ` `
///
/// added in Version: `AXW2.0` `;`
class StructDeclaration extends Declaration {
  @override
  final Identifier id;
  final List<StructFieldDeclaration> fields;

  StructDeclaration(this.id,this.fields);

  @override
  toString() => "Struct $id { ${fields.join(" ")} };";

  @override
  textRepr() => "{Str:${id.textRepr()}=[${fields.join(",")}]}";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is StructDeclaration && runtimeType == other.runtimeType &&
              id == other.id && listEquals(fields,other.fields);

  @override
  int get hashCode => id.hashCode ^ fields.hashCode;
}

/// grammar:
///
/// [Identifier] ( `=` [Expression] )? `;`
///
/// ` `
///
/// added in Version: `AXW2.0` `;`
class StructFieldDeclaration {
  final Identifier id;
  final Expression? exp;

  StructFieldDeclaration(this.id,[this.exp]);

  @override
  toString() {
    if (exp == null) {return "$id;";}
    else {return "$id = $exp;";}
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is StructFieldDeclaration && runtimeType == other.runtimeType &&
              id == other.id && exp == other.exp;

  @override
  int get hashCode => id.hashCode ^ exp.hashCode;
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
///
/// ` `
///
/// added in Version: `AXW2.1` `;`
class EnumDeclaration extends Declaration {
  @override
  final Identifier id;
  final List<EnumFieldDeclaration> fields;

  EnumDeclaration(this.id,this.fields);

  @override
  toString() => "enum $id {${fields.join(", ")}};";

  @override
  textRepr() => "{enum:$id=[${fields.join(",")}]}";
}

/// grammar:
///
/// [Identifier]
///
/// ` `
///
/// added in Version: `AXW2.1` `;`
class EnumFieldDeclaration {
  final Identifier id;

  EnumFieldDeclaration(this.id);

  @override
  toString() => "$id";
}

/// the Expression a.k.a. Value
sealed class Expression {
  StringExp toStringExp() => StringExp(toString());
  /// standard is 0
  IntegerExp toIntExp() => IntegerExp(toInt());
  /// standard is 0
  int toInt() => 0;
  /// the name for this expression
  String get name => "expression";
  /// naming for the assigning of this type
  String get typeName => name;

  const Expression();
}
/// input: ( `0` | `1` | `2` | `3` | `4` | `5` | `6` | `7` | `8` | `9` )+
///
/// output: [integer]
///
/// ` `
///
/// added in Version: `AXW1.0` `;`
class IntegerExp extends Expression with CompareMixin<IntegerExp> {
  final int integer;

  const IntegerExp(this.integer);

  @override
  toString() => "$integer";
  @override
  /// itself
  toIntExp() => this;
  @override
  toInt() => integer;
  @override
  get name => "int";
  @override
  bool operator <(IntegerExp other) => integer < other.integer;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is IntegerExp && runtimeType == other.runtimeType &&
              integer == other.integer;

  @override
  int get hashCode => integer.hashCode;
}

/// input: ( `0` | `1` | `2` | `3` | `4` | `5` | `6` | `7` | `8` | `9`
/// | `a` | `A` | `b` | `B` | `c` | `C` | `d` | `D` | `e` | `E` | `f` | `F` )+
///
/// output: `0x` [hex]
///
/// ` `
///
/// added in Version: `AXW1.3` `;`
class HexadecimalExp extends Expression with CompareMixin<HexadecimalExp> {
  final String hex;

  HexadecimalExp(String hex):hex = hex.toUpperCase();

  @override
  toString() => "0x$hex";
  @override
  /// hex conversion
  toInt() => hexConvert(hex);
  @override
  get name => "hexadecimal";
  @override
  operator <(HexadecimalExp other) => toInt() < other.toInt();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is HexadecimalExp && runtimeType == other.runtimeType &&
              hex == other.hex;

  @override
  int get hashCode => hex.hashCode;
}

/// input: ( `0` | `1` )+
///
/// output: `0n` [bin]
///
/// ` `
///
/// added in Version: `AXW1.3` `;`
class BinaryExp extends Expression with CompareMixin<BinaryExp> {
  final String bin;

  const BinaryExp(this.bin);

  @override
  toString() => "0n$bin";
  @override
  /// binary conversion
  toInt() => binConvert(bin);
  @override
  get name => "binary";
  @override
  get typeName => "bin";
  @override
  operator <(BinaryExp other) => toInt() < other.toInt();
}

/// input: `Fraction(oper,div)`
///
/// output: [Fraction.afterVisualRepr]
///
/// ` `
///
/// added in Version: `AXW1.1` `;`
class FloatExp extends Expression with CompareMixin<FloatExp> {
  final Fraction fraction;

  const FloatExp(this.fraction);

  @override
  toString() => fraction.afterVisualRepr;
  @override
  /// truncates
  toInt() => fraction.integer;
  @override
  get name => "float";
  @override
  operator <(FloatExp other) => toInt() < other.toInt();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is FloatExp && runtimeType == other.runtimeType &&
              fraction == other.fraction;

  @override
  int get hashCode => fraction.hashCode;
}

/// input: `String`
///
/// output: `"` [string] `"`
///
/// ` `
///
/// added in Version: `AXW1.0` `;`
class StringExp extends Expression {
  final String string;

  const StringExp(this.string);

  @override
  toString() => "\"$string\"";
  @override
  get name => "string";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is StringExp && runtimeType == other.runtimeType &&
              string == other.string;

  @override
  int get hashCode => string.hashCode;
}

/// input: `String`
///
/// output: `'` [character] `'`
///
/// ` `
///
/// added in Version: `AXW2.0` `;`
class CharExp extends Expression with CompareMixin<CharExp> {
  final String character;

  const CharExp(this.character);

  /// gotten from Code Page 437
  // currently only to 7F
  static Map<String,int> values = {
    "":0x00,
    "\u236A":0x01,
    "\u236B":0x02,
    "\u2665":0x03,
    "\u2666":0x04,
    "\u2663":0x05,
    "\u2660":0x06,
    "\u2022":0x07,
    "\u25D8":0x08,
    "\u25CB":0x09,
    "\u25D9":0x0A,
    "\u2642":0x0B,
    "\u2640":0x0C,
    "\u266A":0x0D,
    "\u266B":0x0E,
    "\u263C":0x0F,
    "\u25BA":0x10,
    "\u25C4":0x11,
    "\u2195":0x12,
    "\u203C":0x13,
    "\u00B6":0x14,
    "\u00A7":0x15,
    "\u25AC":0x16,
    "\u21A8":0x17,
    "\u2191":0x18,
    "\u2193":0x19,
    "\u2192":0x1A,
    "\u2190":0x1B,
    "\u221F":0x1C,
    "\u2194":0x1D,
    "\u25B2":0x1E,
    "\u25Bc":0x1F,
    " ":0x20,
    "!":0x21,
    "\"":0x22,
    "#":0x23,
    "\$":0x24,
    "%":0x25,
    "&":0x26,
    "'":0x27,
    "(":0x28,
    ")":0x29,
    "*":0x2A,
    "+":0x2B,
    ",":0x2C,
    "-":0x2D,
    ".":0x2E,
    "/":0x2F,
    "0":0x30,
    "1":0x31,
    "2":0x32,
    "3":0x33,
    "4":0x34,
    "5":0x35,
    "6":0x36,
    "7":0x37,
    "8":0x38,
    "9":0x39,
    ":":0x3A,
    ";":0x3B,
    "<":0x3C,
    "=":0x3D,
    ">":0x3E,
    "?":0x3F,
    "@":0x40,
    "A":0x41,
    "B":0x42,
    "C":0x43,
    "D":0x44,
    "E":0x45,
    "F":0x46,
    "G":0x47,
    "H":0x48,
    "I":0x49,
    "J":0x4A,
    "K":0x4B,
    "L":0x4C,
    "M":0x4D,
    "N":0x4E,
    "O":0x4F,
    "P":0x50,
    "Q":0x51,
    "R":0x52,
    "S":0x53,
    "T":0x54,
    "U":0x55,
    "V":0x56,
    "W":0x57,
    "X":0x58,
    "Y":0x59,
    "Z":0x5A,
    "[":0x5B,
    "\\":0x5C,
    "]":0x5D,
    "^":0x5E,
    "_":0x5F,
    "`":0x60,
    "a":0x61,
    "b":0x62,
    "c":0x63,
    "d":0x64,
    "e":0x65,
    "f":0x66,
    "g":0x67,
    "h":0x68,
    "i":0x69,
    "j":0x6A,
    "k":0x6B,
    "l":0x6C,
    "m":0x6D,
    "n":0x6E,
    "o":0x6F,
    "p":0x70,
    "q":0x71,
    "r":0x72,
    "s":0x73,
    "t":0x74,
    "u":0x75,
    "v":0x76,
    "w":0x77,
    "x":0x78,
    "y":0x79,
    "z":0x7A,
    "{":0x7B,
    "|":0x7C,
    "}":0x7D,
    "~":0x7E,
    "\u2302":0x7F
  };

  @override
  toString() => "'$character'";
  @override
  /// position
  toInt() => values[character]!;
  @override
  get name => "character";
  @override
  get typeName => "char";
  @override
  operator <(CharExp other) => toInt() < other.toInt();
}

/// input: [[] ( [Expression] ( `,` [Expression] )* )? []]
///
/// output: [[] [Expression] `, ` [Expression]... []]
///
/// ` `
///
/// added in Version: `AXW1.1` `;`
class ListExp extends Expression {
  final List<Expression> list;

  const ListExp(this.list);

  @override
  toString() => "[${list.join(", ")}]";
  @override
  get name => "list";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ListExp && runtimeType == other.runtimeType &&
              listEquals(list,other.list);

  @override
  int get hashCode => list.hashCode;
}

/// input: `{` ( [Identifier] `:` [Expression] ( `,` [Identifier] `:` [Expression] )* )? `}`
///
/// output: [Map]
///
/// ` `
///
/// added in Version: `AXW1.4` `;`
class DictExp extends Expression {
  final Map<Identifier,Expression> dict;

  const DictExp(this.dict);

  @override
  toString() => "$dict";

  @override
  get name => "dict";
}

/// input: [String]
///
/// output: [id]
///
/// ` `
///
/// added in Version: `AXW1.3` `;`
class VarExp extends Expression {
  final Identifier id;

  VarExp(String identification):id = Identifier(identification);

  @override
  toString() => id.toString();
  @override
  get name => "variable";
  @override
  get typeName => "";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is VarExp && runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// input:
///
/// output: `null`
///
/// ` `
///
/// added in Version: `AXW1.4` `;`
class VoidExp extends Expression {
  const VoidExp();

  @override
  toString() => "${null}";
  @override
  get name => "null";
  @override
  get typeName => "void";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is VoidExp && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

/// input: ( `true` | `false` )
///
/// output: [boolean]
///
/// ` `
///
/// added in Version: `AXW2.0` `;`
class BoolExp extends Expression with CompareMixin<BoolExp> {
  final bool boolean;

  const BoolExp(this.boolean);

  @override
  toString() => "$boolean";
  @override
  get name => "bool";
  @override
  /// 0 is false
  ///
  /// 1 is true
  toInt() {
    if (boolean) {return 1;}
    else {return 0;}
  }
  bool toBool() => boolean;

  @override
  bool operator <(BoolExp other) => toInt() < other.toInt();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is BoolExp && runtimeType == other.runtimeType &&
              boolean == other.boolean;

  @override
  int get hashCode => boolean.hashCode;

  bool operator ~() => !boolean;
  bool operator ^(BoolExp other) => boolean ^ other.boolean;
  bool operator &(BoolExp other) => boolean ^ other.boolean;
}

class StructExp extends Expression {
  final Identifier identifier;

  const StructExp(this.identifier);
}

/// grammar:
///
/// [name]
///
/// ` `
///
/// added in Version: `AXW1.0` `;`
class Identifier {
  final String name;

  Identifier(this.name);

  @override
  toString() => name;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Identifier && runtimeType == other.runtimeType &&
              name == other.name;

  @override
  int get hashCode => name.hashCode;

  String textRepr() => name;
}