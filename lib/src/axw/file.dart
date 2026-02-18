import 'dart:io';
import 'scan.dart';
import 'parser.dart';
import 'ast.dart';



class AXW {
  Version _version = Version.AXW20;
  List<Declaration> _environment = [];
  String _fileContents = "";
  final String fileName;

  void _update() {
    String garbageFile = _fileContents;
    _fileContents = File(fileName).readAsStringSync();
    if (garbageFile != _fileContents) {
      Scanner scan = Scanner(_fileContents);
      Parser parse = Parser(scan.list);
      Manager parsed = parse.parseManager();
      _version = parse.version;
      _environment = _evalEnvironment(parsed);
    }
  }
  List<Declaration> _evalEnvironment(Manager manager) {
    List<Declaration> environment = [];
    List<Declaration> expecting = [];
    for (Declaration declaration in manager.declarations) {
      switch (declaration) {
        case ExpressionDeclaration(): {
          switch (declaration.exp) {
            case VarExp():
              expecting.add(declaration);
            case _:
              environment.add(declaration);
              if (expecting.contains(declaration)) {
                environment.add(expecting.at)
              }
          }
        }
        case StructDeclaration():
        // TODO: Handle this case.
          throw UnimplementedError();
        case EnumDeclaration():
        // TODO: Handle this case.
          throw UnimplementedError();
      }
    }
    return environment;
  }

  AXW(this.fileName) {_update();}
}




/*String readLine(String lines,[int pos = 0]) {
  String garbageString = "";
  for (int i = pos; i < lines.length; ++i) {
    if (lines[i] == "\r") {return garbageString;}
    else {garbageString += lines[i];}
  }
  return garbageString;
}

String? forceReadLine(String lines,[int pos = 0]) {
  String garbageString = "";
  for (int i = pos; i < lines.length; ++i) {
    if (lines[i] == "\r") {return garbageString;}
    else {garbageString += lines[i];}
  }
  return null;
}

enum AXWTypes {
  version,
  int,
  string,
  list,
  float,
  hexadecimal,
  binary,
  none,
  dict,
  char}


class AXWToken {
  String name;
  AXWTypes type;
  dynamic value;

  AXWToken(this.name,this.value,this.type);

  @override
  String toString() {
    switch (type) {
      case AXWTypes.version:
        return "$value";
      case AXWTypes.int:
        return "$value";
      case AXWTypes.string:
        return "\"$value\"";
      case AXWTypes.list:
        return "$value";
      case AXWTypes.float:
        return "$value";
      case AXWTypes.hexadecimal:
        return "$value";
      case AXWTypes.binary:
        return "$value";
      case AXWTypes.none:
        return "${null}";
      case AXWTypes.dict:
        return "$value";
      case AXWTypes.char:
        return "$value";
    }
  }
}

/// reader state
enum _State { // is named in the first encountered/made
  start, // only at the start, should never be saved
  name, // name as AXW or a variable
  integer, // [0, 1, ..., 8, 9]
  float, // [int.int]
  breaker, // [;]
  whitespace, // [ ]
  newline, // [\n]
  equal, // [=]
  string, // {"[char,...,char]"}
  list, // {[...,...]}
  comma, // [,]
  colon,
  zero, // [0], made to be int/hex/bin switcher
  hexadecimal, // {0x[int, A, ..., E, F]}
  binary, // {0n[0, 1]}
  char, // {'[character]'}
  escape, // [\]
  dict, // [{...:...,...:...}]
}


enum AXWTokenType {
  name,
  indicator, // type indicator / identifier
  int,
  float,
  semicolon,
  equal,
  string,
  list,
  comma,
  colon,
  hexadecimal,
  binary,
  char,
  escape,
  dict,
}


class ReaderToken {
  final String text;
  final AXWTokenType type;

  ReaderToken(this.text,this.type);

  @override
  String toString() => "$text:${type.name}";
}

const _decimal = {"0","1","2","3","4","5","6","7","8","9"};
const _charLow = {"a","b","c","d","e","f",
                  "g","h","i","j","k","l",
                  "m","n","o","p","q","r",
                  "s","t","u","v","w","x","y","z"};
const _charHigh = {"A","B","C","D","E","F",
                  "G","H","I","J","K","L",
                  "M","N","O","P","Q","R",
                  "S","T","U","V","W","X","Y","Z"};
const _hex = {"0","1","2","3","4","5","6","7","8","9",
              "a","A","b","B","c","C","d","D","e","E","f","F"};
const _string = "\"";
const _listS = "[";
const _listE = "]";
const _charSig = "'";
const _dictS = "{";
const _dictE = "}";


String sub(String text, int start, int end) => text.substring(start,end);







class AXW {
  String name;
  late AXWOperator _version;
  late List<AXWToken> _variables;
  late final File _file = File(name);

  static int? _getVersion(String line) {return AXWOperator.versions[line];}

  int get version {
    String file = _file.readAsStringSync();
    String versionIdentifier = readLine(file);
    return _getVersion(versionIdentifier) ?? (throw "unexpected version $versionIdentifier");
  }

  void _update() {

  }


  AXW(this.name) {
    if (version == AXWOperator.versions[AXWOperator.v20[0]] ||
        version == AXWOperator.versions[AXWOperator.v20[1]]) {_version = _AXWv20(name);}
    else {throw "what version is $version?";}
    _variables = _version.variables;
  }
}


sealed class AXWOperator {
  abstract String name;
  abstract List<AXWToken> variables;
  abstract File file;

  static const v10 = ["AXW1","AXW1.0"];
  static const v11 = "AXW1.1";
  static const v12 = "AWX1.2";
  static const v13 = "AXW1.3";
  static const v14 = "AXW1.4";
  static const v20 = ["AXW2","AXW2.0"];
  static const versions = {"AXW1":0,"AXW1.0":1, v11:1, v12:2, v13:3, v14:4,
                           "AXW2":5,"AXW2.0":5};

  List<ReaderToken> scan(); // uses file Contents
  List<AXWToken> parser(); // uses scan first

  AXWToken operator [](String name);
  void operator []=(String name, dynamic value);
  ///amount of new [lines]
  AXWOperator operator >>(int lines);
  ///amount of truncated [lines]
  AXWOperator operator <<(int lines);
}

class _AXWv20 extends AXWOperator {
  @override
  String name;
  @override
  late File file = File(name);
  @override
  late List<AXWToken> variables;

  @override
  /** reader tokens of the [file], needs to be [AXW] file */
  List<ReaderToken> scan() {
    List<ReaderToken> list = [];
    _State state = _State.start;
    int start = -1;
    String fileC = file.readAsStringSync(); // file contents
    for (int index = 0; index < fileC.length; index++) {
      String char = fileC[index];
      String subst = sub(fileC,start,index);
      // if character is, goes in order of ReaderState Enum
      if (_charLow.contains(char) || _charHigh.contains(char)) {
        switch (state) {
          case _State.start:
            state = _State.name;
            start = index;
          case _State.name:
            break;
          case _State.integer:
            list.add(ReaderToken(subst,AXWTokenType.int));
            state = _State.name;
            start = index;
          case _State.float:
            list.add(ReaderToken(subst,AXWTokenType.float));
            state = _State.name;
            start = index;
          case _State.breaker:
            list.add(ReaderToken(subst,AXWTokenType.semicolon));
            state = _State.name;
            start = index;
          case _State.whitespace:
            state = _State.name;
            start = index;
          case _State.newline:
            state = _State.name;
            start = index;
          case _State.equal:
            list.add(ReaderToken(subst,AXWTokenType.equal));
            state = _State.name;
            start = index;
          case _State.string:
            break;
          case _State.list:
            list.add(ReaderToken(subst,AXWTokenType.list));
            state = _State.name;
            start = index;
          case _State.comma:
            list.add(ReaderToken(subst,AXWTokenType.comma));
            state = _State.name;
            start = index;
          case _State.colon:
            list.add(ReaderToken(subst,AXWTokenType.colon));
            state = _State.name;
            start = index;
          case _State.zero:
            if (char == "x" || char == "X") {state = _State.hexadecimal;
            } else if (char == "n" || char == "N") {state = _State.binary;
            } else {
              list.add(ReaderToken(subst,AXWTokenType.int));
              state = _State.name;
              start = index;
            }
          case _State.hexadecimal:
            if (!_hex.contains(char)) {
              list.add(ReaderToken(subst,AXWTokenType.hexadecimal));
              state = _State.name;
              start = index;
            } else {break;}
          case _State.binary:
            list.add(ReaderToken(subst,AXWTokenType.binary));
            state = _State.name;
            start = index;
          case _State.char: // handler should crash
            break;
          case _State.escape:
            break;
          case _State.dict:
            list.add(ReaderToken(subst,AXWTokenType.dict));
            state = _State.name;
            start = index;
        }
      }
      else if (char == "0") {
        switch (state) {
          case _State.start:
            state = _State.zero;
            start = index;
          case _State.name:
            break;
          case _State.integer:
            break;
          case _State.float:
            break;
          case _State.breaker:
            list.add(ReaderToken(subst,AXWTokenType.semicolon));
            state = _State.zero;
            start = index;
          case _State.whitespace:
            state = _State.zero;
            start = index;
          case _State.newline:
            state = _State.zero;
            start = index;
          case _State.equal:
            list.add(ReaderToken(subst,AXWTokenType.equal));
            state = _State.zero;
            start = index;
          case _State.string:
            break;
          case _State.list:
            list.add(ReaderToken(subst,AXWTokenType.list));
            state = _State.zero;
            start = index;
          case _State.comma:
            list.add(ReaderToken(subst,AXWTokenType.comma));
            state = _State.zero;
            start = index;
          case _State.colon:
            list.add(ReaderToken(subst,AXWTokenType.colon));
            state = _State.zero;
            start = index;
          case _State.zero:
            state = _State.integer;
          case _State.hexadecimal:
            break;
          case _State.binary:
            break;
          case _State.char:
            break;
          case _State.escape:
            break;
          case _State.dict:
            list.add(ReaderToken(subst,AXWTokenType.dict));
            state = _State.zero;
            start = index;
        }}
      else if (_decimal.contains(char)) {
        switch (state) {
          case _State.start:
            state = _State.integer;
            start = index;
          case _State.name:
            break;
          case _State.integer:
            break;
          case _State.float:
            break;
          case _State.breaker:
            list.add(ReaderToken(subst,AXWTokenType.semicolon));
            state = _State.integer;
            start = index;
          case _State.whitespace:
            state = _State.integer;
            start = index;
          case _State.newline:
            state = _State.integer;
            start = index;
          case _State.equal:
            list.add(ReaderToken(subst,AXWTokenType.equal));
            state = _State.integer;
            start = index;
          case _State.string:
            break;
          case _State.list:
            list.add(ReaderToken(subst,AXWTokenType.list));
            state = _State.integer;
            start = index;
          case _State.comma:
            list.add(ReaderToken(subst,AXWTokenType.comma));
            state = _State.integer;
            start = index;
          case _State.colon:
            list.add(ReaderToken(subst,AXWTokenType.colon));
            state = _State.integer;
            start = index;
          case _State.zero:
            state = _State.integer;
          case _State.hexadecimal:
            break;
          case _State.binary:
            if (char == "1") {break;}
            else {
            list.add(ReaderToken(subst,AXWTokenType.binary));
            state = _State.integer;
            start = index;}
          case _State.char:
            break;
          case _State.escape:
            break;
          case _State.dict:
            list.add(ReaderToken(subst,AXWTokenType.dict));
            state = _State.integer;
            start = index;
        }}
      // starters and enders
      else if (char == _string) {
        switch (state) {
          case _State.start:
            state = _State.string;
            start = index;
          case _State.name:
            list.add(ReaderToken(subst,AXWTokenType.name));
            state = _State.string;
            start = index;
          case _State.integer:
            list.add(ReaderToken(subst,AXWTokenType.int));
            state = _State.string;
            start = index;
          case _State.float:
            list.add(ReaderToken(subst,AXWTokenType.float));
            state = _State.string;
            start = index;
          case _State.breaker:
            list.add(ReaderToken(subst,AXWTokenType.semicolon));
            state = _State.string;
            start = index;
          case _State.whitespace:
            state = _State.string;
            start = index;
          case _State.newline:
            state = _State.string;
            start = index;
          case _State.equal:
            list.add(ReaderToken(subst,AXWTokenType.equal));
            state = _State.string;
            start = index;
          case _State.string:
            list.add(ReaderToken(sub(fileC,start,index+1),AXWTokenType.string));
            state = _State.whitespace;
            start = index+1;
          case _State.list:
            list.add(ReaderToken(subst,AXWTokenType.string));
            state = _State.string;
            start = index;
          case _State.comma:
            list.add(ReaderToken(subst,AXWTokenType.comma));
            state = _State.string;
            start = index;
          case _State.colon:
            list.add(ReaderToken(subst,AXWTokenType.colon));
            state = _State.string;
            start = index;
          case _State.zero:
            list.add(ReaderToken(subst,AXWTokenType.int));
            state = _State.string;
            start = index;
          case _State.hexadecimal:
            list.add(ReaderToken(subst,AXWTokenType.hexadecimal));
            state = _State.string;
            start = index;
          case _State.binary:
            list.add(ReaderToken(subst,AXWTokenType.binary));
            state = _State.string;
            start = index;
          case _State.char:
            list.add(ReaderToken(subst,AXWTokenType.char));
            state = _State.string;
            start = index;
          case _State.escape:
            break;
          case _State.dict:
            list.add(ReaderToken(subst,AXWTokenType.dict));
            state = _State.string;
            start = index;
        }}
      else if (char == _listS) {
        switch (state) {
          case _State.start:
            state = _State.list;
            start = index;
          case _State.name:
            list.add(ReaderToken(subst,AXWTokenType.name));
            state = _State.list;
            start = index;
          case _State.integer:
            list.add(ReaderToken(subst,AXWTokenType.int));
            state = _State.list;
            start = index;
          case _State.float:
            list.add(ReaderToken(subst,AXWTokenType.float));
            state = _State.list;
            start = index;
          case _State.breaker:
            list.add(ReaderToken(subst,AXWTokenType.semicolon));
            state = _State.list;
            start = index;
          case _State.whitespace:
            state = _State.list;
            start = index;
          case _State.newline:
            state = _State.list;
            start = index;
          case _State.equal:
            list.add(ReaderToken(subst,AXWTokenType.equal));
            state = _State.list;
            start = index;
          case _State.string:
            break;
          case _State.list:
            list.add(ReaderToken(subst,AXWTokenType.list));
            state = _State.list;
            start = index;
          case _State.comma:
            list.add(ReaderToken(subst,AXWTokenType.comma));
            state = _State.list;
            start = index;
          case _State.colon:
            list.add(ReaderToken(subst,AXWTokenType.colon));
            state = _State.list;
            start = index;
          case _State.zero:
            list.add(ReaderToken(subst,AXWTokenType.int));
            state = _State.list;
            start = index;
          case _State.hexadecimal:
            list.add(ReaderToken(subst,AXWTokenType.hexadecimal));
            state = _State.list;
            start = index;
          case _State.binary:
            list.add(ReaderToken(subst,AXWTokenType.hexadecimal));
            state = _State.list;
            start = index;
          case _State.char:
            break;
          case _State.escape:
            break;
          case _State.dict:
            list.add(ReaderToken(subst,AXWTokenType.dict));
            state = _State.list;
            start = index;
        }}
      else if (char == _listE) {
        switch (state) {
          case _State.start:
            state = _State.list;
            start = index;
          case _State.name:
            list.add(ReaderToken(subst,AXWTokenType.name));
            state = _State.list;
            start = index;
          case _State.integer:
            list.add(ReaderToken(subst,AXWTokenType.int));
            state = _State.list;
            start = index;
          case _State.float:
            list.add(ReaderToken(subst,AXWTokenType.float));
            state = _State.list;
            start = index;
          case _State.breaker:
            list.add(ReaderToken(subst,AXWTokenType.semicolon));
            state = _State.list;
            start = index;
          case _State.whitespace:
            state = _State.list;
            start = index;
          case _State.newline:
            state = _State.list;
            start = index;
          case _State.equal:
            list.add(ReaderToken(subst,AXWTokenType.equal));
            state = _State.list;
            start = index;
          case _State.string:
            break;
          case _State.list:
            list.add(ReaderToken(subst,AXWTokenType.list));
            state = _State.list;
            start = index;
          case _State.comma:
            list.add(ReaderToken(subst,AXWTokenType.comma));
            state = _State.list;
            start = index;
          case _State.colon:
            list.add(ReaderToken(subst,AXWTokenType.colon));
            state = _State.list;
            start = index;
          case _State.zero:
            list.add(ReaderToken(subst,AXWTokenType.int));
            state = _State.list;
            start = index;
          case _State.hexadecimal:
            list.add(ReaderToken(subst,AXWTokenType.hexadecimal));
            state = _State.list;
            start = index;
          case _State.binary:
            list.add(ReaderToken(subst,AXWTokenType.binary));
            state = _State.list;
            start = index;
          case _State.char:
            break;
          case _State.escape:
            break;
          case _State.dict:
            list.add(ReaderToken(subst,AXWTokenType.dict));
            state = _State.list;
            start = index;
        }
      }
    }
    return list;
  }

  void _update() {
    variables = [];
  }

  _AXWv20(this.name) {_update();}
}

 */
