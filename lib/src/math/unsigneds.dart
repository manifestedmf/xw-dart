
class uint1 {
  final bool _integer;
  const uint1(int num):_integer = (num % 2 == 0) ? true : false;
  const uint1.set(this._integer);
}

class uint2 {
  final uint1 _first, _second;

  const uint2(int num)
    :_second = uint1(num % 2);
  const uint2.set(this._first, this._second);

}