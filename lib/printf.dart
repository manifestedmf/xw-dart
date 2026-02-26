/// The package for the function [printf] & [printg]
library;

import 'dart:io';

/// Prints out to to the console with [stdout]`.`[write]`()`.
///
/// send in the input from [input], and the objects/nulls from [items].
///
/// `%o`, grabs the next [Object], which cannot be a [nullable].
///
/// `%n`, grabs the next item, which can be [nullable].
void printf(String input, [Iterable<Object?> items = const []]) {
  if (items == []) {
    printg(input);
    return;
  }
  String output = "";
  List<Object?> objects = items.toList(); // makes items removable
  _State state = _State.unknown; // which state we were in
  _Char currentChar; // the current character state
  int pointer = 0; // the pointer to which index we are for the input
  int starter = 0; // the start of the text or item that we are currently holding
  int offset = 0; // the offset between nullable and object characters
  String char; // the current char
  Object? heldValue; // the value that we are trying to inspect
  while (pointer < input.length) {
    char = input[pointer];
    currentChar = _character(char);
    switch (currentChar) {
      case _Char.percent: {
        switch (state) {
          case _State.percentage: {
            state = _State.text;
          }
          case _State.object: {
            while (true) {
              heldValue = objects[offset];
              if (heldValue == null) {
                offset++;
              } else {
                break;
              }
            }
            output += heldValue.toString();
            objects.removeAt(offset);
            state = _State.percentage;
            starter = pointer;
          }
          case _State.nullable: {
            heldValue = objects[0];
            output += heldValue.toString();
            objects.removeAt(0);
            offset--;
            state = _State.percentage;
            starter = pointer;
          }
          case _State.text: {
            output += input.substring(starter, pointer);
            state = _State.percentage;
            starter = pointer;
          }
          case _State.unknown: {
            state = _State.percentage;
            starter = pointer;
          }
        }
      }
      case _Char.o: {
        switch (state) {
          case _State.percentage: state = _State.object;
          case _State.object: {
            while (true) {
              heldValue = objects[offset];
              if (heldValue == null) {
                offset++;
              } else {
                break;
              }
            }
            output += heldValue.toString();
            objects.removeAt(offset);
            state = _State.text;
            starter = pointer;
          }
          case _State.nullable: {
            heldValue = objects[0];
            output += heldValue.toString();
            objects.removeAt(0);
            offset--;
            state = _State.text;
            starter = pointer;
          }
          case _State.text: {}
          case _State.unknown: state = _State.text;
        }
      }
      case _Char.n: {
        switch (state) {
          case _State.percentage: state = _State.nullable;
          case _State.object: {
            while (true) {
              heldValue = objects[offset];
              if (heldValue == null) {
                offset++;
              } else {
                break;
              }
            }
            output += heldValue.toString();
            objects.removeAt(offset);
            state = _State.text;
            starter = pointer;
          }
          case _State.nullable: {
            heldValue = objects[0];
            output += heldValue.toString();
            objects.removeAt(0);
            offset--;
            state = _State.text;
            starter = pointer;
          }
          case _State.text: {}
          case _State.unknown: state = _State.text;
        }
      }
      case _Char.text: {
        switch (state) {
          case _State.percentage: {}
          case _State.object: {
            while (true) {
              heldValue = objects[offset];
              if (heldValue == null) {
                offset++;
              } else {
                break;
              }
            }
            output += heldValue.toString();
            objects.removeAt(offset);
            state = _State.text;
            starter = pointer;
          }
          case _State.nullable: {
            heldValue = objects[0];
            output += heldValue.toString();
            objects.removeAt(0);
            offset--;
            state = _State.text;
            starter = pointer;
          }
          case _State.text: {}
          case _State.unknown: state = _State.text;
        }
      }
    }
    pointer++; // increments
  }
  switch (state) {
    case _State.percentage: output += input.substring(starter);
    case _State.object: {
      while (true) {
        heldValue = objects[offset];
        if (heldValue == null) {
          offset++;
        } else {
          break;
        }
      }
      output += heldValue.toString();
    }
    case _State.nullable: {
      heldValue = objects[0];
      output += heldValue.toString();
    }
    case _State.text: output += input.substring(starter);
    case _State.unknown: {}
  }
  stdout.write(output);
}

enum _State {
  percentage,
  object,
  nullable,
  text,
  unknown,
}

enum _Char {
  percent,
  o,
  n,
  text,
}

_Char _character(String char) {
  switch (char) {
    case "%": return _Char.percent;
    case "o": return _Char.o;
    case "n": return _Char.n;
    case _: return _Char.text;
  }
}

/// The sequel to [printf], this takes only input and just does output.
void printg(String input) {
  stdout.write(input);
}

/// [printg] but it has some more computation before sending it.
void printh(Object? input) {
  printg(input.toString());
}