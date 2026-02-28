/// Added in `2.7.0`.
@Deprecated("3.0, use listEqualsShallow or listEqualsDeep")
bool listEquals<T>(List<T> a, List<T> b, [bool isShallow = true]) =>
  (isShallow) ? listEqualsShallow(a, b) : listEqualsDeep(a, b);

/// Added in `2.7.4`.
bool listEqualsShallow<T>(List<T> a, List<T> b) {
  if (a == b) {
    return true;
  } else if (a.length != b.length) {
    return false;
  } else {
    for (int index = 0; index < a.length; ++index) {
      if (a[index] != b[index]) {
        return false;
      }
    }
    return true;
  }
}

/// Added in `2.7.4`.
bool listEqualsDeep<T>(List<T> a, List<T> b) {
  if (a == b) {
    return true;
  } else if (a.length != b.length) {
    return false;
  } else {
    for (int index = 0; index < a.length; ++index) {
      if (!deepEquals(a[index], b[index])) {
        return false;
      }
    }
    return true;
  }
}

/// Added in `2.7.0`.
@Deprecated("3.0, use mapEqualsShallow or mapEqualsDeep")
bool mapEquals<K, V>(Map<K, V> a, Map<K, V> b, [bool isShallow = true]) =>
  (isShallow) ? mapEqualsShallow(a, b) : mapEqualsDeep(a, b);

/// Added in `2.7.4`.
bool mapEqualsShallow<K, V>(Map<K, V> a, Map<K, V> b) {
  if (a == b) {
    return true;
  } else if (a.length != b.length) {
    return false;
  } else {
    Iterable<MapEntry<K, V>> aEntries = a.entries;
    Iterable<MapEntry<K, V>> bEntries = b.entries;
    for (int index = 0; index < a.length; ++index) {
      if (aEntries.elementAt(index) != bEntries.elementAt(index)) {
        return false;
      }
    }
    return true;
  }
}

/// Added in `2.7.4`.
bool mapEqualsDeep<K, V>(Map<K, V> a, Map<K, V> b) {
  if (a == b) {
    return true;
  } else if (a.length != b.length) {
    return false;
  } else {
    Iterable<MapEntry<K, V>> aEntries = a.entries;
    Iterable<MapEntry<K, V>> bEntries = b.entries;
    for (int index = 0; index < a.length; ++index) {
      if (!deepEquals(aEntries.elementAt(index), bEntries.elementAt(index))) {
        return false;
      }
    }
    return true;
  }
}

/// Added in `2.7.0`.
@Deprecated("3.0, use setEqualsShallow or setEqualsDeep")
bool setEquals<T>(Set<T> a, Set<T> b, [bool isShallow = true]) =>
  (isShallow) ? setEqualsShallow(a, b) : setEqualsDeep(a, b);

/// Added in `2.7.4`.
bool setEqualsShallow<T>(Set<T> a, Set<T> b) {
  if (a == b) {
    return true;
  } else if (a.length != b.length) {
    return false;
  } else {
    for (int index = 0; index < a.length; ++index) {
      if (a.elementAt(index) != b.elementAt(index)) {
        return false;
      }
    }
    return true;
  }
}

/// Added in `2.7.4`.
bool setEqualsDeep<T>(Set<T> a, Set<T> b) {
  if (a == b) {
    return true;
  } else if (a.length != b.length) {
    return false;
  } else {
    for (int index = 0; index < a.length; ++index) {
      if (!deepEquals(a.elementAt(index), b.elementAt(index))) {
        return false;
      }
    }
    return true;
  }
}

/// Added in `2.7.0`.
@Deprecated("3.0, use iterableEqualsShallow or iterableEqualsDeep")
bool iterableEquals<T>(Iterable<T> a, Iterable<T> b, [bool isShallow = true]) =>
  (isShallow) ? iterableEqualsShallow(a, b) : iterableEqualsDeep(a, b);

/// Added in `2.7.4`.
bool iterableEqualsShallow<T>(Iterable<T> a, Iterable<T> b) {
  if (a == b) {
    return true;
  } else if (a.length != b.length) {
    return false;
  } else {
    for (int index = 0; index < a.length; ++index) {
      if (a.elementAt(index) != b.elementAt(index)) {
        return false;
      }
    }
    return true;
  }
}

/// Added in `2.7.4`.
bool iterableEqualsDeep<T>(Iterable<T> a, Iterable<T> b) {
  if (a == b) {
    return true;
  } else if (a.length != b.length) {
    return false;
  } else {
    for (int index = 0; index < a.length; ++index) {
      if (!deepEquals(a.elementAt(index), b.elementAt(index))) {
        return false;
      }
    }
    return true;
  }
}

/// Added in `2.7.4`.
bool deepEquals<T>(T a, T b) {
  if (a is Map && b is Map) {
    return mapEqualsDeep(a, b);
  } else if (a is List && b is List) {
    return listEqualsDeep(a, b);
  } else if (a is Set && b is Set) {
    return setEqualsDeep(a, b);
  } else if (a is Iterable && b is Iterable) {
    return iterableEqualsDeep(a, b);
  } else {
    return a == b;
  }
}
