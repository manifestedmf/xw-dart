/// The package for the function [printf] & [printg]
///
/// Added in `2.7.3`.
library xw.printf;

import 'dart:core' show String, Iterable, Object, List, int, UnimplementedError;
import 'dart:io' show stdout;
import 'src/standard.dart' show cut, grow;
import 'src/extension.dart' show ListE;

/// Prints out to to the console with [stdout]`.`[write]`()`.
///
/// Send in the input from [input], and the `object?`s from [items].
///
/// Adding some digits to the end of a `%?#`
/// will make it extend with spaces after till it is that long.
/// (`v2.8`)
///
/// Adding some digits to the middle of a `%#?`
/// will make it extend with spaces before till it is that long.
/// (`v2.8`)
///
/// `%o`, grabs the next [Object], which cannot be a [nullable].
/// (`v2.7.3`)
///
/// `%n`, grabs the next item, which can be [nullable].
/// (`v2.7.3`)
///
/// `%a`, grabs the next [Iterable].
/// (`v2.8`)
///
/// `%s`, grabs the next [String].
/// (`v2.8`)
///
/// Added in `2.7.3`.
void printf<E>(String input, [Iterable<E> items = const []]) {
  printg(scanf(input, items));
}

/// Prints with [printf], but with a forced line at the end.
///
/// Added in `2.8`.
void printfln<E>(String input, [Iterable<E> items = const []]) =>
    printf(input + "\n", items);

/// Prints with a new line at the end.
///
/// Added in `2.8`.
void println(Object? input) => printg(input.toString() + "\n");

/// Added in `2.7.3`.
enum _State {
  /// `2.7.3`
  percentage,

  /// `2.8`.
  percentageBefore,

  /// `2.7.3`
  objectAfter,

  /// `2.7.3`
  nullableAfter,

  /// `2.8`
  iterableAfter,

  /// `2.8`
  stringAfter,

  /// `2.8
  objectBefore,

  /// `2.8`
  nullableBefore,

  /// `2.8`
  iterableBefore,

  /// `2.8`
  stringBefore,

  /// `2.7.3`
  text,

  /// `2.7.3`
  unknown,
}

/// Added in `2.7.3`.
enum _Char {
  /// `'%'`
  ///
  /// Initializer for other items.
  ///
  /// `2.7.3`
  percent,

  /// `'%o'`
  ///
  /// [Object].
  ///
  /// `2.7.3`
  object,

  /// `'%n'`
  ///
  /// [Object?].
  ///
  /// `2.7.3`
  nullable,

  /// `'%a'`
  ///
  /// [Iterable].
  ///
  /// `2.8`
  array,

  /// `'%s'`
  ///
  /// [String].
  ///
  /// `2.8`.
  string,

  /// `2.7.3`
  text,

  /// `2.8`
  digit,

  /// `2.8`
  newline,
}

/// Added in `2.7.3`.
_Char _character(String char) => switch (char) {
  "%" => _Char.percent,
  "o" => _Char.object,
  "n" => _Char.nullable,
  "a" => _Char.array,
  "s" => _Char.string,
  "0" => _Char.digit,
  "1" => _Char.digit,
  "2" => _Char.digit,
  "3" => _Char.digit,
  "4" => _Char.digit,
  "5" => _Char.digit,
  "6" => _Char.digit,
  "7" => _Char.digit,
  "8" => _Char.digit,
  "9" => _Char.digit,
  "\n" => _Char.newline,
  String() => _Char.text,
};

/// Returns the formatted [String] from the according [input] and [items].
///
/// Send in the input from [input], and the `object?`s from [items].
///
/// Adding some digits to the end of a `%?#`
/// will make it extend with spaces after till it is that long.
/// (`v2.8`)
///
/// Adding some digits to the middle of a `%#?`
/// will make it extend with spaces before till it is that long.
/// (`v2.8`)
///
/// `%o`, grabs the next [Object], which cannot be a [nullable].
/// (`v2.7.3`)
///
/// `%n`, grabs the next item, which can be [nullable].
/// (`v2.7.3`)
///
/// `%a`, grabs the next [Iterable].
/// (`v2.8`)
///
/// `%s`, grabs the next [String].
/// (`v2.8`)
///
/// Added in `2.7.3`.
String scanf<E>(String input, [Iterable<E> items = const []]) {
  if (items.isEmpty) {
    return input;
  } else if (items is Iterable<Object>) {
    return _scanfSafe.init(input, items as Iterable<Object>);
  } else {
    return _scanfUnsafe(input, items);
  }
}

// FIXME: add digits before, to be the current and add digits after.

/// Added in `2.8`.
class _scanfSafe<E extends Object> {
  /// Added in `2.8`.
  final String input;

  /// Added in `2.8`.
  List<E> objects;

  /// Added in `2.8`.
  String output = "";

  /// which state we were in
  ///
  /// Added in `2.8`.
  _State state = _State.unknown;

  /// the current character state
  ///
  /// Added in `2.8`.
  late _Char currentChar;

  /// the pointer to which index we are for the input
  ///
  /// Added in `2.8`.
  int pointer = 0;

  /// the start of the text or item that we are currently holding
  ///
  /// Added in `2.8`.
  int starter = 0;

  /// the iterable offset
  ///
  /// Added in `2.8`.
  int iterableOffset = 0;

  /// The String offset
  ///
  /// Added in `2.8`.
  int stringOffset = 0;

  /// the current char
  ///
  /// Added in `2.8`.
  late String char;

  /// the value that we are trying to inspect
  ///
  /// Added in `2.8`.
  late E heldValue;

  /// The amount of spaces this currently needs.
  ///
  /// Added in `2.8`.
  int spaceAmount = 0;

  /// Current String
  ///
  /// Added in `2.8`.
  late String tempStr;

  /// current length of line
  ///
  /// Added in `2.8`.
  int lineLength = 0;

  _scanfSafe(this.input, this.objects);

  static String init<E extends Object>(String input, Iterable<E> items) =>
      _scanfSafe(input, items.toList()).scan();

  /// Added in `2.8`.
  String scan() {
    while (pointer < input.length) {
      char = input[pointer];
      currentChar = _character(char);
      switch (currentChar) {
        case _Char.percent:
          switch (state) {
            case _State.percentage:
              output += "%";
              lineLength++;
              starter = pointer;
              state = _State.text;
            case _State.percentageBefore:
            case _State.objectAfter:
            case _State.nullableAfter:
            case _State.iterableAfter:
            case _State.stringAfter:
            case _State.objectBefore:
            case _State.nullableBefore:
            case _State.iterableBefore:
            case _State.stringBefore:
            case _State.text:
            case _State.unknown:
              flush();
              state = _State.percentage;
          }
        case _Char.object:
          switch (state) {
            case _State.percentage:
              state = _State.objectAfter;
            case _State.percentageBefore:
              state = _State.objectBefore;
            case _State.objectAfter:
            case _State.nullableAfter:
            case _State.iterableAfter:
            case _State.stringAfter:
            case _State.objectBefore:
            case _State.nullableBefore:
            case _State.iterableBefore:
            case _State.stringBefore:
              flush();
              state = _State.text;
            case _State.text:
              break;
            case _State.unknown:
              state = _State.text;
          }
        case _Char.nullable:
          switch (state) {
            case _State.percentage:
              state = _State.nullableAfter;
            case _State.percentageBefore:
              state = _State.nullableBefore;
            case _State.objectAfter:
            case _State.nullableAfter:
            case _State.iterableAfter:
            case _State.stringAfter:
            case _State.objectBefore:
            case _State.nullableBefore:
            case _State.iterableBefore:
            case _State.stringBefore:
              flush();
              state = _State.text;
            case _State.text:
              break;
            case _State.unknown:
              state = _State.text;
          }
        case _Char.array:
          switch (state) {
            case _State.percentage:
              state = _State.iterableAfter;
            case _State.percentageBefore:
              state = _State.iterableBefore;
            case _State.objectAfter:
            case _State.nullableAfter:
            case _State.iterableAfter:
            case _State.stringAfter:
            case _State.objectBefore:
            case _State.nullableBefore:
            case _State.iterableBefore:
            case _State.stringBefore:
              flush();
              state = _State.text;
            case _State.text:
              break;
            case _State.unknown:
              state = _State.text;
          }
        case _Char.string:
          switch (state) {
            case _State.percentage:
              state = _State.stringAfter;
            case _State.percentageBefore:
              state = _State.stringBefore;
            case _State.objectAfter:
            case _State.nullableAfter:
            case _State.iterableAfter:
            case _State.stringAfter:
            case _State.objectBefore:
            case _State.nullableBefore:
            case _State.iterableBefore:
            case _State.stringBefore:
              flush();
              state = _State.text;
            case _State.text:
              break;
            case _State.unknown:
              state = _State.text;
          }
        case _Char.text:
          switch (state) {
            case _State.percentage:
            case _State.percentageBefore:
              state = _State.text;
            case _State.objectAfter:
            case _State.nullableAfter:
            case _State.iterableAfter:
            case _State.stringAfter:
            case _State.objectBefore:
            case _State.nullableBefore:
            case _State.iterableBefore:
            case _State.stringBefore:
              flush();
              state = _State.text;
            case _State.text:
              break;
            case _State.unknown:
              state = _State.text;
          }
        case _Char.digit:
          switch (state) {
            case _State.percentage:
              state = _State.percentageBefore;
            case _State.percentageBefore:
            case _State.objectAfter:
            case _State.nullableAfter:
            case _State.iterableAfter:
            case _State.stringAfter:
              spaceAmount = spaceAmount * 10 + int.parse(char);
            case _State.objectBefore:
            case _State.nullableBefore:
            case _State.iterableBefore:
            case _State.stringBefore:
              flush();
              state = _State.text;
            case _State.text:
              break;
            case _State.unknown:
              state = _State.text;
          }
        case _Char.newline:
          switch (state) {
            case _State.percentage:
            case _State.percentageBefore:
            case _State.objectAfter:
            case _State.nullableAfter:
            case _State.iterableAfter:
            case _State.stringAfter:
            case _State.objectBefore:
            case _State.nullableBefore:
            case _State.iterableBefore:
            case _State.stringBefore:
              flush();
              state = _State.text;
            case _State.text:
              flush();
            case _State.unknown:
              state = _State.text;
          }
          lineLength = 0;
      }
      pointer++; // increments
    }
    flush();
    return output;
  }

  /// Gets info that the current state is done.
  ///
  /// [heldValue] & [tempStr] is gonna be set here.
  ///
  /// Added in `2.8`.
  void flush() {
    switch (state) {
      case _State.percentage:
      case _State.percentageBefore:
        tempStr = input.substring(starter, pointer);
      case _State.objectAfter:
      case _State.nullableAfter:
        heldValue = objects.removeFirst();
        tempStr = heldValue.toString();
        iterableOffset = cut(val: iterableOffset, max: objects.length - 1);
        stringOffset = cut(val: stringOffset, max: objects.length - 1);
        addSpacesAfter();
      case _State.iterableAfter:
        while (true) {
          heldValue = objects[iterableOffset];
          if (heldValue is Iterable) {
            break;
          } else {
            iterableOffset++;
          }
        }
        tempStr = heldValue.toString();
        addSpacesAfter();
        objects.removeAt(iterableOffset);
        iterableOffset = grow(val: iterableOffset - 1, min: 0);
        stringOffset = cut(val: stringOffset, max: objects.length - 1);
      case _State.stringAfter:
        while (true) {
          heldValue = objects[stringOffset];
          if (heldValue is String) {
            break;
          } else {
            stringOffset++;
          }
        }
        tempStr = heldValue as String;
        addSpacesAfter();
        objects.removeAt(stringOffset);
        stringOffset = grow(val: stringOffset - 1, min: 0);
        iterableOffset = cut(val: iterableOffset, max: objects.length - 1);
      case _State.objectBefore:
      case _State.nullableBefore:
        heldValue = objects.removeFirst();
        tempStr = heldValue.toString();
        iterableOffset = cut(val: iterableOffset, max: objects.length - 1);
        stringOffset = cut(val: stringOffset, max: objects.length - 1);
        addSpacesBefore();
      case _State.iterableBefore:
        while (true) {
          heldValue = objects[iterableOffset];
          if (heldValue is Iterable) {
            break;
          } else {
            iterableOffset++;
          }
        }
        tempStr = heldValue.toString();
        addSpacesBefore();
        objects.removeAt(iterableOffset);
        iterableOffset = grow(val: iterableOffset - 1, min: 0);
        stringOffset = cut(val: stringOffset, max: objects.length - 1);
      case _State.stringBefore:
        while (true) {
          heldValue = objects[stringOffset];
          if (heldValue is String) {
            break;
          } else {
            stringOffset++;
          }
        }
        tempStr = heldValue as String;
        addSpacesBefore();
        objects.removeAt(stringOffset);
        stringOffset = grow(val: stringOffset - 1, min: 0);
        iterableOffset = cut(val: iterableOffset, max: objects.length - 1);
      case _State.text:
        tempStr = input.substring(starter, pointer);
      case _State.unknown:
        return;
    }
    output += tempStr;
    lineLength += tempStr.length;
    starter = pointer;
    spaceAmount = 0;
  }

  /// Added in `2.8`.
  void addSpacesAfter() {
    while (tempStr.length < spaceAmount - lineLength) {
      tempStr += " ";
    }
  }

  /// Added in `2.8`.
  void addSpacesBefore() {
    while (tempStr.length < spaceAmount - lineLength) {
      tempStr = " " + tempStr;
    }
  }
}

/// Added in `2.8`.
String _scanfUnsafe<E>(String input, Iterable<E> items) {
  String output = "";

  /// makes items removable
  List<E> objects = items.toList();

  /// which state we were in
  _State state = _State.unknown;

  /// the current character state
  _Char currentChar;

  /// the pointer to which index we are for the input
  int pointer;

  /// the start of the text or item that we are currently holding
  int starter;

  /// the object offset
  int objectOffset;

  /// the iterable offset
  int iterableOffset;

  pointer = starter = objectOffset = iterableOffset = 0;

  /// the current char
  String char;

  /// the value that we are trying to inspect
  E heldValue;
  while (pointer < input.length) {
    char = input[pointer];
    currentChar = _character(char);
    switch (currentChar) {
      case _Char.percent:
        switch (state) {
          case _State.percentage:
            state = _State.text;
          case _State.objectAfter:
            while (true) {
              heldValue = objects[objectOffset];
              if (heldValue is Object) {
                output += heldValue.toString();
                objects.removeAt(objectOffset);
                break;
              } else {
                objectOffset++;
                iterableOffset++;
              }
            }
            state = _State.percentage;
            starter = pointer;
          case _State.nullableAfter:
            heldValue = objects.first;
            output += heldValue.toString();
            objects.removeAt(0);
            objectOffset = cut(val: objectOffset, max: objects.length - 1);
            iterableOffset = cut(val: iterableOffset, max: objects.length - 1);
            state = _State.percentage;
            starter = pointer;
          case _State.iterableAfter:
            while (true) {
              heldValue = objects[iterableOffset];
              if (heldValue is Iterable) {
                output += heldValue.toString();
                objects.removeAt(iterableOffset);
                break;
              } else {
                iterableOffset++;
              }
            }
            state = _State.percentage;
            starter = pointer;
          case _State.text:
            output += input.substring(starter, pointer);
            state = _State.percentage;
            starter = pointer;
          case _State.unknown:
            state = _State.percentage;
            starter = pointer;
          case _State.percentageBefore:
            // TODO: Handle this case.
            throw UnimplementedError();
          case _State.stringAfter:
            // TODO: Handle this case.
            throw UnimplementedError();
          case _State.objectBefore:
            // TODO: Handle this case.
            throw UnimplementedError();
          case _State.nullableBefore:
            // TODO: Handle this case.
            throw UnimplementedError();
          case _State.iterableBefore:
            // TODO: Handle this case.
            throw UnimplementedError();
          case _State.stringBefore:
            // TODO: Handle this case.
            throw UnimplementedError();
        }
      case _Char.object:
        switch (state) {
          case _State.percentage:
            state = _State.objectAfter;
          case _State.objectAfter:
            while (true) {
              heldValue = objects[objectOffset];
              if (heldValue is Object) {
                output += heldValue.toString();
                objects.removeAt(objectOffset);
                break;
              } else {
                objectOffset++;
                iterableOffset++;
              }
            }
            state = _State.text;
            starter = pointer;
          case _State.nullableAfter:
            heldValue = objects.first;
            output += heldValue.toString();
            objects.removeAt(0);
            objectOffset = cut(val: objectOffset, max: objects.length - 1);
            iterableOffset = cut(val: iterableOffset, max: objects.length - 1);
            state = _State.text;
            starter = pointer;
          case _State.iterableAfter:
            while (true) {
              heldValue = objects[iterableOffset];
              if (heldValue is Iterable) {
                output += heldValue.toString();
                objects.removeAt(iterableOffset);
                break;
              } else {
                iterableOffset++;
              }
            }
            state = _State.text;
            starter = pointer;
          case _State.text:
            break;
          case _State.unknown:
            state = _State.text;
          case _State.percentageBefore:
            // TODO: Handle this case.
            throw UnimplementedError();
          case _State.stringAfter:
            // TODO: Handle this case.
            throw UnimplementedError();
          case _State.objectBefore:
            // TODO: Handle this case.
            throw UnimplementedError();
          case _State.nullableBefore:
            // TODO: Handle this case.
            throw UnimplementedError();
          case _State.iterableBefore:
            // TODO: Handle this case.
            throw UnimplementedError();
          case _State.stringBefore:
            // TODO: Handle this case.
            throw UnimplementedError();
        }
      case _Char.nullable:
        switch (state) {
          case _State.percentage:
            state = _State.nullableAfter;
          case _State.objectAfter:
            while (true) {
              heldValue = objects[objectOffset];
              if (heldValue is Object) {
                output += heldValue.toString();
                objects.removeAt(objectOffset);
                break;
              } else {
                objectOffset++;
                iterableOffset++;
              }
            }
            state = _State.text;
            starter = pointer;
          case _State.nullableAfter:
            heldValue = objects.first;
            output += heldValue.toString();
            objects.removeAt(0);
            objectOffset = cut(val: objectOffset, max: objects.length - 1);
            iterableOffset = cut(val: iterableOffset, max: objects.length - 1);
            state = _State.text;
            starter = pointer;
          case _State.iterableAfter:
            while (true) {
              heldValue = objects[iterableOffset];
              if (heldValue is Iterable) {
                output += heldValue.toString();
                objects.removeAt(iterableOffset);
                break;
              } else {
                iterableOffset++;
              }
            }
            state = _State.text;
            starter = pointer;
          case _State.text:
            break;
          case _State.unknown:
            state = _State.text;
          case _State.percentageBefore:
            // TODO: Handle this case.
            throw UnimplementedError();
          case _State.stringAfter:
            // TODO: Handle this case.
            throw UnimplementedError();
          case _State.objectBefore:
            // TODO: Handle this case.
            throw UnimplementedError();
          case _State.nullableBefore:
            // TODO: Handle this case.
            throw UnimplementedError();
          case _State.iterableBefore:
            // TODO: Handle this case.
            throw UnimplementedError();
          case _State.stringBefore:
            // TODO: Handle this case.
            throw UnimplementedError();
        }
      case _Char.array:
        switch (state) {
          case _State.percentage:
            state = _State.iterableAfter;
          case _State.objectAfter:
            while (true) {
              heldValue = objects[objectOffset];
              if (heldValue is Object) {
                output += heldValue.toString();
                objects.removeAt(objectOffset);
                break;
              } else {
                objectOffset++;
                iterableOffset++;
              }
            }
            state = _State.text;
            starter = pointer;
          case _State.nullableAfter:
            heldValue = objects.first;
            output += heldValue.toString();
            objects.removeAt(0);
            objectOffset = cut(val: objectOffset, max: objects.length - 1);
            iterableOffset = cut(val: iterableOffset, max: objects.length - 1);
            state = _State.text;
            starter = pointer;
          case _State.iterableAfter:
            while (true) {
              heldValue = objects[iterableOffset];
              if (heldValue is Iterable) {
                output += heldValue.toString();
                objects.removeAt(iterableOffset);
                break;
              } else {
                iterableOffset++;
              }
            }
            state = _State.text;
            starter = pointer;
          case _State.text:
            break;
          case _State.unknown:
            state = _State.text;
          case _State.percentageBefore:
            // TODO: Handle this case.
            throw UnimplementedError();
          case _State.stringAfter:
            // TODO: Handle this case.
            throw UnimplementedError();
          case _State.objectBefore:
            // TODO: Handle this case.
            throw UnimplementedError();
          case _State.nullableBefore:
            // TODO: Handle this case.
            throw UnimplementedError();
          case _State.iterableBefore:
            // TODO: Handle this case.
            throw UnimplementedError();
          case _State.stringBefore:
            // TODO: Handle this case.
            throw UnimplementedError();
        }
      case _Char.text:
        switch (state) {
          case _State.percentage:
          case _State.objectAfter:
            while (true) {
              heldValue = objects[objectOffset];
              if (heldValue is Object) {
                output += heldValue.toString();
                objects.removeAt(objectOffset);
                break;
              } else {
                objectOffset++;
                iterableOffset++;
              }
            }
            state = _State.text;
            starter = pointer;
          case _State.nullableAfter:
            heldValue = objects.first;
            output += heldValue.toString();
            objects.removeAt(0);
            objectOffset = cut(val: objectOffset, max: objects.length - 1);
            iterableOffset = cut(val: iterableOffset, max: objects.length - 1);
            state = _State.text;
            starter = pointer;
          case _State.iterableAfter:
            while (true) {
              heldValue = objects[iterableOffset];
              if (heldValue is Iterable) {
                output += heldValue.toString();
                objects.removeAt(iterableOffset);
                break;
              } else {
                iterableOffset++;
              }
            }
            state = _State.text;
            starter = pointer;
          case _State.text:
            break;
          case _State.unknown:
            state = _State.text;
          case _State.percentageBefore:
            // TODO: Handle this case.
            throw UnimplementedError();
          case _State.stringAfter:
            // TODO: Handle this case.
            throw UnimplementedError();
          case _State.objectBefore:
            // TODO: Handle this case.
            throw UnimplementedError();
          case _State.nullableBefore:
            // TODO: Handle this case.
            throw UnimplementedError();
          case _State.iterableBefore:
            // TODO: Handle this case.
            throw UnimplementedError();
          case _State.stringBefore:
            // TODO: Handle this case.
            throw UnimplementedError();
        }
      case _Char.digit:
        // TODO: Handle this case.
        throw UnimplementedError();
      case _Char.newline:
        // TODO: Handle this case.
        throw UnimplementedError();
      case _Char.string:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
    pointer++; // increments
  }
  switch (state) {
    case _State.percentage:
      output += input.substring(starter);
    case _State.objectAfter:
      while (true) {
        heldValue = objects[objectOffset];
        if (heldValue is Object) {
          output += heldValue.toString();
          break;
        } else {
          objectOffset++;
        }
      }
    case _State.nullableAfter:
      heldValue = objects.first;
      output += heldValue.toString();
    case _State.iterableAfter:
      while (true) {
        heldValue = objects[iterableOffset];
        if (heldValue is Iterable) {
          output += heldValue.toString();
          break;
        } else {
          iterableOffset++;
        }
      }
    case _State.text:
      output += input.substring(starter);
    case _State.unknown:
      break;
    case _State.percentageBefore:
      // TODO: Handle this case.
      throw UnimplementedError();
    case _State.stringAfter:
      // TODO: Handle this case.
      throw UnimplementedError();
    case _State.objectBefore:
      // TODO: Handle this case.
      throw UnimplementedError();
    case _State.nullableBefore:
      // TODO: Handle this case.
      throw UnimplementedError();
    case _State.iterableBefore:
      // TODO: Handle this case.
      throw UnimplementedError();
    case _State.stringBefore:
      // TODO: Handle this case.
      throw UnimplementedError();
  }
  return output;
}

/// The sequel to [printf], this takes only input and just does output.
///
/// Added in `2.7.3`.
void printg(String input) {
  stdout.write(input);
}

/// [printg] but it has some more computation before sending it.
///
/// Added in `2.7.3`.
void printh(Object? input) {
  printg(input.toString());
}
