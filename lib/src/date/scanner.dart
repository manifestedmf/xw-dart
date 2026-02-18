import '../../extension.dart';

enum State {
  space,
  hash,
  inBlock,
  outBlock,
  dayValIW,
  dayValIH,
  dayValOW,
  dayValOH,
  daythIW,
  daythIH,
  daythOW,
  daythOH,
  monthValIW,
  monthValIH,
  monthValOW,
  monthValOH,
  monthNameI,
  monthNameO,
  yearValIW,
  yearValIH,
  yearValOW,
  yearValOH,
  yearMillIW,
  yearMillIH,
  yearMillOW,
  yearMillOH,
  yearCentIW,
  yearCentIH,
  yearCentOW,
  yearCentOH,
  yearDecIW,
  yearDecIH,
  yearDecOW,
  yearDecOH,
  weekdayValIW,
  weekdayValIH,
  weekdayValOW,
  weekdayValOH,
  weekdayNameI,
  weekdayNameO,
  text,
}

enum Character {
  whitespace,
  hash,
  leftBlock,
  rightBlock,
  d,
  m,
  y,
  w,
  h,
  num,
  charOther,
}

enum FormatType {
  dayVal,
  dayth,
  monthVal,
  // TODO: add monthValth
  monthName,
  yearVal,
  // TODO: add yearValth
  yearMillennium,
  yearCentury,
  yearDecade,
  weekdayVal,
  weekdayName,
  text,
  ;
}

// TODO: add [(number)] for a name to the amount of truncation it needs, for example mm3
//  , truncates it to 3 which is the standard
// TODO: add [h(number)] for amount of zeroes forced on the for example the years, for example yy2
//  , if it was 2006 then it would be 006 instead of 6, and yy1 would be 06, yy3 should be possible making 0006

class FormatToken {
  final String text;
  final FormatType type;
  final int index;
  final int h;
  final int trunc;
  const FormatToken(this.text,this.type,{required this.index,this.h = -1,this.trunc = -1});
}

List<FormatToken> scan(String formatInput) {
  List<FormatToken> list = [];
  int index = 0;
  int start = 0;
  State state = State.space;
  Character character;
  String char = "";
  String subst = "";
  int trunc = -1;
  int h = -1;
  while (index < formatInput.length) {
    char = formatInput[index];
    character = getChar(char);
    subst = formatInput.substring(start,index);
    switch (state) {
      case State.space: { // previous was whitespace outside of {}
        switch (character) { // current is character
          case Character.hash: {
            list.add(FormatToken(subst,FormatType.text,index:start));
            state = State.hash;
          }
          case Character.whitespace: {}
          case _: {state = State.text;}
        }
      }
      case State.hash: { // previous was #
        switch (character) { // current is character
          case Character.hash: {state = State.text; start = index;}
          case Character.leftBlock: {state = State.inBlock;}
          case Character.d: {state = State.dayValOW; start = index;}
          case Character.m: {state = State.monthValOW; start = index;}
          case Character.y: {state = State.yearValOW; start = index;}
          case Character.w: {state = State.weekdayValOW; start = index;}
          case _: {state = State.text;}
        }
      }
      case State.inBlock: { // previous was {
        switch (character) { // current is character
          case Character.whitespace: {}
          case Character.rightBlock: {state = State.outBlock;}
          case Character.d: {state = State.dayValIW; start = index;}
          case Character.m: {state = State.monthValIW; start = index;}
          case Character.y: {state = State.yearValIW; start = index;}
          case Character.w: {state = State.weekdayValIW; start = index;}
          case _: {state = State.text;}
        }
      }
      case State.outBlock: { // previous was }
        switch (character) { // current is character
          case Character.whitespace: {state = State.space; start = index;}
          case Character.hash: {state = State.hash; start = index;}
          case Character.leftBlock: {state = State.text; start = index;}
          case Character.rightBlock: {state = State.text; start = index;}
          case _: {state = State.text; start = index;}
        }
      }
      case State.dayValIW: { // syntax was d inside {}
        switch (character) { // current is character
          case Character.whitespace: {
            list.add(FormatToken(subst,FormatType.dayVal,index:start,h:1));
            state = State.inBlock;
            start = index;
          }
          case Character.rightBlock: {
            list.add(FormatToken(subst,FormatType.dayVal,index:start,h:1));
            state = State.outBlock;
            start = index;
          }
          case Character.d: {
            state = State.daythIW;
          }
          case Character.h: {state = State.dayValIH;}
          case _: {state = State.text;}
        }
        h = -1;
      }
      case State.dayValIH: { // syntax was dh# inside {}
        switch (character) { // current is character
          case Character.whitespace: {
            list.add(FormatToken(subst,FormatType.dayVal,index:start,
                h:(h == -1) ? 1 : h));
            state = State.inBlock;
            start = index;
            h = -1;
          }
          case Character.rightBlock: {
            list.add(FormatToken(subst,FormatType.dayVal,index:start,
                h:(h == -1) ? 1 : h));
            state = State.outBlock;
            start = index;
            h = -1;
          }
          case Character.num: {
            if (h == -1) {h = int.parse(char);}
            else {h = h.addAtEnd(int.parse(char));}
          }
          case _: {state = State.text; h = -1;}
        }
      }
      case State.dayValOW: { // syntax was d outside {}
        switch (character) { // current is character
          case Character.whitespace: {
            list.add(FormatToken(subst,FormatType.dayVal,index:start,h:1));
            state = State.space;
            start = index;
          }
          case Character.d: {
            state = State.daythOW;
          }
          case Character.h: {state = State.dayValOH;}
          case _: {state = State.text;}
        }
        h = -1;
      }
      case State.dayValOH: { // syntax was d# outside {}
        switch (character) { // current is character
          case Character.whitespace: {
            list.add(FormatToken(subst,FormatType.dayVal,index:start,
                h:(h == -1) ? 1 : h));
            state = State.space;
            start = index;
            h = -1;
          }
          case Character.num: {
            if (h == -1) {h = int.parse(char);}
            else {h = h.addAtEnd(int.parse(char));}
          }
          case _: {state = State.text; h = -1;}
        }
      }
      case State.daythIW: { // syntax was dd inside {}
        switch (character) { // current is character
          case Character.whitespace: {
            list.add(FormatToken(subst,FormatType.dayth,index:start,h:1));
            state = State.inBlock;
            start = index;
          }
          case Character.rightBlock: {
            list.add(FormatToken(subst,FormatType.dayth,index:start,h:1));
            state = State.outBlock;
            start = index;
          }
          case Character.d: {
            state = State.text;
          }
          case Character.h: {
            state = State.daythIH;
          }
          case _: {state = State.text;}
        }
        h = -1;
      }
      case State.daythIH: { // syntax was dd inside {}
        switch (character) { // current is character
          case Character.whitespace: {
            list.add(FormatToken(subst,FormatType.dayth,index:start,
                h:(h == -1) ? 1 : h));
            state = State.inBlock;
            start = index;
            h = -1;
          }
          case Character.rightBlock: {
            list.add(FormatToken(subst,FormatType.dayth,index:start,
                h:(h == -1) ? 1 : h));
            state = State.outBlock;
            start = index;
            h = -1;
          }
          case Character.num: {
            if (h == -1) {h = int.parse(char);}
            else {h = h.addAtEnd(int.parse(char));}
          }
          case _: {state = State.text; h = -1;}
        }
      }
      case State.daythOW: { // syntax was dd outside {}
        switch (character) { // current is character
          case Character.whitespace: {
            list.add(FormatToken(subst,FormatType.dayth,index:start,h:1));
            state = State.space;
            start = index;
          }
          case Character.d: {state = State.text;}
          case Character.h: {state = State.daythOH;}
          case _: {state = State.text;}
        }
        h = -1;
      }
      case State.daythOH: { // syntax was dd outside {}
        switch (character) { // current is character
          case Character.whitespace: {
            list.add(FormatToken(subst,FormatType.dayth,index:start,
                h:(h == -1) ? 1 : h));
            state = State.space;
            start = index;
            h = -1;
          }
          case Character.num: {
            if (h == -1) {h = int.parse(char);}
            else {h = h.addAtEnd(int.parse(char));}
          }
          case _: {state = State.text; h = -1;}
        }
      }
      case State.monthValIW: { // syntax was m inside {}
        switch (character) { // current is character
          case Character.whitespace: {
            list.add(FormatToken(subst,FormatType.monthVal,index:start,h:1));
            state = State.inBlock;
            start = index;
          }
          case Character.rightBlock: {
            list.add(FormatToken(subst,FormatType.monthVal,index:start,h:1));
            state = State.outBlock;
            start = index;
          }
          case Character.m: {
            state = State.monthNameI;
          }
          case Character.h: {state = State.monthValIH;}
          case _: {state = State.text;}
        }
        h = -1;
      }
      case State.monthValIH: { // syntax was mh inside {}
        switch (character) { // current is character
          case Character.whitespace: {
            list.add(FormatToken(subst,FormatType.monthVal,index:start,
                h:(h == -1) ? 1 : h));
            state = State.inBlock;
            start = index;
            h = -1;
          }
          case Character.rightBlock: {
            list.add(FormatToken(subst,FormatType.monthVal,index:start,
                h:(h == -1) ? 1 : h));
            state = State.outBlock;
            start = index;
            h = -1;
          }
          case Character.num: {
            if (h == -1) {h = int.parse(char);}
            else {h = h.addAtEnd(int.parse(char));}
          }
          case _: {state = State.text; h = -1;}
        }
      }
      case State.monthValOW: { // syntax was m outside {}
        switch (character) { // current is character
          case Character.whitespace: {
            list.add(FormatToken(subst,FormatType.monthVal,index:start,h:1));
            state = State.space;
            start = index;
          }
          case Character.m: {
            state = State.monthNameO;
          }
          case Character.h: {state = State.monthValOH;}
          case _: {state = State.text;}
        }
        h = -1;
      }
      case State.monthValOH: { // syntax was mh outside {}
        switch (character) { // current is character
          case Character.whitespace: {
            list.add(FormatToken(subst,FormatType.monthVal,index:start,
                h:(h == -1) ? 1 : h));
            state = State.space;
            start = index;
            h = -1;
          }
          case Character.num: {
            if (h == -1) {h = int.parse(char);}
            else {h = h.addAtEnd(int.parse(char));}
          }
          case _: {state = State.text; h = -1;}
        }
      }
      case State.monthNameI: { // syntax was mm inside {}
        switch (character) { // current is character
          case Character.whitespace: {
            list.add(FormatToken(subst,FormatType.monthName,index:start,
                trunc:trunc));
            state = State.inBlock;
            start = index;
            trunc = -1;
          }
          case Character.rightBlock: {
            list.add(FormatToken(subst,FormatType.monthName,index:start,
                trunc:trunc));
            state = State.outBlock;
            start = index;
            trunc = -1;
          }
          case Character.num: {
            if (trunc == -1) {trunc = int.parse(char);}
            else {trunc = trunc.addAtEnd(int.parse(char));}
          }
          case _: {state = State.text; trunc = -1;}
        }
      }
      case State.monthNameO: { // syntax was mm outside {}
        switch (character) { // current is character
          case Character.whitespace: {
            list.add(FormatToken(subst,FormatType.monthName,index:start,
                trunc:trunc));
            state = State.space;
            start = index;
            trunc = -1;
          }
          case Character.num: {
            if (trunc == -1) {trunc = int.parse(char);}
            else {trunc = trunc.addAtEnd(int.parse(char));}
          }
          case _: {state = State.text; trunc = -1;}
        }
      }
      case State.yearValIW: { // syntax was y inside {}
        switch (character) { // current is character
          case Character.whitespace: {
            list.add(FormatToken(subst,FormatType.yearVal,index:start,h:1));
            state = State.inBlock;
            start = index;
          }
          case Character.rightBlock: {
            list.add(FormatToken(subst,FormatType.yearVal,index:start,h:1));
            state = State.outBlock;
            start = index;
          }
          case Character.y: {
            state = State.yearMillIW;
          }
          case Character.h: {
            state = State.yearValIH;
          }
          case _: {state = State.text;}
        }
        h = -1;
      }
      case State.yearValIH: { // syntax was y inside {}
        switch (character) { // current is character
          case Character.whitespace: {
            list.add(FormatToken(subst,FormatType.yearVal,index:start,
                h:(h == -1) ? 1 : h));
            state = State.inBlock;
            start = index;
            h = -1;
          }
          case Character.rightBlock: {
            list.add(FormatToken(subst,FormatType.yearVal,index:start,
                h:(h == -1) ? 1 : h));
            state = State.outBlock;
            start = index;
            h = -1;
          }
          case Character.num: {
            if (h == -1) {h = int.parse(char);}
            else {h = h.addAtEnd(int.parse(char));}
          }
          case _: {state = State.text; h = -1;}
        }
      }
      case State.yearValOW: { // syntax was y outside {}
        switch (character) { // current is character
          case Character.whitespace: {
            list.add(FormatToken(subst,FormatType.yearVal,index:start,h:1));
            state = State.space;
            start = index;
          }
          case Character.y: {
            state = State.yearMillOW;
          }
          case _: {state = State.text;}
        }
        h = -1;
      }
      case State.yearValOH: { // syntax was y outside {}
        switch (character) { // current is character
          case Character.whitespace: {
            list.add(FormatToken(subst,FormatType.yearVal,index:start,
                h:(h == -1) ? 1 : h));
            state = State.space;
            start = index;
            h = -1;
          }
          case Character.num: {
            if (h == -1) {h = int.parse(char);}
            else {h = h.addAtEnd(int.parse(char));}
          }
          case _: {state = State.text; h = -1;}
        }
      }
      case State.yearMillIW: { // syntax was yy inside {}
        switch (character) { // current is character
          case Character.whitespace: {
            list.add(FormatToken(subst,FormatType.yearMillennium,index:start,h:3));
            state = State.inBlock;
            start = index;
          }
          case Character.rightBlock: {
            list.add(FormatToken(subst,FormatType.yearMillennium,index:start,h:3));
            state = State.outBlock;
            start = index;
          }
          case Character.y: {
            state = State.yearCentIW;
          }
          case _: {state = State.text;}
        }
        h = -1;
      }
      case State.yearMillIH: { // syntax was yy inside {}
        switch (character) { // current is character
          case Character.whitespace: {
            list.add(FormatToken(subst,FormatType.yearMillennium,index:start,
                h:(h == -1) ? 3 : h));
            state = State.inBlock;
            start = index;
            h = -1;
          }
          case Character.rightBlock: {
            list.add(FormatToken(subst,FormatType.yearMillennium,index:start,
                h:(h == -1) ? 3 : h));
            state = State.outBlock;
            start = index;
            h = -1;
          }
          case Character.num: {
            if (h == -1) {h = int.parse(char);}
            else {h = h.addAtEnd(int.parse(char));}
          }
          case _: {state = State.text; h = -1;}
        }
      }
      case State.yearMillOW: { // syntax was yy outside {}
        switch (character) { // current is character
          case Character.whitespace: {
            list.add(FormatToken(subst,FormatType.yearMillennium,index:start,h:3));
            state = State.space;
            start = index;
          }
          case Character.y: {
            state = State.yearCentOW;
          }
          case _: {state = State.text;}
        }
        h = -1;
      }
      case State.yearMillOH: { // syntax was yy outside {}
        switch (character) { // current is character
          case Character.whitespace: {
            list.add(FormatToken(subst,FormatType.yearMillennium,index:start,
                h:(h == -1) ? 3 : h));
            state = State.space;
            start = index;
            h = -1;
          }
          case Character.num: {
            if (h == -1) {h = int.parse(char);}
            else {h = h.addAtEnd(int.parse(char));}
          }
          case _: {state = State.text; h = -1;}
        }
      }
      case State.yearCentIW: { // syntax was yyy inside {}
        switch (character) { // current is character
          case Character.whitespace: {
            list.add(FormatToken(subst,FormatType.yearCentury,index:start,h:2));
            state = State.inBlock;
            start = index;
          }
          case Character.rightBlock: {
            list.add(FormatToken(subst,FormatType.yearCentury,index:start,h:2));
            state = State.outBlock;
            start = index;
          }
          case Character.y: {
            state = State.yearDecIW;
          }
          case _: {state = State.text;}
        }
        h = -1;
      }
      case State.yearCentIH: { // syntax was yyy inside {}
        switch (character) { // current is character
          case Character.whitespace: {
            list.add(FormatToken(subst,FormatType.yearCentury,index:start,
                h:(h == -1) ? 2 : h));
            state = State.inBlock;
            start = index;
            h = -1;
          }
          case Character.rightBlock: {
            list.add(FormatToken(subst,FormatType.yearCentury,index:start,
                h:(h == -1) ? 2 : h));
            state = State.outBlock;
            start = index;
            h = -1;
          }
          case Character.num: {
            if (h == -1) {h = int.parse(char);}
            else {h = h.addAtEnd(int.parse(char));}
          }
          case _: {state = State.text; h = -1;}
        }
      }
      case State.yearCentOW: { // syntax was yyy outside {}
        switch (character) { // current is character
          case Character.whitespace: {
            list.add(FormatToken(subst,FormatType.yearCentury,index:start,h:2));
            state = State.space;
            start = index;
          }
          case Character.y: {
            state = State.yearDecOW;
          }
          case _: {state = State.text;}
        }
        h = -1;
      }
      case State.yearCentOH: { // syntax was yyy outside {}
        switch (character) { // current is character
          case Character.whitespace: {
            list.add(FormatToken(subst,FormatType.yearCentury,index:start,
                h:(h == -1) ? 2 : h));
            state = State.space;
            start = index;
            h = -1;
          }
          case Character.num: {
            if (h == -1) {h = int.parse(char);}
            else {h = h.addAtEnd(int.parse(char));}
          }
          case _: {state = State.text; h = -1;}
        }
      }
      case State.yearDecIW: { // syntax was yyyy
        switch (character) { // current is character
          case Character.whitespace: {
            list.add(FormatToken(subst,FormatType.yearDecade,index:start,h:1));
            state = State.inBlock;
            start = index;
          }
          case Character.rightBlock: {
            list.add(FormatToken(subst,FormatType.yearDecade,index:start,h:1));
            state = State.outBlock;
            start = index;
          }
          case Character.y: {
            state = State.text;
          }
          case _: {state = State.text;}
        }
        h = -1;
      }
      case State.yearDecIH: { // syntax was yyyy
        switch (character) { // current is character
          case Character.whitespace: {
            list.add(FormatToken(subst,FormatType.yearDecade,index:start,
                h:(h == -1) ? 1 : h));
            state = State.inBlock;
            start = index;
            h = -1;
          }
          case Character.rightBlock: {
            list.add(FormatToken(subst,FormatType.yearDecade,index:start,
                h:(h == -1) ? 1 : h));
            state = State.outBlock;
            start = index;
            h = -1;
          }
          case Character.num: {
            if (h == -1) {h = int.parse(char);}
            else {h = h.addAtEnd(int.parse(char));}
          }
          case _: {state = State.text; h = -1;}
        }
      }
      case State.yearDecOW: { // syntax was yyyy
        switch (character) { // current is character
          case Character.whitespace: {
            list.add(FormatToken(subst,FormatType.yearDecade,index:start,h:1));
            state = State.space;
            start = index;
          }
          case Character.y: {
            state = State.text;
          }
          case _: {state = State.text;}
        }
        h = -1;
      }
      case State.yearDecOH: { // syntax was yyyy
        switch (character) { // current is character
          case Character.whitespace: {
            list.add(FormatToken(subst,FormatType.yearDecade,index:start,
                h:(h == -1) ? 1 : h));
            state = State.space;
            start = index;
            h = -1;
          }
          case Character.num: {
            if (h == -1) {h = int.parse(char);}
            else {h = h.addAtEnd(int.parse(char));}
          }
          case _: {state = State.text; h = -1;}
        }
      }
      case State.text: {
        switch (character) {
          case Character.hash: {
            list.add(FormatToken(subst,FormatType.text,index:start));
            state = State.hash;
          }
          case _: {}
        }
      }
      case State.weekdayValIW: { // syntax was w inside {}
        switch (character) { // current is character
          case Character.whitespace: {
            list.add(FormatToken(subst,FormatType.weekdayVal,index:start,h:1));
            state = State.inBlock;
            start = index;
          }
          case Character.rightBlock: {
            list.add(FormatToken(subst,FormatType.weekdayVal,index:start,h:1));
            state = State.outBlock;
            start = index;
          }
          case Character.w: {
            state = State.weekdayNameI;
          }
          case _: {state = State.text;}
        }
        h = -1;
      }
      case State.weekdayValIH: { // syntax was w inside {}
        switch (character) { // current is character
          case Character.whitespace: {
            list.add(FormatToken(subst,FormatType.weekdayVal,index:start,
                h:(h == -1) ? 1 : h));
            state = State.inBlock;
            start = index;
            h = -1;
          }
          case Character.rightBlock: {
            list.add(FormatToken(subst,FormatType.weekdayVal,index:start,
                h:(h == -1) ? 1 : h));
            state = State.outBlock;
            start = index;
            h = -1;
          }
          case Character.num: {
            if (h == -1) {h = int.parse(char);}
            else {h = h.addAtEnd(int.parse(char));}
          }
          case _: {state = State.text; h = -1;}
        }
      }
      case State.weekdayValOW: { // syntax was w outside {}
        switch (character) { // current is character
          case Character.whitespace: {
            list.add(FormatToken(subst,FormatType.weekdayVal,index:start,h:1));
            state = State.space;
            start = index;
          }
          case Character.w: {
            state = State.weekdayNameO;
          }
          case _: {state = State.text;}
        }
        h = -1;
      }
      case State.weekdayValOH: { // syntax was w outside {}
        switch (character) { // current is character
          case Character.whitespace: {
            list.add(FormatToken(subst,FormatType.weekdayVal,index:start,
                h:(h == -1) ? 1 : h));
            state = State.space;
            start = index;
            h = -1;
          }
          case Character.num: {
            if (h == -1) {h = int.parse(char);}
            else {h = h.addAtEnd(int.parse(char));}
          }
          case _: {state = State.text; h = -1;}
        }
      }
      case State.weekdayNameI: { // syntax was ww inside {}
        switch (character) { // current is character
          case Character.whitespace: {
            list.add(FormatToken(subst,FormatType.weekdayName,index:start,
                trunc:trunc));
            state = State.inBlock;
            start = index;
            trunc = -1;
          }
          case Character.rightBlock: {
            list.add(FormatToken(subst,FormatType.weekdayName,index:start,
                trunc:trunc));
            state = State.outBlock;
            start = index;
            trunc = -1;
          }
          case Character.num: {
            if (trunc == -1) {trunc = int.parse(char);}
            else {trunc = trunc.addAtEnd(int.parse(char));}
          }
          case _: {state = State.text; trunc = -1;}
        }
      }
      case State.weekdayNameO: { // syntax was ww outside {}
        switch (character) { // current is character
          case Character.whitespace: {
            list.add(FormatToken(subst,FormatType.weekdayName,index:start,
                trunc:trunc));
            state = State.space;
            start = index;
            trunc = -1;
          }
          case Character.num: {
            if (trunc == -1) {trunc = int.parse(char);}
            else {trunc = trunc.addAtEnd(int.parse(char));}
          }
          case _: {state = State.text; trunc = -1;}
        }
      }
    }
    index++;
  }
  switch (state) {
    case State.space:
    case State.outBlock: {}
    case State.dayValOW: {list.add(FormatToken(subst,
        FormatType.dayVal,index:start,h:1));}
    case State.dayValOH: {list.add(FormatToken(subst,
        FormatType.dayVal,index:start,h:(h == -1) ? 1 : h));}
    case State.daythOW: {list.add(FormatToken(subst,
        FormatType.dayth,index:start,h:1));}
    case State.daythOH: {list.add(FormatToken(subst,
        FormatType.dayth,index:start,h:(h == -1) ? 1 : h));}
    case State.monthValOW: {list.add(FormatToken(subst,
        FormatType.monthVal,index:start,h:1));}
    case State.monthValOH: {list.add(FormatToken(subst,
        FormatType.monthVal,index:start,h:(h == -1) ? 1 : h));}
    case State.monthNameO: {list.add(FormatToken(subst,
        FormatType.monthName,index:start,trunc:trunc));}
    case State.yearValOW: {list.add(FormatToken(subst,
        FormatType.yearVal,index:start,h:1));}
    case State.yearValOH: {list.add(FormatToken(subst,
        FormatType.yearVal,index:start,h:(h == -1) ? 1 : h));}
    case State.yearMillOW: {list.add(FormatToken(subst,
        FormatType.yearMillennium,index:start,h:3));}
    case State.yearMillOH: {list.add(FormatToken(subst,
        FormatType.yearMillennium,index:start,h:(h == -1) ? 3 : h));}
    case State.yearCentOW: {list.add(FormatToken(subst,
        FormatType.yearCentury,index:start,h:2));}
    case State.yearCentOH: {list.add(FormatToken(subst,
        FormatType.yearCentury,index:start,h:(h == -1) ? 2 : h));}
    case State.yearDecOW: {list.add(FormatToken(subst,
        FormatType.yearDecade,index:start,h:1));}
    case State.yearDecOH: {list.add(FormatToken(subst,
        FormatType.yearDecade,index:start,h:(h == -1) ? 1 : h));}
    case State.weekdayValOW: {list.add(FormatToken(subst,
        FormatType.weekdayVal,index:start,h:1));}
    case State.weekdayValOH: {list.add(FormatToken(subst,
        FormatType.weekdayVal,index:start,h:(h == -1) ? 1 : h));}
    case State.weekdayNameO: {list.add(FormatToken(subst,
        FormatType.weekdayName,index:start,trunc:trunc));}
    case _: {list.add(FormatToken(subst,FormatType.text,index:start));}
  }
  return list;
}

Character getChar(String char) {
  if (char == " ") {return Character.whitespace;}
  else if (char == "#") {return Character.hash;}
  else if (char == "{") {return Character.leftBlock;}
  else if (char == "}") {return Character.rightBlock;}
  else if (char == "d") {return Character.d;}
  else if (char == "m") {return Character.m;}
  else if (char == "y") {return Character.y;}
  else if (char == "w") {return Character.w;}
  else if (char == "h") {return Character.h;}
  else if ({"0","1","2","3","4","5","6","7","8","9"}.contains(char)) {return Character.num;}
  else {return Character.charOther;}
}