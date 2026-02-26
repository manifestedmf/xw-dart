import '../extension.dart';
import 'core.dart';

Fraction maxFraction(Iterable<Fraction> fractions, [Fraction? ifNone]) {
  if (fractions.isEmpty) {
    return ifNone ?? (throw StateError("No Optional Parameter Set"));
  }
  Fraction max = fractions.first;
  for (Fraction current in fractions) {
    if (current > max) {
      max = current;
    }
  }
  return max;
}

Fraction maxSimpleFraction(Fraction a, Fraction b) => (a > b) ? a : b;

Set<MapEntry<K,Fraction>> maxMapValueFraction<K>(Map<K, Fraction> map, [MapEntry<K,Fraction>? ifNone]) {
  if (map.isEmpty) {
    if (ifNone == null) {throw StateError("No Optional Parameter Set");}
    return {ifNone};
  }
  Iterable<MapEntry<K,Fraction>> entries = map.entries;
  Set<MapEntry<K,Fraction>> maxSet = {entries.first};
  Fraction max = entries.first.value;
  for (MapEntry<K,Fraction> current in entries) {
    if (current.value > max) {
      maxSet = {current};
      max = current.value;
    }
    else if (current.value == max) {maxSet.add(current);}
  }
  return maxSet;
}

MapEntry<Fraction,V> maxMapKeyFraction<V>(Map<Fraction, V> map, [MapEntry<Fraction,V>? ifNone]) {
  if (map.isEmpty) {
    return ifNone ?? (throw StateError("No Optional Parameter Set"));
  }
  Iterable<MapEntry<Fraction,V>> entries = map.entries;
  MapEntry<Fraction,V> max = entries.first;
  for (MapEntry<Fraction,V> current in entries) {
    if (current.key > max.key) {
      max = current;
    }
  }
  return max;
}

Fraction minFraction(Iterable<Fraction> fractions, [Fraction? ifNone]) {
  if (fractions.isEmpty) {
    return ifNone ?? (throw StateError("No Optional Parameter Set"));
  }
  Fraction min = fractions.first;
  for (Fraction current in fractions) {
    if (current < min) {
      min = current;
    }
  }
  return min;
}

Fraction minSimpleFraction(Fraction a, Fraction b) => (a < b) ? a : b;

MapEntry<Fraction,V> minMapKeyFraction<V>(Map<Fraction,V> map, [MapEntry<Fraction,V>? ifNone]) {
  if (map.isEmpty) {
    return ifNone ?? (throw StateError("No Optional Parameter Set"));
  }
  Iterable<MapEntry<Fraction,V>> entries = map.entries;
  MapEntry<Fraction,V> min = entries.first;
  for (MapEntry<Fraction,V> current in entries) {
    if (current.key < min.key) {min = current;}
  }
  return min;
}

Set<MapEntry<K,Fraction>> minMapValueFraction<K>(Map<K,Fraction> map, [MapEntry<K,Fraction>? ifNone]) {
  if (map.isEmpty) {
    if (ifNone == null) {throw StateError("No Optional Parameter Set");}
    return {ifNone};
  }
  Iterable<MapEntry<K,Fraction>> entries = map.entries;
  Set<MapEntry<K,Fraction>> minSet = {entries.first};
  Fraction min = entries.first.value;
  for (MapEntry<K,Fraction> current in entries) {
    if (current.value < min) {
      minSet = {current};
      min = current.value;
    }
    else if (current.value == min) {minSet.add(current);}
  }
  return minSet;
}

Fraction sumFraction(Iterable<Fraction> fractions, [Fraction? starting]) {
  Fraction sum;
  sum = (starting == null) ? Fraction(0,0) : starting;
  for (Fraction current in fractions) {
    sum += current;
  }
  return sum;
}

Fraction powFraction(Fraction base, int exponent) => base ^ exponent;

/// adds very specific fraction class
///
/// current version: 1.1
class Fraction {
  /*dynamic __oper;
  dynamic __div;*/
  final int _oper; // operand
  final int _div; // divisor
  //Base eval;

  int get integer => _oper~/_div;
  double get float => _oper/_div;
  Fraction get fraction => this;


  // constants:
  static const one = Fraction._(1,1);
  static const half = Fraction._(1,2);
  static const third = Fraction._(1,3);
  static const quarter = Fraction._(1,4);
  static const fifth = Fraction._(1,5);
  static const sixth = Fraction._(1,6);
  static const seventh = Fraction._(1,7);
  static const eighth = Fraction._(1,8);
  static const ninth = Fraction._(1,9);
  static const tenth = Fraction._(1,10);

  static const twoThirds = Fraction._(2,3);

  static const threeQuarters = Fraction._(3,4);

  static const twoFifths = Fraction._(2,5);
  static const threeFifths = Fraction._(3,5);
  static const fourFifths = Fraction._(4,5);

  static const fiveSixths = Fraction._(5,6);

  static const twoSevenths = Fraction._(2,7);
  static const threeSevenths = Fraction._(3,7);
  static const fourSevenths = Fraction._(4,7);
  static const fiveSevenths = Fraction._(5,7);
  static const sixSevenths = Fraction._(6,7);

  static const threeEighths = Fraction._(3,8);
  static const fiveEighths = Fraction._(5,8);
  static const sevenEights = Fraction._(7,8);

  static const twoNinths = Fraction._(2,9);
  static const fourNinths = Fraction._(4,9);
  static const fiveNinths = Fraction._(5,9);
  static const sevenNinths = Fraction._(7,9);
  static const eightNinths = Fraction._(8,9);

  static const threeTenths = Fraction._(3,10);
  static const sevenTenths = Fraction._(7,10);
  static const nineTenths = Fraction._(9,10);

  /*
  int get _operand {
    if(__oper is int) {return __oper;}
    else if(__oper is double) {return _fromFloat(__oper)._oper;}
    if(__oper is Fraction) {return Fraction}
  }
  int get _divisor {
    if(__div is int) {return __div;}
  }*/

  /*void _simplify() {
    List<int> operFactors = primeFactors(_oper);
    List<int> divFactors = primeFactors(_div);
    if (divFactors.isEmpty) {return;}
    int index = 0;
    while (index < divFactors.length) {
      if (operFactors.contains(divFactors[index])) {
        _oper ~/= divFactors[index];
        _div ~/= divFactors[index];
        operFactors = primeFactors(_oper);
        divFactors = primeFactors(_div);
        index = index.towardsZero;}
      else {++index;}
    }
  }*/

  /*/// input a int, double or Fracton
  set operand(int value) {_oper = value; _simplify();}
  /// input a int, double or Fracton
  set numerator(int value) {operand = value;}

  /// input a int, double or Fracton
  set divisor(int value) {_div = value; _simplify();}
  /// input a int, double or Fracton
  set denominator(int value) {divisor = value;}

  void change(int oper, int div) {
    _oper = oper;
    _div = div;
    _simplify();}*/

  /*
  String get _stringEval {
    if (_div == 1 || _oper == 0) {return "= $integer";}
    switch (eval) {
      case Base.binary:
        if (isExponentOf(_oper,2)) {return "= $float";}
      case Base.ternary:
        throw UnimplementedError();
      case Base.quaternary:
        throw UnimplementedError();
      case Base.quinary:
        throw UnimplementedError();
      case Base.heximal:
        throw UnimplementedError();
      case Base.septimal:
        throw UnimplementedError();
      case Base.octal:
        throw UnimplementedError();
      case Base.decimal:
        throw UnimplementedError();
      case Base.hexadecimal:
        throw UnimplementedError();
    }
    return "≈ ${baseConvert(float,eval)}";
  }*/

  bool get isWhole => _div == 1 || _oper == 0;
  Fraction roundToFraction() {
    int oper = _oper;
    int index = 1;
    while (!isDivBy(oper,_div)) {
      oper += index;
      index = -++index;
    }
    return Fraction(oper,_div);
  }
  int round() => roundToFraction().integer;
  double roundToDouble() => roundToFraction().float;

  String get visualRepresentation {
    if (isWhole) {return "= $integer";}
    else if (isMadeUpOf(_div,primeFactors(10))) {return "= $float";}
    else if (isMadeUpOf(_div,primeFactors(3))) {
      int number = integer;
      String start; // working infrastructure
      if (_oper % 3 == 1) {start = "= $number.33...";}
      else {start ="= $number.66...7";}
      return start;
    }
    else {return "≈ $float";}
  }

  String get afterVisualRepr => visualRepresentation.substring(2);

  /// expects blank space
  @override
  String toString() => "$string $visualRepresentation";

  String get string => "$_oper/$_div";

  factory Fraction.fromDouble(double number) =>
    Fraction(number.truncate(),pow(10,number.decimalLength));
  factory Fraction.fromInt(int number) => Fraction(number,1);
  factory Fraction.fromNum(num number) {
    if (number is double) {return Fraction.fromDouble(number);}
    else if (number is int) {return Fraction.fromInt(number);}
    else {throw "unexpected new number class";}
  }

  /** expects to be int*/
  const Fraction._(this._oper,this._div);

  factory Fraction(int oper, int div) {
    if (oper == 0 && div == 0) {return Fraction._(0,0);}
    if (oper == 0) {return Fraction._(0,1);}
    if (div == 0) {return Fraction._(1,0);}
    List<int> operFactors = primeFactors(oper);
    List<int> divFactors = primeFactors(div);
    if (divFactors.isEmpty || operFactors.isEmpty) {return Fraction._(oper,div);}
    int index = 0;
    while (index < divFactors.length) {
      if (operFactors.contains(divFactors[index])) {
        oper ~/= divFactors[index];
        div ~/= divFactors[index];
        operFactors.removeAt(index);
        divFactors.removeAt(index);
      }
      else {++index;}
    }
    return Fraction._(oper,div);
  }



  // operators:
  // bool:
  @override
  /// supports int, double and Fraction
  bool operator ==(Object other) {
    if (other is int) {return (_div*other == _oper);}
    else if (other is double) {return (float == other);}
    else if (other is Fraction) {return (_oper == other._oper && _div == other._div);}
    else {throw "expected $int, $double or $Fraction";}
  }

  @override
  int get hashCode => Object.hash(_div,_oper);

  bool operator <(Object other) {
    if (other is int) {return (float < other.toDouble());}
    else if (other is double) {return (float < other);}
    else if (other is Fraction) {return (float < other.float);}
    else {throw "expected $int, $double or $Fraction";}
  }

  bool operator >(Object other) {
    if (other is int) {return (float > other.toDouble());}
    else if (other is double) {return (float > other);}
    else if (other is Fraction) {return (float > other.float);}
    else {throw "expected $int, $double or $Fraction";}
  }

  bool operator <=(Object other) => (this < other || this == other);

  bool operator >=(Object other) => (this > other || this == other);


  // additive:
  Fraction operator +(Object other) {
    if (other is int) {return this + Fraction(other,1);}
    //else if (other is double) {return this + Fraction._fromFloat(other);}
    else if (other is Fraction) {
      return Fraction(_oper*other._div + _div*other._oper,_div*other._div);} // a*d + b*c, b*d
    else {throw "expected $int, $double, or $Fraction";}
  }

  Fraction operator -(Object other) {
    if (other is int) {return this - Fraction(other,1);}
    //else if (other is double) {return this - Fraction._fromFloat(other);}
    else if (other is Fraction) {
      return Fraction(_oper*other._div - _div*other._oper,_div*other._div);} // a*d - b*c, b*d
    else {throw "expected $int, $double, or $Fraction";}
  }

  /// turns to minus
  Fraction operator -() => Fraction(-_oper,_div);


  // multiplicative:
  Fraction operator *(Object other) {
    if (other is int) {return this * Fraction(other,1);}
    //else if (other is double) {return this * Fraction._fromFloat(other);}
    else if (other is Fraction) {return Fraction(_oper*other._oper,_div*other._div);}
    else {throw "expected $int, $double, or $Fraction";}
  }

  Fraction operator /(Object other) {
    if (other is int) {return this / Fraction(other,1);}
    //else if (other is double) {return this / Fraction._fromFloat(other);} // is roughly 427 microseconds
    else if (other is Fraction) {return this * ~other;} // is roughly 0.6 microsecond
    else {throw "expected $int, $double, or $Fraction";}
  }

  Fraction operator ~/(Object other) => this / other;

  Fraction operator %(Object other) {
    if (other is int) {return this % Fraction(other,1);}
    else if (other is double) {throw "# % float, doesn't make sense";}
    else if (other is Fraction) {
      if (other._div != 1) {throw "# % fraction, doesn't make sense";}
      else {return Fraction(_oper % other._oper,_div);}
    }
    else {throw "expected $int, $double, or $Fraction";}
  }

  /// raises [_oper] & [_div] to [exponent]
  Fraction operator ^(int exponent) {return Fraction(
      powInt(_oper,exponent),
      powInt(_div,exponent));}

  /// flips div and oper
  Fraction operator ~() => Fraction(_div,_oper);


  bool get isNaN => _div == 0;
  bool get isInfinite => _div == 0;
  bool get isFinite => _div != 0;
  bool get isNegative => _div.isNegative ^ _oper.isNegative;
  bool get isPositive => !isNegative;
  Fraction floorToFraction() {
    if (_div == 1) {return this;}
    else {
      return Fraction(getPreviousFactor(_oper,_div),1);
    }
  }
}


int getPreviousFactor(int number, int divisor) => (number ~/ divisor) * divisor;
int getNextFactor(int number, int divisor) => (number ~/ divisor + 1) * divisor;

extension FractionExtension on int {
  Fraction toFraction() => Fraction(this,1);
}

extension FractionExtension2 on double {
  Fraction toFraction() => Fraction(truncate(),powInt(10,decimalLength));
}

Fraction percentage<N extends num>(N number) =>
    Fraction(number.truncate(),number.decimalLength);