enum JsonState {
  whitespace(),
  string(),
  escape(),
  object(),
  array(),
  number(),
  boolean(),
  nullV(),
  unknown(),
}

enum JsonTypes {
  object(),
  array(),
  string(),
  number(),
  trueValue(),
  falseValue(),
  nullValue(),
}

final class JsonLoc {
  final int startList;
  final int startPos;
  final int endList;
  final int endPos;
  final JsonTypes type;
  final String? contents;

  const JsonLoc(
    this.startList,
    this.startPos,
    this.endList,
    this.endPos,
    this.type, [
    this.contents,
  ]);
}
