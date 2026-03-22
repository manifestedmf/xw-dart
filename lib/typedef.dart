library xw.typdef;

/// The standard [Dictionary] format.
///
/// Added in `2.8`.
typedef Dictionary = Map<String, String>;

/// The [Json] format.
///
/// Added in `2.8`.
typedef Json = Map<String, String>;

/// Added in `2.8`.
typedef Dict<K> = Map<K, String>;

/// Added in `2.8`.
typedef DictK<K> = Map<K, String>;

/// Added in `2.8`.
typedef DictV<V> = Map<String, V>;

/// Added in `2.8`.
typedef Words = Iterable<String>;

/// Added in `2.8`.
typedef Lists<E> = List<List<E>>;

/// Added in `2.8`.
typedef Sets<E> = Set<Set<E>>;

/// Added in `2.8`.
typedef Iterables<E> = Iterable<Iterable<E>>;

/// Added in `2.8`.
typedef Amount<K> = Map<K, int>;

