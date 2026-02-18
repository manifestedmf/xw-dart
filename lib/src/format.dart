import 'internal.dart';

// abstract class Formatter {
//   List<FormatToken> parse(String value);
// }

@Added("2.7","1.0")
abstract class Format {
  abstract final Iterable<FormatToken> tokens;

  Iterable<FormatToken> parse(String value);
}

@Added("2.7","1.0")
abstract class FormatToken {
  abstract final String text;

}

// class DateFormat extends Format {
//   @override
//   final List<DateFormatToken> tokens;
//
//   DateFormat(this.tokens);
// }
//
// class DateFormatToken extends FormatToken {}
//
// enum DateFormatter implements Formatter {
//   instance;
//   @override
//   List<DateFormatToken> parse(String value) {}
//
// }
// void main() {
//   DateFormatter.instance.parse("a");
// }