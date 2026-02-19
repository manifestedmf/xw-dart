
mixin CompareMixin<T> {
  bool operator <(T other);
  bool operator <=(T other) => this < other || this == other;
  bool operator >(T other) => !(this <= other);
  bool operator >=(T other) => !(this < other);
}

bool listEquals<T>(List<T> a, List<T> b) {
  if (a == b) {return true;}
  if (a.length != b.length) {return false;}
  for (int index = 0; index < a.length; ++index) {
    if (a[index] != b[index]) {return false;}
  }
  return true;
}

bool mapEquals<K,V>(Map<K,V> a, Map<K,V> b) {
  if (a == b) {return true;}
  if (a.length != b.length) {return false;}
  var c = a.entries; var d = b.entries;
  for (int index = 0; index < a.length; ++index) {
    if (c.elementAt(index) != d.elementAt(index)) {return false;}
  }
  return true;
}

bool setEquals<T>(Set<T> a, Set<T> b) {
  if (a == b) {return true;}
  if (a.length != b.length) {return false;}
  for (int index = 0; index < a.length; ++index) {
    if (a.elementAt(index) != b.elementAt(index)) {return false;}
  }
  return true;
}

bool iterableEquals<T>(Iterable<T> a, Iterable<T> b) {
  if (a == b) {return true;}
  if (a.length != b.length) {return false;}
  for (int index = 0; index < a.length; ++index) {
    if (a.elementAt(index) != b.elementAt(index)) {return false;}
  }
  return true;
}

// bool deepEquals(Object? a, Object? b) {
//   if (a is Map && b is Map) {mapEquals(a,b);}
// }