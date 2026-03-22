// DIRECTORIES

import 'package:xw/mixins.dart';

/// Denoting two different? elements, like a folder (F/S).
///
/// Added in `2.8`.
abstract interface class Directory<F, S> {
  /// The First element of the [Directory].
  ///
  /// Added in `2.8`.
  abstract final F first;

  /// The Second element of the [Directory].
  ///
  /// Added in `2.8`.
  abstract final S second;

  /// Generates a Constant [Directory] with [first],
  /// then [second].
  ///
  /// Added in `2.8`.
  const factory Directory(F first, S second) = _Directory;

  /// Generates a Constant with `exp`ort mode on.
  ///
  /// Added in `2.8`.
  const factory Directory.exp({required F first, required S second}) =
      _Directory.named;

  @override
  /// Should normally give out:
  /// [first]`/`[second].
  ///
  /// But otherwise could give out:
  /// [first]`, `[second].
  ///
  /// Added in `2.8`.
  toString({bool directory = true});
}

/// Denoting three different? elements, like a folder (F/S/T).
abstract interface class DirectoryShort<F, S, T> implements Directory<F, S> {
  /// The First element of the [DirectoryShort].
  ///
  /// Added in `2.8`.
  @override
  abstract final F first;

  /// The Second element of the [DirectoryShort].
  ///
  /// Added in `2.8`.
  @override
  abstract final S second;

  /// The Third element of the [DirectoryShort].
  ///
  /// Added in `2.8`.
  abstract final T third;

  /// Generates a Constant [Directory] with [first],
  /// then [second],
  /// then [third].
  ///
  /// Added in `2.8`.
  const factory DirectoryShort(F first, S second, T third) = _DirectoryShort;

  /// Generates a Constant with `exp`ort mode on.
  ///
  /// Added in `2.8`.
  const factory DirectoryShort.exp({
    required F first,
    required S second,
    required T third,
  }) = _DirectoryShort.named;

  @override
  /// Should normally give out:
  /// [first]`/`[second]`/`[third].
  ///
  /// But otherwise could give out:
  /// [first]`, `[second]`, `[third].
  ///
  /// Added in `2.8`.
  toString({bool directory = true});
}

// MIXINS

/// Added in `2.8`.
mixin DirectoryBase<F, S> implements Directory<F, S> {
  @override
  toString({bool directory = true}) =>
      (directory) ? "$first/$second" : "$first, $second";
}

/// Added in `2.8`.
mixin DirectoryShortBase<F, S, T> implements DirectoryShort<F, S, T> {
  @override
  toString({bool directory = true}) =>
      (directory) ? "$first/$second/$third" : "$first, $second, $third";
}

// EXTENSIONS
/// Added in `2.8`.
extension DirectoryIterableFS<F, S> on Iterable<Directory<F, S>> {
  Iterable<Directory<F, S>> specDir(Object? folder) => [
    for (Directory<F, S> current in this)
      if (current.first == folder) current,
  ];

  /// Expresses the [Directory].
  ///
  /// If [single] is `true` then it will do it like:
  /// ```
  /// first/second
  /// first/second
  /// first/second
  /// ```
  /// else it would do:
  /// ```
  /// first/
  ///   second
  ///   second
  /// first/
  ///   second
  /// ```
  ///
  /// [directory] toggles the [directory] in [toString] of [Directory]
  /// (only if [single] is `true`).
  ///
  /// [tabs] is the amount of spaces it uses (only if [single] is `true`).
  /// `null` means it uses `\t`.
  ///
  /// Added in `2.8`.
  String expDir({bool single = true, bool directory = true, int? tabs}) =>
      (single) ? _nExpDir(directory) : _expDir(tabs);

  String _nExpDir(bool dir) {
    String mule = "";
    Set<F> highs = {for (Directory<F, S> current in this) current.first};
    for (F curHigh in highs) {
      for (Directory<F, S> curLow in specDir(curHigh)) {
        mule += "${curLow.toString(directory: dir)}\n";
      }
    }
    return mule;
  }

  String _expDir(int? tabs) {
    String mule = "";
    Set<F> highs = {for (Directory<F, S> current in this) current.first};
    for (F curHigh in highs) {
      mule += "$curHigh/\n";
      for (Directory<F, S> curLow in specDir(curHigh)) {
        if (tabs == null) {
          mule += "\t${curLow.second}\n";
        } else {
          mule += "${" " * tabs}${curLow.second}\n";
        }
      }
    }
    mule = mule.truncate(mule.length - 1);
    return mule;
  }
}

// ACTUAL CLASSES

/// Added in `2.8`.
class _Directory<F, S> implements Directory<F, S> {
  @override
  final F first;
  @override
  final S second;

  const _Directory(this.first, this.second);
  const _Directory.named({required this.first, required this.second});

  @override
  toString({bool directory = true}) =>
      (directory) ? "$first/$second" : "$first, $second";
}

/// Added in `2.8`.
class _DirectoryShort<F, S, T> implements DirectoryShort<F, S, T> {
  @override
  final F first;

  @override
  final S second;

  @override
  final T third;

  const _DirectoryShort(this.first, this.second, this.third);
  const _DirectoryShort.named({
    required this.first,
    required this.second,
    required this.third,
  });

  @override
  toString({bool directory = true}) =>
      (directory) ? "$first/$second/$third" : "$first, $second, $third";
}
