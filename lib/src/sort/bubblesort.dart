class BubbleSort {
  static List<int> listSortInt(List<int> list) {
    int index = 0;
    int rotation = 1;
    while (rotation <= list.length) {
      if (index + 1 + rotation >= list.length) {
        index = 0;
        ++rotation;
      }
      int current = list[index];
      int next = list[index + 1];
      (current > next)
          ? {
        list[index] = next,
        list[index + 1] = current
      }
          : {};
      index++;
    }
    return list;
  }
  static List<double> listSortFloat(List<double> list) {
    int index = 0;
    int rotation = 1;
    while (rotation <= list.length) {
      if (index + 1 + rotation >= list.length) {
        index = 0;
        ++rotation;
      }
      double current = list[index];
      double next = list[index + 1];
      (current > next)
          ? {
        list[index] = next,
        list[index + 1] = current
      }
          : {};
      index++;
    }
    return list;
  }
  static List<num> listSortNum(List<num> list) {
    int index = 0;
    int rotation = 1;
    while (rotation <= list.length) {
      if (index + 1 + rotation >= list.length) {
        index = 0;
        ++rotation;
      }
      num current = list[index];
      num next = list[index + 1];
      (current > next)
          ? {
        list[index] = next,
        list[index + 1] = current
      }
          : {};
      index++;
    }
    return list;
  }
/*static Map<int,V> mapKeySortInt<V>(Map<int,V> map) {
    int index = 0;
    int rotation = 1;
    while (rotation <= map.length) {
      if (index + 1 + rotation >= map.length) {
        index = 0;
        ++rotation;
      }
      MapEntry<int, V> current = map.entries.elementAt(index);
      MapEntry<int, V> next = map.entries.elementAt(index+1);
      (current.key > next.key)
          ? {
        map[current.key] = next.value,
        map.
      }
          : {};
      index++;
    }
    return map;
  }*/
}
