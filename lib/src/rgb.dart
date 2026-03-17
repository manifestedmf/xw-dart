/// Added in `2.8`.
sealed class Color {
  const Color();
}

/// Added in `2.8`.
class sRGB extends Color {
  /// Added in `2.8`.
  final int red;

  /// Added in `2.8`.
  final int green;

  /// Added in `2.8`.
  final int blue;

  /// Added in `2.8`.
  const sRGB({required int red, required int green, required int blue})
    : red = red % 256,
      green = green % 256,
      blue = blue % 256;

  /// Added in `2.8`.
  const sRGB.rgb(int red, int green, int blue)
    : this(red: red, green: green, blue: blue);

  /// Added in `2.8`.
  const sRGB.rg(int red, int green) : this.rgb(red, green, 0);

  /// Added in `2.8`.
  const sRGB.rb(int red, int blue) : this.rgb(red, 0, blue);

  /// Added in `2.8`.
  const sRGB.gb(int green, int blue) : this.rgb(0, green, blue);

  /// Added in `2.8`.
  const sRGB.r(int red) : this.rg(red, 0);

  /// Added in `2.8`.
  const sRGB.g(int green) : this.gb(green, 0);

  /// Added in `2.8`.
  const sRGB.b(int blue) : this.rb(0, blue);
}

/// The Color for [bool]s in intellij
///
/// Added in `2.8`.
const sRGB boolColor = sRGB(red: 0xE0, green: 0x95, blue: 0x7B);

/// Added in `2.8`.
String colorInsert(String string, sRGB color, [bool reset = true]) {
  String addition = (reset) ? "\x1b[0m" : "";
  return "\x1b[38;2;${color.red};${color.green};${color.blue}m$string$addition";
}
