/// Added in `2.8`.
sealed class Color {
  const Color();
}

/// Added in `2.8`.
class sRGB extends Color {
  final int red;
  final int green;
  final int blue;
  const sRGB({required int red, required int green, required int blue})
    : red = red % 256,
      green = green % 256,
      blue = blue % 256;
}

/// Added in `2.8`.
String colorInsert(String string, sRGB color, [bool reset = true]) {
  String addition = (reset) ? "\x1b[0m" : "";
  return "\x1b[38;2;${color.red};${color.green};${color.blue}m$string$addition";
}
