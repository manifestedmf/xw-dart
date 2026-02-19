import 'extension.dart';

// abstract class Formatter {
//   List<FormatToken> parse(String value);
// }

abstract class Format {
  abstract final Iterable<FormatToken> tokens;

  static Iterable<FormatToken> parseFormat(
      {required String input,
      required Map<FormatIdentifier,FormatTokenType> identifiers,
      required FormatTokenType textType,}
      ) {
    List<FormatToken> tokens = [];
    Map<String,FormatIdentifier> identifierLinkers = {
      for (var a in identifiers.entries)
        a.key.text:a.key
    };
    Map<String,FormatTokenType> identifierSuperLinkers = {
      for (var a in identifierLinkers.entries)
        a.key:identifiers[a.value]!
    };
    Set<String> identifierKeywords = identifierLinkers.keys.toSet();
    int start = 0;
    int index = 0;
    _FormatState state = _FormatStateUnknown();
    String substring = input.substring(start,index);
    String tester;
    bool gotOne = false;
    while (index < input.length) {
      for (var a in identifierKeywords) {
        tester = input.safeSubstring(index-a.length,index);
        if (a == tester) {
          switch (state.runtimeType) {
            case _FormatStateText _: {
              tokens.add(_FormatToken(input.substring(start,index-a.length),textType));
            }
            case _FormatStateUnknown _:
            case _FormatStateKeyword _: {}
            case _: {throw state.runtimeType;}
          }
          tokens.add(_FormatToken(tester,identifierSuperLinkers[tester]!));
          start = index;
          state = _FormatStateKeyword(_FormatIdentifier(tester),identifierSuperLinkers[tester]!);
        }
      }
      index++;
      substring = input.substring(start,index);
      gotOne = false;
    }
    gotOne = false;
    for (var a in identifierKeywords) {
      tester = input.safeSubstring(index-a.length,index);
      if (a == tester) {
        tokens.add(_FormatToken(tester,identifierSuperLinkers[substring]!));
        gotOne = true;
      }
    }
    if (!gotOne) {
      tokens.add(_FormatToken(substring,textType));
    }
    return tokens;
  }
}

enum TokenState {
  unknown,
  text,
  identifier,
  init,
}

abstract class FormatTokenType {}

abstract class FormatIdentifier {
  final String text;
  /*final bool textDirectlyAfter;
  final bool textDirectlyBefore;*/

  const FormatIdentifier(
    this.text, /*{
      this.textDirectlyAfter = false,
      this.textDirectlyBefore = true,
    }*/);
}

class _FormatIdentifier extends FormatIdentifier {
  const _FormatIdentifier(super.text);
}

abstract class FormatToken {
  final String text;
  final FormatTokenType type;

  const FormatToken(this.text,this.type);

  @override
  /// CRE = CoRresponding Element
  String toString() => "'$text'CRE{$type}";
}



class _FormatToken extends FormatToken {
  const _FormatToken(super.text,super.type);
}

sealed class _FormatState {
  final FormatIdentifier text;
  const _FormatState(this.text);
}
class _FormatStateText extends _FormatState {
  const _FormatStateText(super.text);
}
class _FormatStateUnknown extends _FormatState {
  _FormatStateUnknown():super(_FormatIdentifier(""));
}
class _FormatStateKeyword extends _FormatState {
  final FormatTokenType type;
  const _FormatStateKeyword(super.text,this.type);
}
