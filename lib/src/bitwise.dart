import 'dart:math' as math;
import 'extension.dart';

enum BitCounter {
  positive({"positive","pos","+","1",1,true}),
  negative({"negative","neg","-","0",0,false}),
  all({"all",null})
  ;
  final Set<Object?> parser;
  const BitCounter(this.parser);
  static BitCounter parse(Object? par) => tryParse(par) ?? (throw "can't parse '$par'");
  static BitCounter? tryParse(Object? par) {
    for (BitCounter bitCounter in values) {
      if (bitCounter.parser.contains(par)) {return bitCounter;}
    }
    return null;
  }
}

/// counts amounts of [bits] (excluding|including signed bits)
int bitcount(int bits, {bool signed = true, Object? counts = BitCounter.all}) {
  if (bits == 0) {
    return 0;
  }
  if (counts is !BitCounter) {
    counts = BitCounter.parse(counts);
  }
  int n = 0;
  if (signed) {
    for (; bits != 0; bits >>>= 1) {
      if (counts == BitCounter.all) {++n;}
      else if (counts == BitCounter.positive && bits % 2 == 1) {++n;}
      else if (counts == BitCounter.negative && bits % 2 == 0) {++n;}
    }
    return n;
  } else {
    int repetition = 0;
    for (; bits != 0; bits >>= 1) {
      if (counts == BitCounter.all) {++n;}
      else if (counts == BitCounter.positive && bits % 2 == 1) {++n;}
      else if (counts == BitCounter.negative && bits % 2 == 0) {++n;}
      repetition++;
      if (repetition >= 256) {throw "is a signed bit, when not expecting it";}
    }
    return n;
  }
}

/// bit Wraps Right
int bitWrapR(int bits, int amount, {bool signed = true, int bitAmount = -1}) {
  if (bitAmount == -1) {
    int number = 0;
    int bitShifter = bits;
    for (; bitShifter != 0; bitShifter >>= 1) {++number;}
    bitAmount = number;
  }
  if (amount == 0) {return bits;}
  else if (amount == 1) {
    int bit = bits % 2;
    if (signed) {
      bits = bits >>> 1;
    } else {
      bits >>= 1;
    }
    if (bit.toBool() && signed) {
      bits |= math.pow(2, bitAmount - 1).toInt();
    } else if (bit.toBool() && !signed) {
      bits |= math.pow(2, bitAmount).toInt();
    }
    return bits;
  }
  else {
    for (int i = 0; i < amount; ++i) {
      bits = bitWrapR(bits, 1, signed: signed, bitAmount: bitAmount);
    }
    return bits;
  }
}
