/// The package for the function [printf] & [printg]
library;

import 'dart:io';
import 'src/standard.dart';

/// Prints out to to the console with [stdout]`.`[write]`()`.
///
/// send in the input from [input], and the objects/nulls from [items].
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
/// Added in `2.7.3`.
void printf<E>(String input, [Iterable<E> items = const []]) {
  printg(scanf(input, items));
}

/// Added in `2.7.3`.
enum _State {
  //
  percentage,
  object,
  nullable,
  iterable,
  text,
  unknown,
}

/// Added in `2.7.3`.
enum _Char {
  //
  percent,
  o,
  n,
  a,
  text,
}

/// Added in `2.7.3`.
_Char _character(String char) => switch (char) {
  "%" => _Char.percent,
  "o" => _Char.o,
  "n" => _Char.n,
  "a" => _Char.a,
  String() => _Char.text,
};

/// Returns the formatted [String] from the according [input] and [items].
///
/// send in the input from [input], and the objects/nulls from [items].
///
/// `%o`, grabs the next [Object], which cannot be a [nullable].
/// (`v2.8`)
///
/// `%n`, grabs the next item, which can be [nullable].
/// (`v2.8`)
///
/// `%a`, grabs the next [Iterable].
/// (`v2.8`)
///
/// Added in `2.8`.
String scanf<E>(String input, [Iterable<E> items = const []]) {
  if (items.isEmpty) {
    return input;
  } else if (items is Iterable<Object>) {
    return _scanfSafe(input, items as Iterable<Object>);
  } else {
    return _scanfUnsafe(input, items);
  }
}

/// Added in `2.8`.
String _scanfSafe<E extends Object>(String input, Iterable<E> items) {
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

  /// the iterable offset
  int iterableOffset;

  pointer = starter = iterableOffset = 0;

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
          case _State.object:
          case _State.nullable:
            heldValue = objects.first;
            output += heldValue.toString();
            objects.removeAt(0);
            iterableOffset = cut(val: iterableOffset, max: objects.length - 1);
            state = _State.percentage;
            starter = pointer;
          case _State.iterable:
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
        }
      case _Char.o:
        switch (state) {
          case _State.percentage:
            state = _State.object;
          case _State.object:
          case _State.nullable:
            heldValue = objects.first;
            output += heldValue.toString();
            objects.removeAt(0);
            iterableOffset = cut(val: iterableOffset, max: objects.length - 1);
            state = _State.text;
            starter = pointer;
          case _State.iterable:
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
        }
      case _Char.n:
        switch (state) {
          case _State.percentage:
            state = _State.nullable;
          case _State.object:
          case _State.nullable:
            heldValue = objects.first;
            output += heldValue.toString();
            objects.removeAt(0);
            iterableOffset = cut(val: iterableOffset, max: objects.length - 1);
            state = _State.text;
            starter = pointer;
          case _State.iterable:
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
        }
      case _Char.a:
        switch (state) {
          case _State.percentage:
            state = _State.iterable;
          case _State.object:
          case _State.nullable:
            heldValue = objects.first;
            output += heldValue.toString();
            objects.removeAt(0);
            iterableOffset = cut(val: iterableOffset, max: objects.length - 1);
            state = _State.text;
            starter = pointer;
          case _State.iterable:
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
        }
      case _Char.text:
        switch (state) {
          case _State.percentage:
            break;
          case _State.object:
          case _State.nullable:
            heldValue = objects.first;
            output += heldValue.toString();
            objects.removeAt(0);
            iterableOffset = cut(val: iterableOffset, max: objects.length - 1);
            state = _State.text;
            starter = pointer;
          case _State.iterable:
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
        }
    }
    pointer++; // increments
  }
  switch (state) {
    case _State.percentage:
      output += input.substring(starter);
    case _State.object:
    case _State.nullable:
      heldValue = objects.first;
      output += heldValue.toString();
    case _State.iterable:
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
  }
  return output;
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
          case _State.object:
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
          case _State.nullable:
            heldValue = objects.first;
            output += heldValue.toString();
            objects.removeAt(0);
            objectOffset = cut(val: objectOffset, max: objects.length - 1);
            iterableOffset = cut(val: iterableOffset, max: objects.length - 1);
            state = _State.percentage;
            starter = pointer;
          case _State.iterable:
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
        }
      case _Char.o:
        switch (state) {
          case _State.percentage:
            state = _State.object;
          case _State.object:
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
          case _State.nullable:
            heldValue = objects.first;
            output += heldValue.toString();
            objects.removeAt(0);
            objectOffset = cut(val: objectOffset, max: objects.length - 1);
            iterableOffset = cut(val: iterableOffset, max: objects.length - 1);
            state = _State.text;
            starter = pointer;
          case _State.iterable:
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
        }
      case _Char.n:
        switch (state) {
          case _State.percentage:
            state = _State.nullable;
          case _State.object:
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
          case _State.nullable:
            heldValue = objects.first;
            output += heldValue.toString();
            objects.removeAt(0);
            objectOffset = cut(val: objectOffset, max: objects.length - 1);
            iterableOffset = cut(val: iterableOffset, max: objects.length - 1);
            state = _State.text;
            starter = pointer;
          case _State.iterable:
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
        }
      case _Char.a:
        switch (state) {
          case _State.percentage:
            state = _State.iterable;
          case _State.object:
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
          case _State.nullable:
            heldValue = objects.first;
            output += heldValue.toString();
            objects.removeAt(0);
            objectOffset = cut(val: objectOffset, max: objects.length - 1);
            iterableOffset = cut(val: iterableOffset, max: objects.length - 1);
            state = _State.text;
            starter = pointer;
          case _State.iterable:
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
        }
      case _Char.text:
        switch (state) {
          case _State.percentage:
          case _State.object:
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
          case _State.nullable:
            heldValue = objects.first;
            output += heldValue.toString();
            objects.removeAt(0);
            objectOffset = cut(val: objectOffset, max: objects.length - 1);
            iterableOffset = cut(val: iterableOffset, max: objects.length - 1);
            state = _State.text;
            starter = pointer;
          case _State.iterable:
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
        }
    }
    pointer++; // increments
  }
  switch (state) {
    case _State.percentage:
      output += input.substring(starter);
    case _State.object:
      while (true) {
        heldValue = objects[objectOffset];
        if (heldValue is Object) {
          output += heldValue.toString();
          break;
        } else {
          objectOffset++;
        }
      }
    case _State.nullable:
      heldValue = objects.first;
      output += heldValue.toString();
    case _State.iterable:
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
  }
  return output;
}

/// The sequel to [printf], this takes only input and just does output.
void printg(String input) {
  stdout.write(input);
}

/// [printg] but it has some more computation before sending it.
void printh(Object? input) {
  printg(input.toString());
}
