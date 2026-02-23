import 'dart:math' as math;
import '../extension.dart';

int abs(int signed) => (signed < 0) ? -signed : signed;

//@Deprecated("2.7.3, getting replaced with strToBase(hex,16)")
int hexConvert(String hex) {
  int number = 0;
  int value = 0;
  for(int index = 0; index < hex.length; ++index) {
    if (hex[index].toLowerCase() == "f") {value = 15;}
    else if (hex[index].toLowerCase() == "e") {value = 14;}
    else if (hex[index].toLowerCase() == "d") {value = 13;}
    else if (hex[index].toLowerCase() == "c") {value = 12;}
    else if (hex[index].toLowerCase() == "b") {value = 12;}
    else if (hex[index].toLowerCase() == "a") {value = 11;}
    else {value = int.parse(hex[index]);}
    number += powInt(value,hex.length-index-1);
  }
  return number;
}

//@Deprecated("2.7.3, getting replaced with strToBase(bin,2)")
int binConvert(String bin) {
  int number = 0;
  int value = 0;
  for(int index = 0; index < bin.length; ++index) {
    value = int.parse(bin[index]);
    number += powInt(value,bin.length-index-1);
  }
  return number;
}

N max<N extends num>(Iterable<N> numbers, [N? ifNone]) {
  if (numbers.isEmpty) {
    return ifNone ?? (throw StateError("No Optional Parameter Set"));
  }
  N max = numbers.first;
  for (N current in numbers) {
    if (current > max) {
      max = current;
    }
  }
  return max;
}

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

MapEntry<K,V> maxMapKey<K extends num, V>(Map<K, V> map, [MapEntry<K, V>? ifNone]) {
  if (map.isEmpty) {
    return ifNone ?? (throw StateError("No Optional Parameter Set"));
  }
  Iterable<MapEntry<K,V>> entries = map.entries;
  MapEntry<K,V> max = entries.first;
  for (MapEntry<K,V> current in entries) {
    if (current.key > max.key) {
      max = current;
    }
  }
  return max;
}

Set<MapEntry<K,V>> maxMapValue<K, V extends num>(Map<K, V> map, [MapEntry<K, V>? ifNone]) {
  if (map.isEmpty) {
    if (ifNone == null) {throw StateError("No Optional Parameter Set");}
    return {ifNone};
  }
  Iterable<MapEntry<K,V>> entries = map.entries;
  Set<MapEntry<K,V>> maxSet = {entries.first};
  V max = entries.first.value;
  for (MapEntry<K,V> current in entries) {
    if (current.value > max) {
      maxSet = {current};
      max = current.value;
    }
    else if (current.value == max) {maxSet.add(current);}
  }
  return maxSet;
}

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

N min<N extends num>(Iterable<N> numbers, [N? ifNone]) {
  if (numbers.isEmpty) {
    return ifNone ?? (throw StateError("No Optional Parameter Set"));
  }
  N min = numbers.first;
  for (N current in numbers) {
    if (current < min) {
      min = current;
    }
  }
  return min;
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

MapEntry<K,V> minMapKey<K extends num, V>(Map<K,V> map, [MapEntry<K,V>? ifNone]) {
  if (map.isEmpty) {
    return ifNone ?? (throw StateError("No Optional Parameter Set"));
  }
  Iterable<MapEntry<K,V>> entries = map.entries;
  MapEntry<K,V> min = entries.first;
  for (MapEntry<K,V> current in entries) {
    if (current.key < min.key) {min = current;}
  }
  return min;
}

Set<MapEntry<K,V>> minMapValue<K,V extends num>(Map<K,V> map, [MapEntry<K,V>? ifNone]) {
  if (map.isEmpty) {
    if (ifNone == null) {throw StateError("No Optional Parameter Set");}
    return {ifNone};
  }
  Iterable<MapEntry<K,V>> entries = map.entries;
  Set<MapEntry<K,V>> minSet = {entries.first};
  V min = entries.first.value;
  for (MapEntry<K,V> current in entries) {
    if (current.value < min) {
      minSet = {current};
      min = current.value;
    }
    else if (current.value == min) {minSet.add(current);}
  }
  return minSet;
}

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


N sum<N extends num>(Iterable<N> numbers, [N? starting]) {
  N sum;
  sum = (starting == null) ? 0 as N : starting;
  for (N current in numbers) {
    sum = sum + current as N;
  }
  return sum;
}

Fraction sumFraction(Iterable<Fraction> fractions, [Fraction? starting]) {
  Fraction sum;
  sum = (starting == null) ? Fraction(0,0) : starting;
  for (Fraction current in fractions) {
    sum += current;
  }
  return sum;
}

K sumMapKey<K extends num,V>(Map<K,V> map, [K? starting]) {
  K sum;
  sum = (starting == null) ? 0 as K : starting;
  Iterable<MapEntry<K,V>> entries = map.entries;
  for (MapEntry<K,V> current in entries) {
    sum = sum + current.key as K;
  }
  return sum;
}

V sumMapValue<K,V extends num>(Map<K,V> map, [V? starting]) {
  V sum;
  sum = (starting == null) ? 0 as V : starting;
  Iterable<MapEntry<K,V>> entries = map.entries;
  for (MapEntry<K,V> current in entries) {
    sum = sum + current.value as V;
  }
  return sum;
}

/*
({K keySum, V valueSum}) sumMap<K,V>(Map<K,V> map) {
  MapEntry<K,V> sumEntries;
  K keySum;
  if (map is Map<num,V>) {
    keySum = sum<num>(map.keys as Iterable<num>) as K;
  }
  return MapEntry<keySum,0>;
}*/

@Deprecated("2.8, use pow<int>(base, exponent)")
int powInt(int base, int exponent) {
  for (int i = 0; i < exponent;i++) {
    base *= exponent;
  }
  return base;
}

@Deprecated("2.8, use pow<num>(base, exponent)")
num powNum(num base, num exponent) => math.pow(base,exponent);
@Deprecated("2.8, use pow<double>(base, exponent)")
double powDouble(double base, double exponent) => math.pow(base,exponent).toDouble();

N pow<N extends num>(N base, N exponent) => math.pow(base,exponent) as N;

Fraction powFraction(Fraction base, int exponent) => base ^ exponent;

N sqrt<N extends num>(N number) {
  if (N is int) {
    return math.sqrt(number).toInt() as N;
  } else {
    return math.sqrt(number) as N;
  }
}

/*
enum Base {
  binary,
  ternary,
  quaternary,
  quinary,
  heximal,
  septimal,
  octal,
  decimal,
  hexadecimal}

String baseConvert(num decimalNum, Base base) {
  switch (base) {
    case Base.binary:
      if ()
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
}*/

bool isLow(num number) => (number % 1 < 0.5);
bool isHigh(num number) => !isLow(number);

bool isDivBy(int oper, int number) => oper % number == 0;

/// explicit that the first is 1
List<int> primeFactors(int number) {
  List<int> list = [];
  int div = 2;
  if (number < 0) {list.add(-1); number*=-1;}
  int highestDiv = math.sqrt(number).toInt();
  while (div <= highestDiv) {
    if (isDivBy(number,div)) {
      list.add(div);
      number ~/= div;
      highestDiv = math.sqrt(number).toInt();
      div = 2;}
    else {div++;}
  }
  if (number != 1) {list.add(number);}
  return list;}

/// if number is prime
bool isPrime(int number) => (primeFactors(number).length == 1);
/// if number is constructed of primes
bool isComprime(int number) {
  List<int> list = primeFactors(number);
  if (list.length <= 1) {return false;}
  else if (list[0] != list[1] && list.length == 2) {return true;}
  else {return false;}
}

/// 64, 2 // true
///
/// 63, 3 // false
bool isExponentOf(int number, int base) => isMadeUpOf(number, [base]);
/*
/// 64, 2 // true
///
/// 63, 3 // false
bool isExponentOf(int number, int base) {
  List<int> list = primeFactors(number);
  int index = 0;
  while (index < list.length) {
    if (list[index] == base) {list.removeAt(index);
    index = index.towardsZero;}
    else {return false;}
  }
  return true;}*/

bool isMadeUpOf(int number, List<int> primes) {
  List<int> list = primeFactors(number);
  int index = 0;
  while (index < list.length) {
    if (primes.contains(list[index])) {list.removeAt(index);
    index = index.towardsZero;}
    else {return false;}
  }
  return true;
}

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