import 'dart:core'
    show String, Iterable, Object, List, int, bool, ArgumentError;
import 'dart:io' show stdout, stderr;
import '../standard.dart' show cut, grow;
import '../extension.dart' show ListE, StringExt;

/// Prints out to to the console with [stdout]`.`[write]`()`.
///
/// Send in the input from [input], and the [Object]`?`s from [items].
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
/// (`v2.8`)
///
/// `%n`, grabs the next item, which can be [nullable].
/// (`v2.8`)
///
/// `%a`, grabs the next [Iterable].
/// (`v2.8`)
///
/// `%s`, grabs the next [String].
/// (`v2.8`)
///
/// Added in `2.8`.
void printf<E>(
  String input, {
  Iterable<E> items = const [],
  bool error = false,
  String Function(Iterable)? iterJoin,
}) {
  printg(
    scanf(input, items: items, iterJoin: iterJoin),
    error: error,
  );
}

/// Prints with [printf], but with a forced line at the end.
///
/// Added in `2.8`.
void printfln<E>(
  String input, {
  Iterable<E> items = const [],
  bool error = false,
  String Function(Iterable)? iterJoin,
}) => printf("$input\n", items: items, error: error);

/// Prints with a new line at the end.
///
/// Added in `2.8`.
void println(Object? input, {bool error = false}) =>
    printg("$input\n", error: error);

/// Added in `2.8`.
enum _State {
  /// `2.8`
  percentage(null),

  /// `2.8`.
  percentageBefore(null),

  /// `2.8`
  objectAfter(true),

  /// `2.8`
  nullableAfter(true),

  /// `2.8`
  iterableAfter(true),

  /// `2.8`
  stringAfter(true),

  /// `2.8
  objectBefore(false),

  /// `2.8`
  nullableBefore(false),

  /// `2.8`
  iterableBefore(false),

  /// `2.8`
  stringBefore(false),

  /// `2.8`
  text(null),

  /// `2.8`
  unknown(null);

  /// `true` for `after`,
  ///
  /// `false` for `before`,
  ///
  /// `null` for `none`.
  final bool? place;

  const _State(this.place);
}

/// Added in `2.8`.
enum _Char {
  /// `'%'`
  ///
  /// Initializer for other items.
  ///
  /// `2.8`
  percent,

  /// `'%o'`
  ///
  /// [Object].
  ///
  /// `2.8`
  object,

  /// `'%n'`
  ///
  /// [Object?].
  ///
  /// `2.8`
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

  /// `2.8`
  text,

  /// `2.8`
  digit,

  /// `2.8`
  newline,
}

enum _WantedValue {
  /// `2.8`.
  nullable,

  /// `2.8`.
  object,

  /// `2.8`.
  iterable,

  /// `2.8`.
  string,
}

/// Added in `2.8`.
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
/// Send in the input from [input], and the [Object]`?`s from [items].
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
/// (`v2.8`)
///
/// `%n`, grabs the next item, which can be [nullable].
/// (`v2.8`)
///
/// `%a`, grabs the next [Iterable].
/// (`v2.8`)
///
/// `%s`, grabs the next [String].
/// (`v2.8`)
///
/// Added in `2.8`.
String scanf<E>(
  String input, {
  Iterable<E> items = const [],
  String Function(Iterable)? iterJoin,
}) {
  if (items.isEmpty) {
    int pointer = 0;
    String prevChar = "";
    String char = "";
    while (pointer < input.length) {
      char = input[pointer];
      if (prevChar == "%") {
        switch (_character(char)) {
          case _Char.percent:
            input = input.splitAt(pointer).start + input.splitAt(pointer).end;
          case _Char.object:
          case _Char.nullable:
          case _Char.array:
          case _Char.string:
            throw ArgumentError.value(items, "items", "No elements contained");
          case _Char.text:
          case _Char.digit:
          case _Char.newline:
            break;
        }
      }
      prevChar = char;
      pointer++;
    }
    if (prevChar == "%") {
      switch (_character(char)) {
        case _Char.percent:
          input = input.splitAt(pointer).start + input.splitAt(pointer).end;
        case _Char.object:
        case _Char.nullable:
        case _Char.array:
        case _Char.string:
          throw ArgumentError.value(items, "items", "No elements contained");
        case _Char.text:
        case _Char.digit:
        case _Char.newline:
          break;
      }
    }
    return input;
  } else if (items is Iterable<Object>) {
    return _Scanf.initSafe(
      input,
      items as Iterable<Object>,
      iterJoin ?? (i) => i.toString(),
    );
  } else {
    return _Scanf.initUnsafe(input, items, iterJoin ?? (i) => i.toString());
  }
}

/// Added in `2.8`.
class _Scanf<E> {
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

  /// Added in `2.8`.
  String Function(Iterable<Object?>) join;

  /// Added in `2.8`.
  final bool safe;

  /// Added in `2.8`.
  int objectOffset = 0;

  _Scanf(this.input, this.objects, this.join, this.safe);

  static String initSafe<E extends Object>(
    String input,
    Iterable<E> items,
    String Function(Iterable) iterJoin,
  ) => _Scanf(input, items.toList(), iterJoin, true).scan();

  static String initUnsafe<E>(
    String input,
    Iterable<E> items,
    String Function(Iterable) iterJoin,
  ) => _Scanf(input, items.toList(), iterJoin, false).scan();

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
      case _State.objectBefore:
      case _State.objectAfter:
        tempStr = processValue(_WantedValue.object).toString();
      case _State.nullableBefore:
      case _State.nullableAfter:
        tempStr = processValue(_WantedValue.nullable).toString();
      case _State.iterableBefore:
      case _State.iterableAfter:
        tempStr = join(processValue(_WantedValue.iterable) as Iterable);
      case _State.stringBefore:
      case _State.stringAfter:
        tempStr = processValue(_WantedValue.string) as String;
      case _State.text:
        tempStr = input.substring(starter, pointer);
      case _State.unknown:
        return;
    }
    switch (state.place) {
      case null:
        break;
      case true:
        addSpacesAfter();
      case false:
        addSpacesBefore();
    }
    output += tempStr;
    lineLength += tempStr.length;
    starter = pointer;
    spaceAmount = 0;
  }

  /// Added in `2.8`.
  void addSpacesAfter() {
    tempStr += " " * spacesNeeded;
  }

  /// Added in `2.8`.
  void addSpacesBefore() {
    tempStr = " " * spacesNeeded + tempStr;
  }

  /// Added in `2.8`.
  int get spacesNeeded => spaceAmount - (lineLength + tempStr.length);

  /// Sets [heldValue] to the next item,
  /// returns `false` if it is not the [wanted] value.
  ///
  /// Removes value when found.
  ///
  /// Added in `2.8`.
  bool getValue(_WantedValue wanted) {
    switch (wanted) {
      case _WantedValue.nullable:
        heldValue = objects.removeFirst();
        return true;
      case _WantedValue.object:
        heldValue = objects[objectOffset];
        if (heldValue != null) {
          objects.removeAt(objectOffset);
          return true;
        } else {
          objectOffset++;
          return false;
        }
      case _WantedValue.iterable:
        heldValue = objects[iterableOffset];
        if (heldValue is Iterable) {
          objects.removeAt(iterableOffset);
          return true;
        } else {
          iterableOffset++;
          return false;
        }
      case _WantedValue.string:
        heldValue = objects[stringOffset];
        if (heldValue is String) {
          objects.removeAt(stringOffset);
          return true;
        } else {
          stringOffset++;
          return false;
        }
    }
  }

  /// Cuts and grows based off of the [value] inputted.
  ///
  /// Added in `2.8`.
  void gotValue(_WantedValue value) {
    if (value == _WantedValue.object) {
      objectOffset = grow(val: objectOffset - 1, min: 0);
    } else {
      objectOffset = cut(val: objectOffset, max: objects.length - 1);
    }

    if (value == _WantedValue.iterable) {
      iterableOffset = grow(val: iterableOffset - 1, min: 0);
    } else {
      iterableOffset = cut(val: iterableOffset, max: objects.length - 1);
    }

    if (value == _WantedValue.string) {
      stringOffset = grow(val: stringOffset - 1, min: 0);
    } else {
      stringOffset = cut(val: stringOffset, max: objects.length - 1);
    }
  }

  /// Gives back the [heldValue].
  ///
  /// Added in `2.8`.
  E processValue(_WantedValue value) {
    // ignore: empty_statements
    while (!getValue(value)) ;
    gotValue(value);
    return heldValue;
  }
}

/// The sequel to [printf], this takes only input and just does output.
///
/// if [error] is [true], then it prints to [stderr] instead of [stdout].
///
/// Added in `2.8`.
void printg(String input, {bool error = false}) {
  if (error) {
    stderr.write(input);
  } else {
    stdout.write(input);
  }
}

/// [printg] but it has some more computation before sending it.
///
/// Added in `2.8`.
void printh(Object? input, {bool error = false}) {
  printg(input.toString(), error: error);
}
