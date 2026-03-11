import 'extension.dart' show IntExt;

/// Added in `2.7`.
enum BitCounter {
  positive({"positive", "pos", "+", "1", 1, true}),
  negative({"negative", "neg", "-", "0", 0, false}),
  all({"all", null});

  final Set<Object?> parser;
  const BitCounter(this.parser);
  static BitCounter parse(Object? par) =>
      tryParse(par) ?? (throw "can't parse '$par'");
  static BitCounter? tryParse(Object? par) {
    for (BitCounter bitCounter in values) {
      if (bitCounter.parser.contains(par)) {
        return bitCounter;
      }
    }
    return null;
  }
}

/// Counts amounts of [bits] (excluding|including signed bits).
///
/// Added in `2.7`.
int bitcount(int bits, {bool signed = true, BitCounter counts = BitCounter.all}) {
  if (bits == 0) {
    return 0;
  }
  int n = 0;
  if (signed) {
    for (; bits != 0; bits >>>= 1) {
      if (counts == BitCounter.all) {
        ++n;
      } else if (counts == BitCounter.positive && bits % 2 == 1) {
        ++n;
      } else if (counts == BitCounter.negative && bits % 2 == 0) {
        ++n;
      }
    }
    return n;
  } else {
    int repetition = 0;
    for (; bits != 0; bits >>= 1) {
      if (counts == BitCounter.all) {
        ++n;
      } else if (counts == BitCounter.positive && bits % 2 == 1) {
        ++n;
      } else if (counts == BitCounter.negative && bits % 2 == 0) {
        ++n;
      }
      repetition++;
      if (repetition >= 256) {
        throw "is a signed bit, when not expecting it";
      }
    }
    return n;
  }
}

/// Bit wraps to the right.
///
/// Added in `2.7`.
int bitWrapR(int bits, int amount, {bool signed = true, int? bitAmount}) {
  if (amount < 0) {
    throw "$amount can't be less than 0";
  }
  bitAmount ??= 64;
  if (amount == 1) {
    int bit = bits & 1;
    bits >>= 1;
    bits |= bit << (bitAmount - 1);
    return bits;
  } else {
    bits = bitWrapR(bits, amount - 1, signed: signed, bitAmount: bitAmount);
    return bitWrapR(bits, 1, signed: signed, bitAmount: bitAmount);
  }
}

/// Sets a `1` at [pos] in [word].
///
/// Positioning goes from the right to left,
/// meaning that [pos] being one sets the least meaningful bit.
///
/// Added in `2.8`.
int set(int word, int pos) => word | (1 << pos);

/// Sets a `0` at [pos] in [word].
///
/// Positioning goes from the right to left,
/// meaning that [pos] being one sets the least meaningful bit.
///
/// Added in `2.8`.
int clear(int word, int pos) => word & ~(1 << pos);

/// Flips bit at [pos] in [word].
///
/// Positioning goes from the right to left,
/// meaning that [pos] being one sets the least meaningful bit.
///
/// Added in `2.8`.
int toggle(int word, int pos) => word ^ (1 << pos);

/// Reads bit at [pos] in [word].
///
/// Positioning goes from the right to left,
/// meaning that [pos] being one sets the least meaningful bit.
///
/// Added in `2.8`.
int read(int word, int pos) => (word >> pos) & 1;

/// Reads bit at [pos] in [word].
///
/// Positioning goes from the right to left,
/// meaning that [pos] being one sets the least meaningful bit.
///
/// Added in `2.8`.
bool readBit(int word, int pos) => read(word, pos).toBool();
