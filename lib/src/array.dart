import 'mixins.dart';

class ArrayException {
  String? message;

  ArrayException(this.message);

  @override
  toString() {
    if (message == null) {return "IncompleteToken error";}
    else {return "IncompleteToken: $message";}
  }
}

class Array<T> extends Iterable<T> {
  late final List<T?> _array;
  late final int _length;

  @override
  int get length => _length;

  Array(int amount, {T? fill, Array<T?>? withArray}) {
    if (amount != 0) {
      withArray ??= Array(0);
      int index = 0;
      for (T? i in withArray) {
        if (index >= _length) {break;}
        _array[index] = i;
        ++index;
      }
    }
    _array = List.filled(amount,fill);
    _length = amount;
  }

  List<T?> get array => _array;
  String get _positions {
    if (_length == 0) {return "NO VALID POSITIONS";}
    else if (_length == 1) {return "0";}
    else if (_length == 2) {return "0, 1";}
    else if (_length == 3) {return "0, 1, 2";}
    else {return "0, 1, ..., ${_length-1}";}
  }

  T operator [](int index) {
    if (index < 0 && index >= -_length) {index %= _length;}
    if (index >= _length || index < -_length) {
      throw ArrayException("$index out of range, valid positions are $_positions");}
    else {return _array[index] ?? (throw ArrayException("$index out of bounds"));}
  }
  void operator []=(int index, T value) {
    if (index < 0 && index >= -_length) {index %= _length;}
    if (index >= _length || index < -_length) {
      throw ArrayException("$index out of range, valid positions are $_positions");}
    else {_array[index] = value;}
  }

  @override
  String toString() => "$_array";


  /// sub [Array]
  Array<T?> subar([int start = 0, int? end]) {
    end ??= length;
    return Array(1);
  }

  @override
  Iterator<T> get iterator => _ArrayIterator<T>(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Array &&
              runtimeType == other.runtimeType &&
              listEquals(_array, other._array);

  /*Array<T?> subar({int start = 0, int? end}) {
    if (start == 0 && end == null) {return this;}
    else if (end != null) {
      Array<T> array = Array(end+1-start);
      for (int i = 0; i < end; i++) {array[i] = _array[i];}
      return array;
    }
    else if (end == null) {
      Array<T> array = Array(_length+1-start);
    }
  }*/



  @override
  int get hashCode => Object.hashAll(this);
}

class _ArrayIterator<T> implements Iterator<T> {
  final Array<T> _array;
  int _index = 0;

  _ArrayIterator(this._array);

  @override
  T get current => _array[_index];

  @override
  bool moveNext() {
    if (++_index >= _array.length) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(_index,current);
}

extension IterableExtension<E> on Iterable<E> {
  Array<E> toArray() {
    Array<E> array = Array(length);
    for (int index = 0; index < length; index++) {
      array[index] = elementAt(index);
    }
    return array;
  }
}