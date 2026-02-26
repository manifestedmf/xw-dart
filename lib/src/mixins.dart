
/// Added in `2.7.0`.
mixin Compare<O> {
  bool operator <(O other);
  bool operator <=(O other) => this < other || this == other;
  bool operator >(O other) => !(this <= other);
  bool operator >=(O other) => !(this < other);
}

/// Added in `2.7.0`.
bool listEquals<T>(List<T> a, List<T> b) {
  if (a == b) {return true;}
  if (a.length != b.length) {return false;}
  for (int index = 0; index < a.length; ++index) {
    if (a[index] != b[index]) {return false;}
  }
  return true;
}

/// Added in `2.7.0`.
bool mapEquals<K,V>(Map<K,V> a, Map<K,V> b) {
  if (a == b) {return true;}
  if (a.length != b.length) {return false;}
  var c = a.entries; var d = b.entries;
  for (int index = 0; index < a.length; ++index) {
    if (c.elementAt(index) != d.elementAt(index)) {return false;}
  }
  return true;
}

/// Added in `2.7.0`.
bool setEquals<T>(Set<T> a, Set<T> b) {
  if (a == b) {return true;}
  if (a.length != b.length) {return false;}
  for (int index = 0; index < a.length; ++index) {
    if (a.elementAt(index) != b.elementAt(index)) {return false;}
  }
  return true;
}

/// Added in `2.7.0`.
bool iterableEquals<T>(Iterable<T> a, Iterable<T> b) {
  if (a == b) {return true;}
  if (a.length != b.length) {return false;}
  for (int index = 0; index < a.length; ++index) {
    if (a.elementAt(index) != b.elementAt(index)) {return false;}
  }
  return true;
}

// TODO: add deepEquals for each item

// bool deepEquals(Object? a, Object? b) {
//   if (a is Map && b is Map) {mapEquals(a,b);}
// }