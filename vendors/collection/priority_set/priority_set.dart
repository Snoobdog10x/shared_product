import 'package:collection/collection.dart';

class PrioritySet<T> {
  List<T> _data = [];
  late int Function(T, T)? comparison;
  PrioritySet(int Function(T, T)? comparison) {
    this.comparison = comparison;
  }

  void add(T item) {
    _data.remove(item);
    _data.add(item);
    _data.sort(comparison);
  }

  int length() => _data.length;

  bool contains(T item) => _data.contains(item);

  void addAll(Iterable<T> objectList) {
    objectList.forEach((object) {
      _data.remove(object);
      _data.add(object);
    });
    _data.sort(comparison);
  }

  void clear() {
    _data.clear();
  }

  List<T> toList() {
    return _data.toList();
  }
}
