class ListStack<T> {
  List<T> _listStack = [];

  void push(T item) => _listStack.add(item);

  T? pop() {
    if (length() == 0) return null;
    return _listStack.removeLast();
  }

  T? peek() {
    if (length() == 0) return null;
    return _listStack.last;
  }

  bool isEmpty() => _listStack.isEmpty;

  bool isNotEmpty() => _listStack.isNotEmpty;

  bool contains(T item) => _listStack.contains(item);

  void clear() => _listStack.clear();

  @override
  String toString() => _listStack.toString();

  List<T> toList() => _listStack;

  T getItemAtIndex(int index) => _listStack[index];

  int length() => _listStack.length;

  void forEach(void Function(T element) forEach) => _listStack.forEach(forEach);
}
