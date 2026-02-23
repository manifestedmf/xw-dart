import '../extension.dart';
import '../mixins.dart';

import 'scanner.dart';

const monthsName = ["January","February","March","April","May","June","July",
  "August","September", "October","November","December"];

String monthName(int month) {
  return monthsName[month-1];
}
// DENOTER IS A REAL WORD
/// Makes [number] into place denotation.
///
/// Example:
/// ```
/// print(placeDenoter(1)); // 1st
/// print(placeDenoter(15)); // 15th
/// print(placeDenoter(232)); // 232nd;
/// print(placeDenoter(-33)); // -33rd;
/// ```
///
/// Any [number] that is from 11 to 21 ends with `th`.
///
/// Any [number] that ends with `0` ends with `th`.
///
/// Any [number] that ends with `1` ends with `st`.
///
/// Any [number] that ends with `2` ends with `nd`.
///
/// Any [number] that ends with `3` ends with `rd`.
///
/// Else it ends with `th`.
String placeDenoter(int number) {
  if (number >= 10 && number <= 20) {return "${number}th";}
  switch (number % 10) {
    case 1:return "${number}st";
    case 2:return "${number}nd";
    case 3:return "${number}rd";
    case _:return "${number}th";
  }
}

String usaTime(int hour) {
  if (hour == 0 || hour == 24) {
    return "12AM";
  } else if (hour == 12) {
    return "12PM";
  } else if (hour < 12) {
    return "${hour}AM";
  } else {
    return "${hour}PM";
  }
}

enum Weekday {
  monday(1,"Monday"),
  tuesday(2,"Tuesday"),
  wednesday(3,"Wednesday"),
  thursday(4,"Thursday"),
  friday(5,"Friday"),
  saturday(6,"Saturday"),
  sunday(7,"Sunday")
  ;
  final int value;
  final String name;
  const Weekday(this.value,this.name);
  static Weekday fromValue(int val) {
    for (Weekday weekday in values) {
      if (weekday.value == val) {return weekday;}
    }
    throw "$val isn't a weekday number";
  }
}
// TODO: fix julian -> gregorian change.

/// A Date, used to represent which day something happened on.
///
/// Import `package:xw/date.dart`.
///
/// Constructors are:
/// ```
/// Standard : Date(day, month, year, format:format);
/// American : Date.american(month, day, year, format:format);
/// ```
///
/// Functions:
/// [setYear]`(year)` gives back the date with the [year] being the `input`,
/// if the day was a leap day, and now there is now leap day,
/// the day will be Feb 29
///
/// [setMonth]`(month)` gives back the date with the [month] being the `input`,
/// leap day will be converted to Feb 29, if invalid,
/// expects `input` to be between 1 and 12
///
/// [setDay]`(day)` gives back the date with the [day] being the `input`,
/// expects `input` to be between 1 and the month's number of days
///
/// [setFormat]`(format)` gives back the date with the [format] being the `input`
///
/// [changeDay]`(amount)` gives back the date with the `amount` of days difference
///
/// [changeMonth]`(amount)` gives back the date with the `amount` of months difference
///
/// [changeYear]`(amount)` gives back the date with the `amount` of years difference
///
/// There are different ways for the [Date] to be represented,
/// used with the [toString]`()` function.
///
/// With the standard format definition being `#dd #{mm}, #y`.
///
/// Day formats:
/// ```
/// Date date = Date(8, 2, 2026);
/// date = date.setFormat("#d"); // uses day's value
/// print(date); // '8'
/// date = date.setFormat("#dh2"); // uses day's values
/// // but there is at least # amounts (like 2) of zeroes
/// print(date); // '08'
/// date = date.setFormat("#dd"); // uses denotation of day's values
/// print(date); // '8th'
/// date = date.setFormat("#ddh3");
/// print(date); // '008th'
/// ```
///
/// Month formats:
/// ```
/// Date date = Date(16, 9, 2009);
/// date = date.setFormat("#m"); // uses month's value
/// print(date); // '9'
/// date = date.setFormat("#mh2");
/// print(date); // '09'
/// date = date.setFormat("#mm"); // uses month's name
/// print(date); // 'September'
/// date = date.setFormat("#mm3"); // only uses 3 letters of month's name
/// // if it was '#mm4' then for may it would just be 'May'
/// print(date); // 'Sep'
/// ```
///
/// Year formats:
/// ```
/// Date date = Date(13, 5, 10306);
/// date = date.setFormat("#y"); // uses all of year's info
/// print(date); // '10306'
/// date = date.setYear(6); // changes year for date
/// print(date); // '6'
/// date = date.setFormat("#yh4");
/// print(date); // '0006'
/// date = date.setYear(1006);
/// date = date.setFormat("#yy"); // gives out that millennium year
/// print(date); // '006'
/// date = date.setFormat("#yyy"); // gives out that century year
/// print(date); // '06'
/// date = date.setFormat("#yyyy"); // gives out that decade year
/// print(date); // '6'
/// // the #yh[num] works for all year formats
/// ```
///
/// Weekday formats:
/// ```
/// Date date = Date(8, 1, 2025); // has weekday of wednesday
/// date = date.setFormat("#w"); // uses weekday's value as in monday is 1
/// // #wh[num] works too
/// print(date); // '3'
/// date = date.setFormat("ww"); // uses weekday's name
/// print(date); // 'Wednesday'
/// date = date.setFormat("ww3"); // uses first 3 letters of weekday's name
/// print(date); // 'Wed'
/// ```
class Date with CompareMixin<Date> {
  // TODO: should be changed to a non-private day.
  final int _day;
  final int _month;
  final int _year;
  final List<FormatToken> _format;


  // static months
  /// `january` = `1`
  static const january = 1;
  /// `jan` = `1`
  static const jan = january;
  /// `february` = `2`
  static const february = 2;
  /// `feb` = `2`
  static const feb = february;
  /// `march` = `3`
  static const march = 3;
  /// `mar` = `3`
  static const mar = march;
  /// `april` = `4`
  static const april = 4;
  /// `apr` = `4`
  static const apr = april;
  /// `may` = `5`
  static const may = 5;
  /// `june` = `6`
  static const june = 6;
  /// `jun` = `6`
  static const jun = june;
  /// `july` = `7`
  static const july = 7;
  /// `jul` = `7`
  static const jul = july;
  /// `august` = `8`
  static const august = 8;
  /// `aug` = `8`
  static const aug = august;
  /// `september` = `9`
  static const september = 9;
  /// `sep` = `9`
  static const sep = september;
  /// `october` = `10`
  static const october = 10;
  /// `oct` = `10`
  static const oct = october;
  /// `november` = `11`
  static const november = 11;
  /// `nov` = `11`
  static const nov = november;
  /// `december` = `12`
  static const december = 12;
  /// `dec` = `12`
  static const dec = december;

  // format single consts
  /// Format descriptor day value.
  ///
  /// `6` => `6`
  ///
  /// `27` => `27`
  ///
  /// `9` => `9`
  static const fmDscDay = "d";
  /// Format descriptor dayth.
  ///
  /// `6` => `6th`
  ///
  /// `1` => `1st`
  ///
  /// `29` => `29th`
  static const fmDscDayth = "dd";

  /// Format descriptor month value.
  ///
  /// `2` => `2`
  ///
  /// `10` => `10`
  ///
  /// `1` => `1`
  static const fmDscMonth = "m";
  /// Format descriptor month name.
  ///
  /// `2` => `February`
  ///
  /// `5` => `May`
  ///
  /// `7` => `July`
  static const fmDscMonthName = "mm";
  /// Format descriptor month name Truncated to be 3 letters.
  ///
  /// `2` => `Feb`
  ///
  /// `5` => `May`
  ///
  /// `1` => `Jan`
  static const fmDscMonthNameTrunc = "mm3";

  /// Format descriptor year full value,
  ///
  /// `2026` => `2026`
  ///
  /// `2003` => `2003`
  ///
  /// `439` => `439`
  static const fmDscYear = "y";
  /// Format descriptor year, 3 digits.
  ///
  /// `2026` => `026`
  ///
  /// `22` => `022`
  ///
  /// `954` => `954`
  static const fmDscYearMill = "yy";
  /// Format descriptor year, 2 digits.
  ///
  /// `2026` => `26`
  ///
  /// `890` => `90`
  ///
  /// `1592` => `92`
  static const fmDscYearCent = "yyy";
  /// Format descriptor year, 1 digit.
  ///
  /// `2026` => `6`
  ///
  /// `1318` => `8`
  ///
  /// `1180` => `0`
  static const fmDscYearDeca = "yyyy";

  /// format standard: `#`[fmDscDayth]` #{`[fmDscMonthName]`}, #`[fmDscYear]
  static const fmStd = "#$fmDscDayth #{$fmDscMonthName}, #$fmDscYear";
  /// format standard truncate: `#`[fmDscDayth]` #{`[fmDscMonthNameTrunc]`}, #`[fmDscYear]
  static const fmStdTrunc = "#$fmDscDayth #{$fmDscMonthNameTrunc}, #$fmDscYear";

  /// format us: `#`[fmDscMonthName]` #{`[fmDscDayth]`}, #`[fmDscYear]
  static const fmAmr = "#$fmDscMonthName #{$fmDscDayth}, #$fmDscYear";


  /// format standard output: `#{`[fmDscDay]`h2} #{`[fmDscMonth]`h2}, #{`[fmDscYearCent]`}`
  static const fmStdOut = "#{${fmDscDay}h2}/#{${fmDscMonth}h2}/#{$fmDscYearCent}";

  /// format us output: `#{`[fmDscMonth]`} #{`[fmDscYear]`}, #{`[fmDscYearCent]`}`
  static const fmAmrOut = "#{$fmDscMonth}/#{$fmDscDay}/#{$fmDscYearCent}";

  // static const valentines = Date._constructor(14,Date.feb,0,scan("#dd #{mm}, #y"));
  // static const fools = Date._constructor(1,Date.apr,0,"#dd #{mm}, #y");
  // static const halloween = Date._constructor(31,Date.oct,0,"#dd #{mm}, #y");
  // static const birthday = Date._constructor(14,11,2011,"#dd #{mm}, #y");
  // static const christmas = Date._constructor(25,12,0,"#dd #{mm}, #y");

  // static constructors
  /// This is a `Internal`-`Construct` function.
  ///
  /// Forces day to be between `1` & [monthMax].
  ///
  /// For example:
  /// ```
  /// dayConst(31, 2, true); // 29
  /// dayConst(26, 5, false); // 26
  /// dayConst(-10, 3, false); // 1
  /// ```
  static int dayConst(int day, int month, bool isLeapYear) {
    int monthsMax = computeMonthMax(month,isLeapYear);
    if (day <= 1) {day = 1;}
    else if (day >= monthsMax) {day = monthsMax;}
    return day;
  }
  /// This is a `Internal`-`Construct` function.
  ///
  /// Forces day to be between `1` & `12`.
  static int monthConst(int month) {
    if (month <= 1) {month = 1;}
    else if (month >= 12) {month = 12;}
    return month;
  }
  // yearConst doesnt exist since all years are valid
  // static
  /// This is a `Private`-`Change` function.
  ///
  /// Gives back the [month] & [year] from the [amount] of change
  /// you want to the [month].
  ///
  /// Used by the [changeMonth]`(amount)` function.
  static ({int month, int year}) _changeMonth(int amount, int month, int year) {
    int setMonth = month+amount;
    int setYear;
    if (setMonth > 12) {
      setYear = year + (setMonth-1) ~/ 12;
      while (setMonth > 12) {setMonth -= 12;}
    }
    else if (setMonth < 1) {
      setYear = year + (setMonth ~/ 12)-1;
      while (setMonth < 1) {setMonth += 12;}
    }
    else {setYear = year;}
    return (month:setMonth,year:setYear);
  }
  /// This is a `Private`-`Change` function.
  ///
  /// Gives back the [day] & [month] & [year] from the [amount] of change
  /// you want to the [day].
  ///
  /// Used by the [changeDay]`(amount)` function.
  static ({int day, int month, int year}) _changeDay(int amount, int day, int month, int year) {
    int setMonth;
    int setYear;
    int setDay = day+amount;
    int monthsMax = computeMonthMax(month,computeIsLeapYear(year));
    if (setDay > monthsMax) {
      (year:setYear,month:setMonth) = _changeMonth((setDay-1) ~/ monthsMax,month,year);
      while (setDay > monthsMax) {setDay -= monthsMax;}
    }
    else if (setDay < 1) {
      (year:setYear,month:setMonth) = _changeMonth((setDay ~/ monthsMax)-1,month,year);
      while (setDay > monthsMax) {setDay += monthsMax;}
    }
    else {setYear = year; setMonth = month;}
    return (day:setDay,month:setMonth,year:setYear);
  }
  /// This is a `Internal`-`Compute` function.
  ///
  /// Gives back the [day], for the whole [year], unique to that year.
  ///
  /// For example:
  /// ```
  /// computeDayOfTheYear(8, 2, 2026); // 39
  /// computeDayOfTheYear(31, 10, 2017); // 304
  /// computeDayOfTheYear(15, 13, 2018); // crash: "expected month to be from 1 to 12, not 13."
  /// ```
  ///
  /// Used by the [dayOfTheYear] getter.
  static int computeDayOfTheYear(int day, int month, bool isLeapYear) {
    if (month != monthConst(month)) {throw "expected month to be from 1 to 12, not $month.";}
    if (day != dayConst(day,month,isLeapYear)) {throw "expected day to be from 1 "
        "to ${computeMonthMax(month, isLeapYear)}, not $day.";}
    int mule = 0;
    for (int index = 1; index < month; index++) {
      mule += computeMonthMax(index,isLeapYear);
    }
    mule += day;
    return mule;
  }

  // static Date parseRecord(({int day,int month, int year}) input) {
  //   return Date(input.day,input.month,input.year);
  // }

  // info statics
  /// This is a `Internal`-`Compute` function.
  ///
  /// It returns true if the year is a leap year, and `false` if it is not.
  ///
  /// For Example:
  /// ```
  /// computeIsLeapYear(2026); // false
  /// computeIsLeapYear(2000); // true
  /// computeIsLeapYear(1900); // true
  /// computeIsLeapYear(875); // false
  /// ```
  ///
  /// Used by the [isLeapYear] getter.
  static bool computeIsLeapYear(int year) {
    if (year % 400 == 0) {return true;}
    if (year % 100 == 0) {return false;}
    if (year % 4 == 0) {return true;}
    return false;
  }

  /// This is a `Internal`-`Compute` function.
  ///
  /// Gives back the amount of days for the [month],
  /// also known as the highest day for the [month].
  ///
  /// The few Examples:
  /// ```
  /// computeMonthMax(2, true); // 29
  /// computeMonthMax(2, false); // 28
  /// computeMonthMax(6, false); // 30
  /// computeMonthMax(7, true); // 31
  /// ```
  ///
  /// Simple program meaning:
  ///
  /// If [month] is 2 & [isLeapYear] is `true`, then the answer is 29.
  ///
  /// If [month] is 2 & [isLeapYear] is `false`, then the answer is 28.
  ///
  /// If [month]`.isOdd` & [month] is less than 8, then the answer is 31.
  ///
  /// If [month]`.isEven` & [month] is more than 7, then the answer is 31.
  ///
  /// Else, the answer is 30.
  ///
  /// Used by the [monthMax] getter.
  static int computeMonthMax(int month, bool isLeapYear) {
    if (isLeapYear && month == feb) {return 29;}
    if (!isLeapYear && month == feb) {return 28;}
    if ((month.isOdd && month <= 7) ||
        (month.isEven && month >= 8)) {return 31;}
    return 30;
  }

  /// This is a `Internal`-`Compute` function.
  ///
  /// Gives back the amount of days that the [year] holds. ([isLeapYear])
  ///
  /// The Two Examples:
  /// ```
  /// computeYearMax(true); // 366
  /// computeYearMax(false); // 365
  /// ```
  ///
  /// Used by the [yearMax] getter.
  static int computeYearMax(bool isLeapYear) => (isLeapYear) ? 366 : 365;

  /// This is a `Internal`-`Compute` function.
  ///
  /// Gives back the amount of days apart that [high] is from [low].
  ///
  /// This function is inspired from `Google Sheets`' Date - Date.
  ///
  /// The function is best summed up with it returning [high] - [low].
  ///
  /// For example:
  /// ```
  /// computeDaysApart(Date(8, 2, 2026), Date(7, 2, 2025)); // 366
  /// ```
  ///
  /// Now, do remember that in the current version: `2.5`,
  /// the switch from `Julian` to `Gregorian`, hasn't been removed,
  /// so comparing dates with before 15 October 1582,
  /// with recent will result in wrong calculations.
  ///
  /// Is not full the same as [daysApart]`(`[low]`)`.
  static int computeDaysApart(Date high, Date low) {
    int highDay; int lowDay;
    highDay = high.dayOfTheYear;
    lowDay = low.dayOfTheYear;
    if (high == low) {return 0;}
    else if (high._month == low._month && high._year == low._year) {
      return high.day - low.day;
    }
    else if (high._year == low._year) {
      return highDay - lowDay;
    }
    else {
      int dayAmount = 0;
      if (high._year < low._year) {
        dayAmount += highDay - 1;
        do {
          dayAmount -= high.yearMax;
          high = Date(1,Date.jan,high._year+1);
        }
        while (high._year != low._year);
        dayAmount -= lowDay - high.dayOfTheYear;
      }
      else if (high._year > low._year) {
        dayAmount += highDay - 1;
        do {
          dayAmount += high.yearMax;
          high = Date(1,Date.jan,high._year-1);
        }
        while (high._year != low._year);
        dayAmount += high.dayOfTheYear - lowDay;
      }
      return dayAmount;
    }
  }

  // info ~statics
  /// Is a `Interface`-`Compute` getter.
  ///
  /// Is the same as [computeIsLeapYear]`(`[year]`)`.
  bool get isLeapYear => computeIsLeapYear(_year);
  /// Is a `Interface`-`Compute` getter.
  ///
  /// Is the same as [computeMonthMax]`(`[month]`, `[isLeapYear]`)`.
  int get monthMax => computeMonthMax(_month,isLeapYear);
  /// Is a `Interface`-`Compute` getter.
  ///
  /// Is the same as
  /// [computeDayOfTheYear]`(`[day]`, `[month]`, `[isLeapYear]`)`.
  int get dayOfTheYear => computeDayOfTheYear(_day,_month,isLeapYear);
  /// Is a `Interface`-`Compute` getter.
  ///
  /// Is the same as [computeYearMax]`(`[isLeapYear]`)`.
  int get yearMax => computeYearMax(isLeapYear);
  /// You should probably just use [computeDaysApart]
  int daysApart(Date other) => (this > other) ? computeDaysApart(this,other) : computeDaysApart(other,this);


  // week day
  /// Is a `Interface`-`Compute` getter.
  ///
  /// Gets the [Weekday] of the current date.
  ///
  /// Note: [weekday] bases itself on [computeDaysApart],
  /// so if it has a problem with computing, then this one does.
  ///
  /// For example:
  /// ```
  /// Date(6, 2, 2026).weekday; // Weekday.friday
  /// Date(12, 7, 1774).weekday; // Weekday.tuesday
  /// ```
  Weekday get weekday {
    Weekday baseDay = Weekday.friday;
    Date baseDate = Date(6,Date.feb,2026);
    int newDay = computeDaysApart(baseDate,this) % 7;
    newDay = (baseDay.value - newDay) % 7;
    if (newDay == 0) {newDay = 7;}
    return Weekday.fromValue(newDay);
  }
  /// Is a `Interface`-`Solve` getter.
  ///
  /// Returns `true` if weekday is saturday or sunday.
  ///
  /// Returns `false` if weekday is not saturday or sunday.
  bool get isWeekend => weekday.value > 5;


  // gets
  /// This is a `Value` getter.
  ///
  /// The [day].
  int get day => _day;
  /// This is a `Value` getter.
  ///
  /// The [month].
  int get month => _month;
  /// This is a `Value` getter.
  ///
  /// The [year].
  int get year => _year;
  /// This is a `Value` getter.
  ///
  /// The [format], do note that is is a `List<FormatToken>`.
  List<FormatToken> get format => _format;

  /// This is a `Interface`-`Compute` getter.
  ///
  /// The opposite [day] of the [month].
  int get opDay => monthMax-_day+1;

  // Constant Movers
  /// This is a `Value` setter.
  ///
  /// Changes the [year] to the [setYear].
  Date setYear (int setYear) {
    return Date._insert(_day,_month,setYear,_format);
  }
  /// This is a `Value` setter.
  ///
  /// Changes the [month] to the [setMonth].
  Date setMonth (int setMonth) {
    if (setMonth != monthConst(setMonth)) {throw "expected a value between 1 and 12, got $setMonth";}
    return Date._insert(_day,setMonth,_year,_format);
  }
  /// This is a `Value` setter.
  ///
  /// Changes the [day] to the [setDay].
  Date setDay (int setDay) {
    if (setDay != dayConst(setDay,monthMax,isLeapYear)) {
      throw "expected value between 1 and $monthMax, got $setDay";
    }
    return Date._insert(setDay,_month,_year,_format);
  }
  /// This is a `Value` setter.
  ///
  /// Changes the [format] to the [format]
  Date setFormat (String format) {
    return Date(_day,_month,_year,format:format);
  }


  // Field Movers
  /// This is a `Value`-`Change` function.
  ///
  /// Changes the [year] by the [amount].
  Date changeYear (int amount) => Date._insert(_day,_month,_year+amount,_format);
  /// This is a `Value`-`Change` getter.
  ///
  /// Changes the [year] to the next [year].
  Date get nextYear => changeYear(1);
  /// This is a `Value`-`Change` getter.
  ///
  /// Changes the [year] to the previous [year].
  Date get prevYear => changeYear(-1);

  /// This is a `Value`-`Change` function.
  ///
  /// Changes the [month] by the [amount].
  Date changeMonth (int amount) {
    var (:month,:year) = _changeMonth(amount, _month, _year);
    return Date._insert(_day,month,year,_format);
  }
  /// This is a `Value`-`Change` getter.
  ///
  /// Changes the [month] to the next [month].
  Date get nextMonth => changeMonth(1);
  /// This is a `Value`-`Change` getter.
  ///
  /// Changes the [month] to the previous [month].
  Date get prevMonth => changeMonth(-1);

  /// This is a `Value`-`Change` function.
  ///
  /// Changes the [day] by the [amount].
  Date changeDay (int amount) {
    var (:day,:month,:year) = _changeDay(amount, _day, _month, _year);
    return Date._insert(day,month,year,_format);
  }
  /// This is a `Value`-`Change` getter.
  ///
  /// Changes the [day] to the next [day].
  Date get nextDay => changeDay(1);
  /// This is a `Value`-`Change` getter.
  ///
  /// Changes the [day] to the previous [day].
  Date get prevDay => changeDay(-1);

  /// This is a `Interface`-`Construct` function.
  ///
  /// The [day] should be a [day] between `1` & [monthMax].
  ///
  /// The [month] should be a [month] between `1` & `12`.
  ///
  /// The [format] should be a string with valid formatting.
  /// (use [Class] : [Date] description)
  factory Date(int day, int month, int year, {String format = fmStd}) {
    bool leapYear = computeIsLeapYear(year);
    month = monthConst(month);
    day = dayConst(day,month,leapYear);
    List<FormatToken> formatList = scan(format);
    return Date._constructor(day,month,year,formatList);
  }
  /// This is a `Interface`-`Construct` function.
  ///
  /// The same as [Date]`()`, but with month and day input position flipped.
  factory Date.american(int month, int day, int year,
      {String format = fmAmr}) => Date(day,month,year,format:format);
  // factory Date.parse(Object input) {
  //   if (input is Record) {return parseRecord(input);}
  // }

  /// This is a `Private`-`Construct` function.
  ///
  /// Instead of a [String] for [format], it is a `List<FormatToken>`. (purest form)
  factory Date._insert(int day, int month, int year, List<FormatToken> format) {
    bool leapYear = computeIsLeapYear(year);
    month = monthConst(month);
    day = dayConst(day,month,leapYear);
    return Date._constructor(day,month,year,format);
  }

  /// DO NOT USE THIS IF YOU DON'T KNOW WHAT YOU ARE DOING
  const Date._constructor(this._day,this._month,this._year,this._format);

  /*int toInt() {
    if (_year >= 0) {
      while (_year > 0) {

      }
    }
    else {

    }
  }*/

  @override
  /// This is a `Standard`-`Output` function.
  ///
  /// Returns the [format]'s values as a [String].
  ///
  /// Refer to [Class] : [Date] for more information about formatting.
  String toString() {
    String mule = "";
    for (FormatToken current in _format) {
      switch (current.type) {
        case FormatType.dayVal: {mule += hAdder(_day,current.h);}
        case FormatType.dayth: {mule += placeDenoter(int.parse(hAdder(_day,current.h)));}
        case FormatType.monthVal: {mule += hAdder(_month,current.h);}
        case FormatType.monthName: {
          mule += (current.trunc == -1)
              ? monthName(_month)
              : monthName(_month).safeTruncate(current.trunc);
        }
        case FormatType.yearVal: {mule += hAdder(_year,current.h);}
        case FormatType.yearMillennium: {mule += hAdder(_year % 1000,current.h);}
        case FormatType.yearCentury: {mule += hAdder(_year % 100,current.h);}
        case FormatType.yearDecade: {mule += hAdder(_year % 10,current.h);}
        case FormatType.weekdayVal: {mule += hAdder(weekday.value,current.h);}
        case FormatType.weekdayName: {
          mule += (current.trunc == -1)
              ? weekday.name
              : weekday.name.safeTruncate(current.trunc);
        }
        case FormatType.text: {mule += current.text;}
      }
    }
    return mule;
  }

  // operators
  @override
  bool operator ==(Object other) => identical(this,other) || (other is Date && hashCode == other.hashCode);

  @override
  /// This is a `Standard`-`Operator` function.
  ///
  /// Is the [other] after [this]?
  bool operator <(Date other) {
    if (_year < other._year) {return true;}
    else if (_year > other._year) {return false;}
    // now we know they are at the same year
    if (_month < other._month) {return true;}
    else if (_month > other._month) {return false;}
    // now we know they are at the same year and month
    return _day < other._day;
  }

  /*Date operator +(Object obj) {
    switch (obj) {
      case int _: {return changeDay(obj);}
      case Date _: {
        Date date = Date(1,1,0);
        if (obj < date) {throw "+ doesn't support years less than 0";}
        while (yearMa)
      }
      case _: {throw "expected $int or $Date got ${obj.runtimeType}";}
    }
  }*/

  /// This is a `Standard`-`Operator` function.
  ///
  /// Uses [changeDay]`(`[amount]`)`.
  Date operator +(int amount) => changeDay(amount);

  /// This is a `Standard`-`Operator` function.
  ///
  /// Uses [changeDay]`(-`[amount]`)`.
  Date operator -(int amount) => changeDay(-amount);

  @override
  int get hashCode => Object.hash(year,month,day);
//int get hashCode => year*303 ^ (day*5067 ^ month*6153);
}

/// Makes so there is at least [amount] of zeroes.
///
/// [amount] being one or less will only return [number] (in a string form).
///
/// the `return`s length will always at least be above [amount],
/// indicated by `return.length`.
///
/// used in the by-product of `package:xw/date.dart`.
///
/// ` `
///
/// [hAdder]`(50,2)` => `50`.
///
/// [hAdder]`(56,4)` => `0056`.
///
/// [hAdder]`(1896,4)` => `1896`.
///
/// Do note, that there is a problem if any instance of
/// `int.parse(hAdder(n, x))` is not n (Where n & x is an unknown int).
/// Do please report it to the creator of this function
/// (manifestedmf on github) or on their repository (xw-dart).
String hAdder(int number, int amount) {
  String mule = "$number";
  if (number.length < amount) {
    String messenger = "";
    for (int index = 0; index < amount - number.length;index++) {
      messenger += "0";
    }
    mule = (number >= 0) ? mule.insert(messenger) : mule.insert(messenger,1);
  }
  return mule;
}