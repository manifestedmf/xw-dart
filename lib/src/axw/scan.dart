//import 'dart:io';

class IncompleteToken {
  final String? message;

  IncompleteToken([this.message]);

  @override
  toString() {
    if (message == null) {return "IncompleteToken error";}
    else {return "IncompleteToken: $message";}
  }
}

enum TokenType {
  semicolon,
  identifier,
  equal,
  integer,
  hexadecimal,
  binary,
  float,
  string,
  char,
  leftBrace,
  rightBrace,
  leftBracket,
  rightBracket,
  comma,
  colon,
  none,
  period,
  bool,
}

class Token {
  final TokenType _type;
  final String _text;
  final int _offset;

  TokenType get type => _type;
  String get text => _text;
  int get offset => _offset;

  Token(this._text, this._type, [this._offset = -1]);

  @override
  toString() => "${type.name}:\"$text\" @$offset";

  String toMessage() => "${type.name}:$text";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Token && runtimeType == other.runtimeType &&
              _type == other._type && _text == other._text &&
              _offset == other._offset;

  @override
  int get hashCode => _type.hashCode ^ _text.hashCode ^ _offset.hashCode;
}


enum State {
  whitespace(null),
  identifier(TokenType.identifier),
  zero(TokenType.integer),
  integer(TokenType.integer),
  float(TokenType.float),
  hexadecimal(TokenType.hexadecimal),
  binary(TokenType.binary),
  semicolon(TokenType.semicolon),
  equal(TokenType.equal),
  stringIn.error(),
  stringOut(TokenType.string),
  charIn.error(),
  charOut(TokenType.char),
  escapeString.error(),
  escapeChar.error(),
  listStart(TokenType.leftBracket),
  comma(TokenType.comma),
  listEnd(TokenType.rightBracket),
  blockStart(TokenType.leftBrace),
  colon(TokenType.colon),
  blockEnd(TokenType.rightBrace),
  ;
  final TokenType? type;
  final bool error;
  const State(this.type):error = false;
  const State.error():type = null,error = true;
}

enum CharacterTypes {
  digit,
  zero,
  one,
  hexadecimalChars,
  xAny,
  nAny,
  floater,
  space,
  newline,
  str,
  apos,
  equal,
  semicolon,
  backslash,
  leftBracket,
  comma,
  rightBracket,
  leftBrace,
  colon,
  rightBrace,
  character,
}

class Scanner {
  final String fileContents;
  bool devMode;

  // ignore: prefer_final_fields
  int _index = 0;
  int _start = -1;
  State _state = State.whitespace;
  List<Token> list = [];

  Scanner(this.fileContents,{bool dev = false}):devMode = dev;

  static const digit = {zero, one, "2", "3", "4", "5", "6", "7", "8", "9"};
  static const zero = "0";
  static const floater = ".";
  static const one = "1";
  static const hexadecimal = {
    zero,
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "a",
    "A",
    "b",
    "B",
    "c",
    "C",
    "d",
    "D",
    "e",
    "E",
    "f",
    "F",
  };
  static const voidId = {"void","null"};
  static const binInit = {"n","N"};
  static const hexInit = {"x","X"};
  static const octInit = {"t","T"};
  static const space = " ";
  static const newline = "\n";
  static const whitespace = {space,newline};
  static const equal = "=";
  static const breaker = ";";
  static const seperator = ",";
  static const mapper = ":";
  static const listLeft = "[";
  static const listRight = "]";
  static const containerLeft = "{";
  static const containerRight = "}";
  static const stringMarker = "\"";
  static const charMarker = "'";
  static const escape = "\\";
  static const charLow = {"a","b","c","d","e","f",
    "g","h","i","j","k","l",
    "m","n","o","p","q","r",
    "s","t","u","v","w","x","y","z"};
  static const charHigh = {"A","B","C","D","E","F",
    "G","H","I","J","K","L",
    "M","N","O","P","Q","R",
    "S","T","U","V","W","X","Y","Z"};

  static List<Token> scan(String fileContents,{bool dev = false}) {
    Scanner scanner = Scanner(fileContents,dev:dev);
    return scanner._scan();
  }

  static CharacterTypes character(String char) {
    if (char == space) {
      return CharacterTypes.space;
    }
    else if (char == newline) {
      return CharacterTypes.newline;
    }
    else if (char == zero) {
      return CharacterTypes.zero;
    }
    else if (char == one) {
      return CharacterTypes.one;
    }
    else if (digit.contains(char)) {
      return CharacterTypes.digit;
    }
    else if (char == floater) {
      return CharacterTypes.floater;
    }
    else if (binInit.contains(char)) {
      return CharacterTypes.nAny;
    }
    else if (hexInit.contains(char)) {
      return CharacterTypes.xAny;
    }
    else if (hexadecimal.contains(char)) {
      return CharacterTypes.hexadecimalChars;
    }
    else if (char == equal) {
      return CharacterTypes.equal;
    }
    else if (char == breaker) {
      return CharacterTypes.semicolon;
    }
    else if (char == seperator) {
      return CharacterTypes.comma;
    }
    else if (char == mapper) {
      return CharacterTypes.colon;
    }
    else if (char == listLeft) {
      return CharacterTypes.leftBracket;
    }
    else if (char == listRight) {
      return CharacterTypes.rightBracket;
    }
    else if (char == containerLeft) {
      return CharacterTypes.leftBrace;
    }
    else if (char == containerRight) {
      return CharacterTypes.rightBrace;
    }
    else if (char == stringMarker) {
      return CharacterTypes.str;
    }
    else if (char == charMarker) {
      return CharacterTypes.apos;
    }
    else if (char == escape) {
      return CharacterTypes.backslash;
    }
    else if (charLow.contains(char) || charHigh.contains(char)) {
      return CharacterTypes.character;
    }
    else {throw "$char is not a valid character in AXW files";}
  }

  List<Token> _scan() {
    while (_index < fileContents.length) {
      String char = fileContents[_index];
      CharacterTypes ct = character(char);
      switch (ct) {
        case CharacterTypes.digit: {
          switch (_state) {
            case State.zero: {_state = State.integer;}
            case State.hexadecimal:
            case State.float:
            case State.stringIn:
            case State.charIn:
            case State.identifier:
            case State.integer: {}
            case State.escapeString: {_state = State.stringIn;}
            case State.escapeChar: {_state = State.stringOut;}
            case _: {
              flush();
              _state = State.integer;
              _print("initializing integer with: '$char'");
            }
          }
        }
        case CharacterTypes.zero: {
          switch (_state) {
            case State.zero: {_state = State.integer;}
            case State.integer:
            case State.identifier:
            case State.float:
            case State.binary:
            case State.stringIn:
            case State.charIn:
            case State.hexadecimal: {}
            case State.escapeString: {_state = State.stringIn;}
            case State.escapeChar: {_state = State.charIn;}
            case _: {
              flush();
              _state = State.zero;
            }
          }
        }
        case CharacterTypes.one: {
          switch (_state) {
            case State.zero: {_state = State.integer;}
            case State.integer:
            case State.identifier:
            case State.float:
            case State.binary:
            case State.stringIn:
            case State.charIn:
            case State.hexadecimal: {}
            case State.escapeString: {_state = State.stringIn;}
            case State.escapeChar: {_state = State.charIn;}
            case _: {
              flush();
              _state = State.integer;
            }
          }
        }
        case CharacterTypes.hexadecimalChars: {
          switch (_state) {
            case State.hexadecimal:
            case State.stringIn:
            case State.charIn:
            case State.identifier: {}
            case State.escapeString: {_state = State.stringIn;}
            case State.escapeChar: {_state = State.charIn;}
            case _: {
              flush();
              _state = State.identifier;
            }
          }
        }
        case CharacterTypes.xAny: {
          switch (_state) {
            case State.stringIn:
            case State.charIn:
            case State.identifier: {}
            case State.zero: {_state = State.hexadecimal;}
            case State.escapeString: {_state = State.stringIn;}
            case State.escapeChar: {_state = State.charIn;}
            case _:
              flush();
              _state = State.identifier;
          }
        }
        case CharacterTypes.nAny: {
          switch (_state) {
            case State.zero: {_state = State.binary;}
            case State.stringIn:
            case State.identifier:
            case State.charIn: {}
            case State.escapeString: {_state = State.stringIn;}
            case State.escapeChar: {_state = State.charIn;}
            case _:
              flush();
              _state = State.identifier;
          }
        }
        case CharacterTypes.floater: {
          switch (_state) {
            case State.stringIn:
            case State.charIn:
            case State.identifier: {}
            case State.integer:
            case State.zero: {_state = State.float;}
            case State.float:
              throw "can't have multiple '.' in a float";
            case State.escapeString: {_state = State.stringIn;}
            case State.escapeChar: {_state = State.charIn;}
            case _:
              flush();
              _state = State.float;
          }
        }
        case CharacterTypes.space: {
          switch (_state) {
            case State.whitespace:
            case State.charIn:
            case State.stringIn: {}
            case _: {
              flush();
              _state = State.whitespace;
            }
          }
        }
        case CharacterTypes.newline: {
          switch (_state) {
            case State.whitespace: {}
            case _: {
              flush();
              _state = State.whitespace;
            }
          }
        }
        case CharacterTypes.str: {
          switch (_state) {
            case State.stringIn: {_state = State.stringOut;}
            case State.charIn: {}
            case State.escapeString: {_state = State.stringIn;}
            case State.escapeChar: {_state = State.stringOut;}
            case _: {
              flush();
              _state = State.stringIn;
            }
          }
        }
        case CharacterTypes.apos: {
          // TODO: Handle this case.
          throw UnimplementedError();
        }
        case CharacterTypes.equal: {
          switch (_state) {
            case State.stringIn:
            case State.charIn: {}
            case State.escapeString: {_state = State.stringIn;}
            case State.escapeChar: {_state = State.charIn;}
            case _: {
              flush();
              _state = State.equal;
            }
          }
        }
        case CharacterTypes.semicolon: {
          switch (_state) {
            case State.stringIn:
            case State.charIn: {}
            case State.escapeString: {_state = State.charIn;}
            case State.escapeChar: {_state = State.stringIn;}
            case _: {
              flush();
              _state = State.semicolon;
            }
          }
        }
        case CharacterTypes.backslash: {
          // TODO: Handle this case.
          throw UnimplementedError();
        }
        case CharacterTypes.leftBracket: {
          switch (_state) {
            case State.stringIn:
            case State.charIn: {}
            case State.escapeString: {_state = State.stringIn;}
            case State.escapeChar: {_state = State.charIn;}
            case _:
              flush();
              _state = State.listStart;
          }
        }
        case CharacterTypes.comma: {
          switch (_state) {
            case State.stringIn:
            case State.charIn: {}
            case State.escapeString: {_state = State.stringIn;}
            case State.escapeChar: {_state = State.charIn;}
            case _:
              flush();
              _state = State.comma;
          }
        }
        case CharacterTypes.rightBracket: {
          switch (_state) {
            case State.stringIn:
            case State.charIn: {}
            case State.escapeString: {_state = State.stringIn;}
            case State.escapeChar: {_state = State.charIn;}
            case _:
              flush();
              _state = State.listEnd;
          }
        }
        case CharacterTypes.leftBrace: {
          switch (_state) {
            case State.charIn:
            case State.stringIn: {}
            case State.escapeString: {_state = State.stringIn;}
            case State.escapeChar: {_state = State.charIn;}
            case _:
              flush();
              _state = State.blockStart;
          }
        }
        case CharacterTypes.colon: {
          // TODO: Handle this case.
          throw UnimplementedError();
        }
        case CharacterTypes.rightBrace: {
          switch (_state) {
            case State.charIn:
            case State.stringIn: {}
            case State.escapeString: {_state = State.stringIn;}
            case State.escapeChar: {_state = State.charIn;}
            case _:
              flush();
              _state = State.blockEnd;
          }
        }
        case CharacterTypes.character: {
          switch (_state) {
            case State.stringIn:
            case State.identifier:
            case State.charIn: {}
            case State.escapeChar: {_state = State.charIn;}
            case State.escapeString: {_state = State.stringIn;}
            case _:
              flush();
              _state = State.identifier;
          }
        }
      }
      _index++;
    }
    flush();
    return list;
  }
  /*List<Token> scanFile() {
    String char = fileContents[_index];
    String subst = fileContents.substring(_start, _index);
    while (_index < fileContents.length) {
      char = fileContents[_index];
      subst = fileContents.substring(_start, _index);
      switch (_state) {
        case State.unknown:
        case State.space:
          scanSpace();
        case State.newline:
          throw UnimplementedError();
        case State.identifier:
          throw UnimplementedError();
        case State.zero:
          throw UnimplementedError();
        case State.integer:
          throw UnimplementedError();
        case State.float:
          throw UnimplementedError();
        case State.hexadecimal:
          throw UnimplementedError();
        case State.binary:
          throw UnimplementedError();
        case State.semicolon:
          throw UnimplementedError();
        case State.equal:
          throw UnimplementedError();
        case State.stringIn:
          throw UnimplementedError();
        case State.stringOut:
          throw UnimplementedError();
        case State.charIn:
          throw UnimplementedError();
        case State.charOut:
          throw UnimplementedError();
        case State.escape:
          throw UnimplementedError();
        case State.listStart:
          throw UnimplementedError();
        case State.comma:
          throw UnimplementedError();
        case State.listEnd:
          throw UnimplementedError();
        case State.dictStart:
          throw UnimplementedError();
        case State.colon:
          throw UnimplementedError();
        case State.dictEnd:
          throw UnimplementedError();
      }
      _index++;
    }
    subst = fileContents.substring(_start, _index);
    switch (_state) {
      case State.unknown:
        break;
      case State.space:
        break;
      case State.newline:
        break;
      case State.identifier:
        list.add(Token(subst, TokenType.identifier, _start));
      case State.zero:
      case State.integer:
        list.add(Token(subst, TokenType.integer, _start));
      case State.float:
        list.add(Token(subst, TokenType.float, _start));
      case State.hexadecimal:
        list.add(Token(subst, TokenType.hexadecimal, _start));
      case State.binary:
        list.add(Token(subst, TokenType.binary, _start));
      case State.semicolon:
        list.add(Token(subst, TokenType.semicolon, _start));
      case State.equal:
        list.add(Token(subst, TokenType.equal, _start));
      case State.stringIn:
        list.add(
          Token(
            fileContents.substring(_start + 1, _index),
            TokenType.string,
            _start,
          ),
        );
      case State.stringOut:
        list.add(
          Token(
            fileContents.substring(_start + 1, _index - 1),
            TokenType.string,
            _start,
          ),
        );
      case State.charIn:
        list.add(
          Token(
            fileContents.substring(_start + 1, _index),
            TokenType.char,
            _start,
          ),
        );
      case State.charOut:
        list.add(
          Token(
            fileContents.substring(_start + 1, _index - 1),
            TokenType.char,
            _start,
          ),
        );
      case State.escape:
        break;
        throw "expected non-end after after \\ [$_start:$_index]";
      case State.listStart:
        list.add(Token(subst, TokenType.leftBracket, _start));
      case State.comma:
        list.add(Token(subst, TokenType.comma, _start));
      case State.listEnd:
        list.add(Token(subst, TokenType.rightBracket, _start));
      case State.dictStart:
        list.add(Token(subst, TokenType.leftBrace, _start));
      case State.colon:
        list.add(Token(subst, TokenType.colon, _start));
      case State.dictEnd:
        list.add(Token(subst, TokenType.rightBrace, _start));
    }
    return list;
  }*/

  void scanSpace() {
    String char = fileContents[_index];
    if (char == space || char == newline) {}
  }
  /*void scanSpace() {
    String subst = fileContents.substring(_start,_index);
    switch (_state) {
      case State.unknown:
        _state = State.space;
      case State.space:
        break;
      case State.newline:
        break;
      case State.identifier:
        list.add(Token(subst, TokenType.identifier, _start));
      case State.zero:
        list.add(Token(subst, TokenType.integer, _start));
        _state = State.space;
      case State.integer:
        list.add(Token(subst, TokenType.integer, _start));
        _state = State.space;
      case State.float:
        list.add(Token(subst, TokenType.float, _start));
        _state = State.space;
      case State.hexadecimal:
        list.add(Token(subst, TokenType.hexadecimal, _start));
        _state = State.space;
      case State.binary:
        list.add(Token(subst, TokenType.binary, _start));
        _state = State.space;
      case State.semicolon:
        list.add(Token(subst, TokenType.semicolon, _start));
        _state = State.space;
      case State.equal:
        list.add(Token(subst, TokenType.equal, _start));
        _state = State.space;
      case State.stringIn:
        break;
      case State.stringOut:
        list.add(
          Token(
            fileContents.substring(_start, _index - 1),
            TokenType.string,
            _start,
          ),
        );
        _state = State.space;
      case State.charIn:
        break;
      case State.charOut:
        list.add(
          Token(
            fileContents.substring(_start, _index - 1),
            TokenType.char,
            _start,
          ),
        );
        _state = State.space;
      case State.escape:
        break;
      case State.listStart:
        list.add(Token(subst, TokenType.leftBracket, _start));
        _state = State.space;
      case State.comma:
        list.add(Token(subst, TokenType.comma, _start));
        _state = State.space;
      case State.listEnd:
        list.add(Token(subst, TokenType.rightBracket, _start));
        _state = State.space;
      case State.dictStart:
        list.add(Token(subst, TokenType.leftBrace, _start));
        _state = State.space;
      case State.colon:
        list.add(Token(subst, TokenType.colon, _start));
        _state = State.space;
      case State.dictEnd:
        list.add(Token(subst, TokenType.rightBrace, _start));
        _state = State.space;
    }
  }*/
  /*/// guesses what state it is without context
  State get state {
    String char = fileContents[_index];
    if (whitespace.contains(char)) {return State.whitespace;}
    else if (char == equal) {return State.equal;}
    else if (char == breaker) {return State.semicolon;}
    else if (char == zero) {return State.zero;}
    else if (digit.contains(char)) {return State.integer;}
    else if (hexadecimal.contains(char)) {return State.hexadecimal;}
    else if (char == seperator) {return State.comma;}
    else if (char == mapper) {return State.colon;}
    else if (char == escape) {return State.escape;}
    else if (char == listLeft) {return State.listStart;}
    else if (char == listDesc[1]) {return State.listEnd;}
    else if (char == dictDesc[0]) {return State.dictStart;}
    else if (char == dictDesc[1]) {return State.dictEnd;}
    else if (char == stringMarker) {return State.stringIn;}
    else if (char == charMarker) {return State.charIn;}
    else {return State.identifier;}
  }
  void setState() {_state = state;}*/
  /// ends current state and adds it, if it is a valid adder
  void flush() {
    if (_state.error) {throw IncompleteToken();}
    TokenType? tokenType = _state.type;
    if (tokenType != null) {
      String subst = fileContents.substring(_start,_index);
      if (voidId.contains(subst)) {list.add(Token(subst,TokenType.none,_start));}
      else {list.add(Token(subst, tokenType, _start));}
      _print("completed token: '${tokenType.name}':'$subst'");
    }
    _start = _index;
  }
  /// prints if devMode is true
  void _print(String contents) {
    if (devMode) {print(contents);}
  }
/*void _printf(String contents) {
    if (devMode) {stdout.write(contents);}
  }*/
/*void flush() {
    String char = fileContents[_index];
    switch (_state) {
      case State.unknown:
        throw "can't flush $_state";
      case State.space:
      case State.newline:
        while (_state == State.space || _state == State.newline) {
          _index++;
          setState();
        }
      case State.identifier:
        while (charLow.contains(char)
            || charHigh.contains(char)
            || digit.contains(char)) {
          char = fileContents[++_index];
        }
        list.add(Token(fileContents.substring(_start,_index),TokenType.identifier,_start));
      case State.zero:
        throw "can't flush $_state";
      case State.integer:
        throw "can't flush $_state";
      case State.float:
        while (digit.contains(char)) {
          char = fileContents[++_index];
        }
        list.add(Token(fileContents.substring(_start,_index),TokenType.float,_start));
      case State.hexadecimal:
        while (hexadecimal.contains(char)) {
          char = fileContents[++_index];
        }
        list.add(Token(fileContents.substring(_start,_index),TokenType.hexadecimal,_start));
      case State.binary:
        while (binary.contains(char)) {
          char = fileContents[++_index];
        }
        list.add(Token(fileContents.substring(_start,_index),TokenType.binary,_start));
      case State.semicolon:
        list.add(Token(fileContents.substring(_start,_index),TokenType.semicolon,_start));
      case State.equal:
        list.add(Token(fileContents.substring(_start,_index),TokenType.equal,_start));
      case State.stringIn:
        while (char != stringDesc) {
          char = fileContents[++_index];
        }
        list.add(Token(fileContents.substring(_start+1)))
      case State.stringOut:
        throw "can't flush $_state";
      case State.charIn:
        throw UnimplementedError();
      case State.charOut:
        throw UnimplementedError();
      case State.escape:
        throw UnimplementedError();
      case State.listStart:
        throw UnimplementedError();
      case State.comma:
        throw UnimplementedError();
      case State.listEnd:
        throw UnimplementedError();
      case State.dictStart:
        throw UnimplementedError();
      case State.colon:
        throw UnimplementedError();
      case State.dictEnd:
        throw UnimplementedError();
    }
  }*/
}
