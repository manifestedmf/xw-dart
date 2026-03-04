
/// Added in `2.7`.
mixin Compare<O> {
  bool operator <(O other);
  bool operator <=(O other) => this < other || this == other;
  bool operator >(O other) => !(this <= other);
  bool operator >=(O other) => !(this < other);
}

/// Added in `2.8`.
mixin Number {
  int round();
  double roundToDouble() => round().toDouble();
  int floor();
  double floorToDouble() => floor().toDouble();
  int ceil();
  double ceilToDouble() => ceil().toDouble();
}

/*
/// Added in `2.8`.
mixin Modulo<T> {
  bool operator <(T other);
  bool operator >(T other);
  T operator +(T other);
  T operator -(T other);
  T operator %(T other) {
    T mule = this;
  }
}*/
