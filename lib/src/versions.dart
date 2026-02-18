import 'date/date.dart';
import 'extension.dart';
import 'array.dart';
import 'internal.dart';


enum VersionId {
  major,
  standard,
  manor,
  minor,
}

/// used to save versions, make another class to especially use
///
/// standard version for demonstration is:
/// 5.2.3.2 with the name "Overhaul 2.0" and on 27th August, 2025
///
/// previous and next expected to be == and not => or <=
class VersionToken {
  /// major as in X.#.#.#
  final int major;
  /// standard as in #.X.#.#
  final int standard;
  /// manor as in #.#.X.#
  final int manor;
  /// minor as in #.#.#.X
  final int minor;
  final String? _name;
  /// the previous version
  VersionToken? prev;
  /// the next version
  VersionToken? next;
  final Date? _date;

  /// the title to the version
  ///
  /// will crash if there is no base title
  String get name {
    // print("$_name;2;$version;$prev");
    return _name ?? prev!.name;
  }
  /// the release date
  ///
  /// only reason for being nullable is if the
  /// release date is unknown or not wanted to be included
  Date? get date {
    if (prev == null) {return _date;}
    else {return _date ?? prev!.date;}
  }

  /// goes forwards/backwards amount of times you say it to
  ///
  /// example:
  /// 5.2.3.2 (8) => 5.2.5.1;
  /// 5.2.3.2 (-3) = > 5.2.2.6;
  VersionToken revolveVer(int amount) {
    VersionToken veTo = this;
    for(int i = 0; i != amount; i = i.towardsZero) {
      if (amount.plusSide) {veTo = veTo.nextVer;}
      else {veTo = veTo.prevVer;}}
    return veTo;
  }

  // make highEXTENSION to get the highest before the next version

  // versions around it


  // return VersionToken takes first
  // then List<VersionToken>
  // then List<int>
  // then List<String>
  // then List<Date>
  // then bool


  // private functions


  // minor:
  VersionToken? get _nextVer => next;

  VersionToken? get _prevVer => prev;


  // manor:
  VersionToken? get _nextManor {
    VersionToken? veTo = _nextVer;
    while (veTo != null) {
      if (manor != veTo.manor || standard != veTo.standard || major != veTo.major) {return veTo;}
      veTo = veTo._nextVer;
    }
    return null;
  }

  VersionToken? get _prevManor {
    VersionToken? veTo = _prevVer;
    while (veTo != null) {
      if (manor != veTo.manor || standard != veTo.standard || major != veTo.major) {return veTo.thisManor;}
      veTo = veTo._prevVer;
    }
    return null;
  }

  VersionToken? get _baseManor {
    VersionToken veTo = base;
    if (veTo.isManor) {return veTo;}
    return veTo._nextManor;
  }



  // standard:
  VersionToken? get _nextStandard {
    VersionToken? veTo = _nextManor;
    while (veTo != null) {
      if (standard != veTo.standard || major != veTo.major) {return veTo;}
      veTo = veTo._nextManor;
    }
    return null;
  }

  VersionToken? get _prevStandard {
    VersionToken? veTo = _prevManor;
    while (veTo != null) {
      if (standard != veTo.standard || major != veTo.major) {return veTo.thisStandard;}
      veTo = veTo._prevManor;
    }
    return null;
  }

  VersionToken? get _baseStandard {
    VersionToken veTo = base;
    if (veTo.isStandard) {return veTo;}
    return veTo._nextStandard;
  }


  // major:
  VersionToken? get _nextMajor {
    VersionToken? veTo = _nextStandard;
    while (veTo != null) {
      if (major != veTo.major) {return veTo;}
      veTo = veTo._nextStandard;
    }
    return null;
  }

  VersionToken? get _prevMajor {
    VersionToken? veTo = _prevStandard;
    while (veTo != null) {
      if (veTo.major != major) {return veTo.thisMajor;}
      veTo = veTo._prevStandard;
    }
    return null;
  }

  VersionToken? get _baseMajor {
    VersionToken veTo = base;
    if (veTo.isMajor) {return veTo;}
    return veTo._nextMajor;
  }


  // name:
  VersionToken? get _nextName {
    VersionToken? veTo = _nextVer;
    while (veTo != null) {
      if (veTo.name != name) {return veTo;}
      veTo = veTo._nextVer;
    }
    return null;
  }

  VersionToken? get _prevName {
    VersionToken? veTo = _prevVer;
    while (veTo != null) {
      if (veTo.name != name) {return veTo.thisName;}
      veTo = veTo._prevVer;
    }
    return null;
  }


  // date:
  VersionToken? get _nextDate {
    VersionToken? veTo = _nextVer;
    while (veTo != null) {
      if (veTo.date != date) {return veTo;}
      veTo = veTo._nextVer;
    }
    return null;
  }

  VersionToken? get _prevDate {
    VersionToken? veTo = _prevVer;
    while (veTo != null) {
      if (veTo.date != date) {return veTo.thisDate;}
      veTo = veTo._prevVer;
    }
    return null;
  }


  // other:
  bool? _isBefore(VersionToken other) {
    VersionToken? veTo = base;
    while (veTo != null) {
      if (other == veTo) {return false;}
      if (this == veTo) {return true;}
      veTo = veTo._nextVer;
    }
    return null;
  }

  bool? _isAfter(VersionToken other) {
    VersionToken? veTo = base;
    while (veTo != null) {
      if (other == veTo) {return true;}
      if (this == veTo) {return false;}
      veTo = veTo._nextVer;
    }
    return null;
  }



  // public base functions


  // minor:
  /// gets a list of the minor versions, for this manor
  ///
  /// example:
  /// 5.2.3.2 => [5.2.3.0, 5.2.3.1, 5.2.3.2, 5.2.3.3]
  List<VersionToken> get theseMinors {
    VersionToken veTo = thisManor;
    List<VersionToken> list = [veTo];
    while (veTo != highManor) {
      veTo = veTo.nextVer;
      list.add(veTo);
    }
    return list;
  }

  /// gets every version
  ///
  /// example:
  /// 5.2.3.2 => [0.0.1.0, 0.0.1.1, ..., 6.3.5.6, 6.3.5.7]
  List<VersionToken> get allMinors {
    VersionToken veTo = base;
    List<VersionToken> list = [veTo];
    while (veTo != latest) {
      veTo = veTo.nextVer;
      list.add(veTo);
    }
    return list;
  }

  /// gets a list of the minor versions value, for this manor
  ///
  /// example:
  /// 5.2.3.2 => [0, 1, 2, 3]
  List<int> get valueTheseMinors {
    List<int> list = [];
    for (VersionToken veTo in theseMinors) {list.add(veTo.minor);}
    return list;}

  /// true since all versions end with something at the end
  bool get isMinor => true;

  List<String> get stringTheseMinors {
    List<String> list = [];
    for (VersionToken veTo in theseMinors) {list.add(veTo.toVersion());}
    return list;
  }


  // manor:
  /// gets this manor version
  ///
  /// example:
  /// 5.2.3.2 => 5.2.3.0
  VersionToken get thisManor {
    VersionToken veTo = this;
    VersionToken? prevVeTo = veTo._prevVer;
    while (prevVeTo != null) {
      if (prevVeTo.manor != veTo.manor || prevVeTo.standard != veTo.standard || prevVeTo.major != veTo.major)
      {return veTo;}
      veTo = prevVeTo;
      prevVeTo = veTo._prevVer;
    }
    return veTo;
  }

  /// gets highest manor version
  ///
  /// example:
  /// 5.2.3.2 => 5.2.3.3
  VersionToken get highManor {
    VersionToken veTo = this;
    VersionToken? nextVeTo = veTo._nextVer;
    while (nextVeTo != null) {
      if (nextVeTo.manor != veTo.manor || nextVeTo.standard != veTo.standard || nextVeTo.major != veTo.major)
      {return veTo;}
      veTo = nextVeTo;
      nextVeTo = veTo._nextVer;
    }
    return veTo;
  }

  /// gets a list of the manor versions, for this standard
  ///
  /// example:
  /// 5.2.3.2 => [5.2.0.0, 5.2.1.0, 5.2.2.0, 5.2.3.0, 5.2.4.0]
  List<VersionToken> get theseManors {
    VersionToken veTo = thisStandard;
    List<VersionToken> list = [veTo];
    while (veTo != highStandard) {
      veTo = veTo.nextManor;
      list.add(veTo);
    }
    return list;
  }

  /// gets a list of the minor versions, for this standard
  ///
  /// example:
  /// 5.2.3.2 => [5.2.0.0, 5.2.0.1, ..., 5.2.4.3, 5.2.4.4]
  List<VersionToken> get allTheseManors {
    VersionToken veTo = thisStandard;
    List<VersionToken> list = [veTo];
    while (veTo != highStandard) {
      veTo = veTo.nextVer;
      list.add(veTo);
    }
    return list;
  }

  /// gets a list of the every manor version
  ///
  /// example:
  /// 5.2.3.2 => [0.0.1.0, 0.0.2.0, ..., 6.3.4.0, 6.3.5.0]
  List<VersionToken> get allManors {
    if (_baseManor == null) {return [];}
    VersionToken veTo = baseManor;
    List<VersionToken> list = [veTo];
    while (veTo._nextManor != null) {
      veTo = veTo.nextManor;
      list.add(veTo);
    }
    return list;
  }

  /// gets a list of the manor versions value, for this standard
  ///
  /// example:
  /// 5.2.3.2 => [0, 1, 2, 3, 4]
  List<int> get valueTheseManors {
    List<int> list = [];
    for (VersionToken veTo in theseManors) {list.add(veTo.manor);}
    return list;}

  /// if the version ends with .0
  bool get isManor {
    if (minor == 0) {return true;}
    else {return false;}
  }

  List<String> get stringTheseManors {
    List<String> list = [];
    for (VersionToken veTo in theseManors) {list.add(veTo.toVersion());}
    return list;
  }


  // standard:
  /// gets this standard version
  ///
  /// example:
  /// 5.2.3.2 => 5.2.0.0
  VersionToken get thisStandard {
    VersionToken veTo = this;
    VersionToken? prevVeTo = veTo._prevManor;
    while (prevVeTo != null) {
      if (prevVeTo.standard != veTo.standard || prevVeTo.major != veTo.major) {return veTo;}
      veTo = prevVeTo;
      prevVeTo = veTo._prevManor;
    }
    return veTo;
  }

  /// gets highest standard version
  ///
  /// example:
  /// 5.2.3.2 => 5.2.4.4
  VersionToken get highStandard {
    VersionToken veTo = this;
    VersionToken? nextVeTo = veTo._nextManor;
    while (nextVeTo != null) {
      if (nextVeTo.standard != veTo.standard || nextVeTo.major != veTo.major) {return veTo;}
      veTo = nextVeTo;
      nextVeTo = veTo._nextManor;
    }
    return veTo;
  }

  /// gets a list of every standard version, for this major
  ///
  /// example:
  /// 5.2.3.2 => [5.0.0.0, 5.1.0.0, 5.2.0.0, 5.3.0.0]
  List<VersionToken> get theseStandards {
    VersionToken veTo = thisMajor;
    List<VersionToken> list = [veTo];
    while (veTo != highMajor) {
      veTo = veTo.nextStandard;
      list.add(veTo);
    }
    return list;
  }

  /// gets a list of every minor version, for this major
  ///
  /// example:
  /// 5.2.3.2 => [5.0.0.0, 5.0.0.1, ..., 5.3.6.5, 5.3.6.6]
  List<VersionToken> get allTheseStandards {
    VersionToken veTo = thisMajor;
    List<VersionToken> list = [veTo];
    while (veTo != highMajor) {
      veTo = veTo.nextVer;
      list.add(veTo);
    }
    return list;
  }

  /// gets a list of the every standard version
  ///
  /// example:
  /// 5.2.3.2 => [0.1.0.0, 0.2.0.0, ..., 6.2.0.0, 6.3.0.0]
  List<VersionToken> get allStandards {
    if (_baseStandard == null) {return [];}
    VersionToken veTo = baseStandard;
    List<VersionToken> list = [veTo];
    while (veTo._nextStandard != null) {
      veTo = veTo.nextStandard;
      list.add(veTo);
    }
    return list;
  }

  /// gets a list of every standard version value, for this major
  ///
  /// example:
  /// 5.2.3.2 => [0, 1, 2, 3]
  List<int> get valueTheseStandards {
    List<int> list = [];
    for (VersionToken veTo in theseStandards) {list.add(veTo.standard);}
    return list;}

  /// if the version ends with .0.0
  bool get isStandard {
    if (manor == 0 && minor == 0) {return true;}
    else {return false;}
  }

  List<String> get stringTheseStandards {
    List<String> list = [];
    for (VersionToken veTo in theseStandards) {list.add(veTo.toVersion());}
    return list;
  }


  // major:
  /// gets this major version
  ///
  /// example:
  /// 5.2.3.2 => 5.0.0.0
  VersionToken get thisMajor {
    VersionToken veTo = this;
    VersionToken? prevVeTo = veTo._prevStandard;
    while (prevVeTo != null) {
      if (prevVeTo.major != veTo.major) {return veTo;}
      veTo = prevVeTo;
      prevVeTo = veTo._prevStandard;
    }
    return veTo;
  }

  /// gets highest major version
  ///
  /// example:
  /// 5.2.3.2 => 5.3.6.6
  VersionToken get highMajor {
    VersionToken veTo = this;
    VersionToken? nextVeTo = veTo._nextStandard;
    while (nextVeTo != null) {
      if (nextVeTo.major != veTo.major) {return veTo;}
      veTo = nextVeTo;
      nextVeTo = veTo._nextStandard;
    }
    return veTo;
  }

  /// gets a list of every major
  ///
  /// example:
  /// 5.2.3.2 => [1.0.0.0, 2.0.0.0, 3.0.0.0, 4.0.0.0, 5.0.0.0, 6.0.0.0]
  List<VersionToken> get allMajors {
    if (_baseMajor == null) {return [];}
    VersionToken veTo = baseMajor;
    List<VersionToken> list = [veTo];
    while (veTo._nextMajor != null) {
      veTo = veTo.nextMajor;
      list.add(veTo);
    }
    return list;}

  /// gets a list of every major's value
  ///
  /// example:
  /// 5.2.3.2 => [1, 2, 3, 4, 5, 6]
  List<int> get valueMajors {
    List<int> list = [];
    for (VersionToken veTo in theseMajors) {list.add(veTo.major);}
    return list;}

  /// if the version ends with .0.0.0
  bool get isMajor {
    if (standard == 0 && manor == 0 && minor == 0) {return true;}
    else {return false;}
  }

  List<String> get stringTheseMajors {
    List<String> list = [];
    for (VersionToken veTo in theseStandards) {list.add(veTo.toVersion());}
    return list;
  }



  // name:
  /// gets earliest version with this name
  ///
  /// example:
  /// "Overhaul 2.0" (5.2.3.2) => "Overhaul 2.0" (5.2.1.6)
  VersionToken get thisName {
    VersionToken veTo = this;
    VersionToken? prevVeTo = veTo._prevVer;
    while (prevVeTo != null) {
      if (prevVeTo.name != veTo.name) {return veTo;}
      veTo = prevVeTo;
      prevVeTo = veTo._prevVer;
    }
    return veTo;
  }

  /// gets latest version with this name
  ///
  /// example:
  /// "Overhaul 2.0" (5.2.3.2) => "Overhaul 2.0" (5.2.4.3)
  VersionToken get highName {
    VersionToken veTo = this;
    VersionToken? nextVeTo = veTo._nextVer;
    while (nextVeTo != null) {
      if (nextVeTo.name != veTo.name) {return veTo;}
      veTo = nextVeTo;
      nextVeTo = veTo._nextVer;
    }
    return veTo;
  }

  /// gets a list of the every named version
  ///
  /// example:
  /// 5.2.3.2 => [0.1.1.2, 1.0.0.0, ..., 6.1.3.4, 6.2.2.5]
  List<VersionToken> get allNames {
    VersionToken veTo = base;
    List<VersionToken> list = [];
    if (veTo.isNamed) {list.add(veTo);}
    while (veTo._nextVer != null) {
      veTo = veTo.nextVer;
      if (veTo.isNamed) {list.add(veTo);}
    }
    return list;
  }

  /// gets a list of the every named version
  ///
  /// example:
  /// 5.2.3.2 => ["Release", "Overhaul 1.0", ..., "Time Machine", "Overhaul 2.6"]
  List<String> get valueNames {
    List<String> list = [];
    for (VersionToken veTo in allNames) {list.add(veTo.name);}
    return list;
  }

  /// if the version is named
  bool get isNamed {
    if (_name == null) {return false;}
    else {return true;}
  }

  List<String> get stringAllNames {
    List<String> list = [];
    for (VersionToken veTo in theseStandards) {list.add(veTo.toVersion());}
    return list;
  }


  // date:
  /// gets earliest version from this day
  ///
  /// example:
  /// 27th August 2025 (5.2.3.2) => 27th August 2025 (5.2.3.1)
  VersionToken get thisDate {
    VersionToken veTo = this;
    VersionToken? prevVeTo = veTo._prevVer;
    while (prevVeTo != null) {
      if (prevVeTo.date != veTo.date) {return veTo;}
      veTo = prevVeTo;
      prevVeTo = veTo._prevVer;
    }
    return veTo;
  }

  /// gets latest version from this day
  ///
  /// example:
  /// 27th August 2025 (5.2.3.2) => 27th August 2025 (5.2.3.3)
  VersionToken get highDate {
    VersionToken veTo = this;
    VersionToken? nextVeTo = veTo._nextVer;
    while (nextVeTo != null) {
      if (nextVeTo.date != veTo.date) {return veTo;}
      veTo = nextVeTo;
      nextVeTo = veTo._nextVer;
    }
    return veTo;
  }

  /// gets a list of the every dated version
  ///
  /// example:
  /// 5.2.3.2 => [0.0.1.0, 0.0.1.1, ..., 6.3.5.4, 6.3.5.7]
  List<VersionToken> get allDates {
    VersionToken veTo = base;
    List<VersionToken> list = [];
    if (veTo.isDated) {list.add(veTo);}
    while (veTo._nextVer != null) {
      veTo = veTo.nextVer;
      if (veTo.isDated) {list.add(veTo);}
    }
    return list;
  }

  /// gets a list of the every named version
  ///
  /// example:
  /// 5.2.3.2 => ["Release", "Overhaul 1.0", ..., "Time Machine", "Overhaul 2.6"]
  List<Date> get valueDates {
    List<Date> list = [];
    for (VersionToken veTo in allNames) {list.add(veTo.date!);}
    return list;
  }

  /// if the version is dated
  bool get isDated {
    if (_date == null) {return false;}
    else {return true;}
  }


  // other:
  /// gets the first version
  ///
  /// example:
  /// 5.2.3.2 => 0.0.1.0
  VersionToken get baseVer {
    VersionToken veTo = this;
    while (veTo._prevVer != null) {veTo = veTo.prevVer;}
    return veTo;
  }

  /// gets the latest version
  ///
  /// example:
  /// 5.2.3.2 => 6.3.5.7
  VersionToken get lastVer {
    VersionToken veTo = this;
    while (veTo._nextVer != null) {veTo = veTo.nextVer;}
    return veTo;
  }

  /// can you do
  ///
  /// [nextVer], [nextManor], [nextStandard], [nextMajor],
  /// [nextName], [nextDate]
  Array<bool> get validNext {
    Array<bool> array = Array(6);
    array[0] = (_nextVer != null);
    array[1] = (_nextManor != null);
    array[2] = (_nextStandard != null);
    array[3] = (_nextMajor != null);
    array[4] = (_nextName != null);
    array[5] = (_nextDate != null);
    return array;
  }
  /// can you do
  ///
  /// [prevVer], [prevManor], [prevStandard], [prevMajor],
  /// [prevName], [prevDate]
  Array<bool> get validPrev {
    Array<bool> array = Array(6);
    array[0] = (_prevVer != null);
    array[1] = (_prevManor != null);
    array[2] = (_prevStandard != null);
    array[3] = (_prevMajor != null);
    array[4] = (_prevName != null);
    array[5] = (_prevDate != null);
    return array;
  }
  /// can you do
  ///
  /// [thisVer], [thisManor], [thisStandard], [thisMajor],
  /// [thisName], [thisDate]
  Array<bool> get validThis {
    Array<bool> array = Array(6,fill:true);
    return array;
  }
  /// can you do
  ///
  /// [highVer], [highManor], [highStandard], [highMajor],
  /// [highName], [highDate]
  Array<bool> get validHigh {
    Array<bool> array = Array(6,fill:true);
    return array;
  }



  // public conversion functions


  // minor:
  /// gets next version
  VersionToken get nextVer => _nextVer ?? (throw "no next version for $this");

  /// gets previous version
  VersionToken get prevVer => _prevVer ?? (throw "no previous version for $this");


  // manor:
  /// gets next manor version
  ///
  /// example:
  /// 5.2.3.2 => 5.2.4.0
  VersionToken get nextManor => _nextManor ?? (throw "no next manor for $this");

  /// get previous manor version
  ///
  /// example:
  /// 5.2.3.2 => 5.2.2.0
  VersionToken get prevManor => _prevManor ?? (throw "no previous manor for $this");

  /// gets the first manor version
  ///
  /// example:
  /// 5.2.3.2 => 0.0.1.0
  VersionToken get baseManor => _baseManor ?? (throw "no manor version for $this");


  // standard:
  /// get next standard version
  ///
  /// example:
  /// 5.2.3.2 => 5.3.0.0
  VersionToken get nextStandard => _nextStandard ?? (throw "no next standard for $this");

  /// gets previous standard version
  ///
  /// example:
  /// 5.2.3.2 => 5.1.0.0
  VersionToken get prevStandard => _prevStandard ?? (throw "no previous standard for $this");

  /// gets the first standard version
  ///
  /// example:
  /// 5.2.3.2 => 0.1.0.0
  VersionToken get baseStandard => _baseStandard ?? (throw "no standard version for $this");


  // major:
  /// gets next major version
  ///
  /// example:
  /// 5.2.3.2 => 6.0.0.0
  VersionToken get nextMajor => _nextMajor ?? (throw "no next major for $this");

  /// gets previous major version
  ///
  /// example:
  /// 5.2.3.2 => 4.0.0.0
  VersionToken get prevMajor => _prevMajor ?? (throw "no previous major for $this");

  /// gets the first standard version
  ///
  /// example:
  /// 5.2.3.2 => 1.0.0.0
  VersionToken get baseMajor => _baseMajor ?? (throw "no major version for $this");


  // name:
  /// gets next differently named version
  ///
  /// example:
  /// "Overhaul 2.0" => "Overhaul 2.1"
  VersionToken get nextName => _nextName ?? (throw "there was no version after with a different name for $this");

  /// gets previous differently named version
  ///
  /// example:
  /// "Overhaul 2.0" => "Overhaul 1.6"
  VersionToken get prevName => _prevName ?? (throw "there was no version before with a different name for $this");


  // date:
  /// gets next version with a different date,
  /// is usually the next version
  ///
  /// example:
  /// 27th August 2025 => 29th August 2025
  VersionToken get nextDate => _nextDate ?? (throw "there was no version after with a different date for $this");

  /// gets previous version with a different date,
  /// is usually the next version
  ///
  /// example:
  /// 27th August 2025 => 24th August 2025
  VersionToken get prevDate => _prevDate ?? (throw "there was no version before with a different date for $this");



  // public alias/variant functions


  // Minor => Ver:
  /// gets next version
  VersionToken get nextMinor => nextVer;

  /// gets previous version
  VersionToken get prevMinor => prevVer;


  // truncate (this):
  /// alias for thisManor
  VersionToken get truncateManor => thisManor;

  /// alias for thisStandard
  VersionToken get truncateStandard => thisStandard;

  /// alias for thisMajor
  VersionToken get truncateMajor => thisMajor;

  /// alias for thisName
  VersionToken get truncateName => thisName;

  /// alias for thisDate
  VersionToken get truncateDate => thisDate;


  // extend (high):
  /// alias for highManor
  VersionToken get extendManor => highManor;

  /// alias for highStandard
  VersionToken get extendStandard => highStandard;

  /// alias for highMajor
  VersionToken get extendMajor => highMajor;

  /// alias for highName
  VersionToken get extendName => highName;

  /// alias for highDate
  VersionToken get extendDate => highDate;


  // last (high):
  /// alias for highManor
  VersionToken get lastManor => highManor;

  /// alias for highStandard
  VersionToken get lastStandard => highStandard;

  /// alias for highMajor
  VersionToken get lastMajor => highMajor;

  /// alias for highName
  VersionToken get lastName => highName;

  /// alias for highDate
  VersionToken get lastDate => highDate;


  // alternate for base/latest:
  /// alias for baseVer
  VersionToken get firstVer => baseVer;

  /// alias for baseVer
  VersionToken get first => baseVer;

  /// alias for baseVer
  VersionToken get base => baseVer;


  /// alias for lastVer
  VersionToken get recentVer => lastVer;

  /// alias for lastVer
  VersionToken get recent => lastVer;

  /// alias for lastVer
  VersionToken get latest => lastVer;

  /// alias for lastVer
  VersionToken get latestVer => lastVer;

  /// alias for lastVer
  VersionToken get last => lastVer;


  /// alias for allMinors
  List<VersionToken> get everyVer => allMinors;

  /// alias for allMinors
  List<VersionToken> get every => allMinors;

  /// alias for allMinors
  List<VersionToken> get all => allMinors;


  // alternate for majors:
  /// alias for allMajors
  List<VersionToken> get theseMajors => allMajors;

  /// alias for valueMajors
  List<int> get valueTheseMajors => valueMajors;


  // alternate for "name":
  /// alias for nextName
  VersionToken get nextTitle => nextName;

  /// alias for prevName
  VersionToken get prevTitle => prevName;

  /// alias for thisName
  VersionToken get thisTitle => thisName;

  /// alias for thisName
  VersionToken get truncateTitle => thisName;

  /// alias for highName
  VersionToken get highTitle => highName;

  /// alias for highName
  VersionToken get extendTitle => highName;

  /// alias for highName
  VersionToken get lastTitle => highName;

  /// alias for highName
  VersionToken get latestTitle => highName;




  String get version => "$major.$standard.$manor.$minor";
  String toVersion() {
    if (minor != 0) {return "$major.$standard.$manor.$minor";}
    else if (manor != 0) {return "$major.$standard.$manor";}
    else {return "$major.$standard";}
  }

  @override
  String toString() {
    String additionDate;
    if (date != null) {additionDate = " at $date";}
    else {additionDate = "";}
    return "${toVersion()}$additionDate with the name: \"$name\"";
  }

  VersionToken(this.major,this.standard,{this.manor = 0, this.minor = 0,
    String? name,this.prev,this.next,Date? date}):_name = name, _date = date;




  /// gives back inputted amount of versions ahead
  VersionToken operator +(int value) {return revolveVer(value);}
  /// gives back inputted amount of versions behind
  VersionToken operator -(int value) {return revolveVer(-value);}
  /// is true if version is made before this one
  ///
  /// example:
  /// 5.2.3.2 < 5.1.2.6 => true
  ///
  /// example 2:
  /// 5.2.3.2 < 6.2.5.3 => false
  ///
  /// example 3:
  /// 5.2.3.2 < 5.2.3.2 => false
  bool operator <(VersionToken other) => _isBefore(other) ?? (throw "version: [$other] doesn't co-exist with [$this]");
  /// is true if version is made after this one
  ///
  /// example:
  /// 5.2.3.2 > 5.1.2.6 => false
  ///
  /// 5.2.3.2 > 6.2.5.3 => true
  ///
  /// example 3:
  /// 5.2.3.2 > 5.2.3.2 => false
  bool operator >(VersionToken other) => _isAfter(other) ?? (throw "version: [$other] doesn't co-exist with [$this]");
  /// is true if version is equal to or made before this one
  ///
  /// example:
  /// 5.2.3.2 <= 5.1.2.6 => true
  ///
  /// example 2:
  /// 5.2.3.2 <= 6.2.5.3 => false
  ///
  /// example 3:
  /// 5.2.3.2 <= 5.2.3.2 => true
  bool operator <=(VersionToken other) {
    if (this == other) {return true;}
    else {return this < other;}
  }
  /// is true if version is equal to or made after this one
  ///
  /// example:
  /// 5.2.3.2 >= 5.1.2.6 => false
  ///
  /// 5.2.3.2 >= 6.2.5.3 => true
  ///
  /// example 3:
  /// 5.2.3.2 >= 5.2.3.2 => true
  bool operator >=(VersionToken other) {
    if (this == other) {return true;}
    else {return this > other;}
  }

  /// gives back the version of this# for the VersionId
  VersionToken operator %(VersionId id) {
    if (id == VersionId.major) {return thisMajor;}
    else if (id == VersionId.standard) {return thisStandard;}
    else if (id == VersionId.manor) {return thisManor;}
    else {return this;}
  }
  ///gives back correspond values for the version
  int operator [](int pos) {
    if (pos == 0) {return major;}
    else if (pos == 1) {return standard;}
    else if (pos == 2) {return manor;}
    else if (pos == 3) {return minor;}
    else {throw "index [$pos] out of range";}
  }

  @override
  bool operator ==(Object other) => identical(this,other) || (other is VersionToken && hashCode == other.hashCode);

  @override
  int get hashCode => Object.hash(major,standard,manor,minor,_name,prev,_date);

/*@override
  int get hashCode {
    int garbInt1 = _name.hashCode ^ _date.hashCode << major;
    int garbInt2 = garbInt1 >> manor;
    int garbInt3 = garbInt2 ^ standard.hashCode | minor.hashCode;
    return garbInt3 ^ prev.hashCode;
  }

  int get random {
    int garbInt1 = _name.hashCode ^ _date.hashCode << major;
    int garbInt2 = garbInt1 >> manor;
    int garbInt3 = garbInt2 ^ standard.hashCode | minor.hashCode;
    return garbInt3 ^ prev.hashCode & ((minor % 3 == 1) ? 760906259 : 349194851);
  }

  int get hash3 {
    return Object.hash(major,standard,manor,minor,_name,prev,_date);
  }*/
}