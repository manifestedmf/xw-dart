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

  factory Array.generate(int amount, T Function(int) complex) {
    Array<T> array = Array(amount);
    for (int index = 0; index < array.length; index++) {
      array[index] = complex(index);
    }
    return array;
  }

  /// The first iteration for array creation, though now for
  /// [withArray], instead of `Array<T?>?` it is `Array<T>?`.
  factory Array.fill(int amount, {T? fill, Array<T>? withArray}) {
    Array<T> array = Array(amount);
    if (amount != 0) {
      withArray ??= Array(0);
      int index = 0;
      for (T i in withArray) {
        if (index >= array.length) {break;}
        array[index++] = i;
      }
    }
    return array;
  }

  factory Array.fromList(List<T> list) {
    Array<T> array = Array(list.length);
    for (int index = 0; index < array.length; index++) {
      array[index] = list[index];
    }
    return array;
  }

  factory Array.fromIterable(Iterable<T> iterable) {
    Array<T> array = Array(iterable.length);
    for (int index = 0; index < array.length; index++) {
      array[index] = iterable.elementAt(index);
    }
    return array;
  }

  factory Array.withIterator(Iterable<T> Function() iterableGen) {
    return Array.fromIterable(iterableGen());
  }

  static ArrayCreator get std => ArrayCreator._();
  static ArrayCreator<int> get stdInt => ArrayCreator<int>._();
  static ArrayCreator<double> get stdDouble => ArrayCreator<double>._();
  static ArrayCreator<T> stdCreate<T>() => ArrayCreator<T>._();

  List<T?> get arrayInternal => _array;
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
    else {return _array[index] ?? (throw ArrayException("$index is empty"));}
  }
  void operator []=(int index, T value) {
    if (index < 0 && index >= -_length) {index %= _length;}
    if (index >= _length || index < -_length) {
      throw ArrayException("$index out of range, valid positions are $_positions");}
    else {_array[index] = value;}
  }

  @override
  T get first => _array[0] ?? (throw ArrayException("0 is empty"));

  @override
  T elementAt(int index) => elementAtAdmin(index) ?? (throw ArrayException("$index is empty"));

  T? elementAtAdmin(int index) => _array[index];

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

  // TODO: make special variable to denote a empty array part.

  @override
  int get hashCode => Object.hashAll(this);

  static get _noItems => ArrayException("There is no items in the array, "
      "Array: []");
  static _emptyPlace(int index) => ArrayException("$index has no item, "
      "don't use ${null} as a empty space");
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

class ArrayCreator<T> {
  const ArrayCreator._();

  Array<T?> operator [](int length) => Array(length);
}