part of alpha.observe;

class ObservableList<E> extends DelegatingList<E> {
  final StreamController<ListEvent<E>> _controller = new StreamController();
  Stream<ListEvent<E>> get onChange => _controller.stream;
  
  ObservableList([List<E> other]) :
    super(other == null ? [] : other);
  
  @override
  void add(E element) {
    super.add(element);
    _controller.add(new ListEvent<E>.add(super.indexOf(element), element));
  }
  
  @override
  void addAll(Iterable<E> elements) {
    for (var e in elements) {
      add(e);
    }
  }
  
  @override
  bool remove(E element) {
    var index = super.indexOf(element);
    var wasRemoved = super.remove(element);
    if (wasRemoved) {
      _controller.add(new ListEvent<E>.remove(index, element));
    }
    return wasRemoved;
  }
  
  @override
  E removeAt(int index) {
    var val = super.removeAt(index);
    _controller.add(new ListEvent<E>.remove(index, val));
    return val;
  }
  
  @override
  E removeLast() {
    var index = super.length - 1;
    var val = super.removeLast();
    
    _controller.add(new ListEvent<E>.remove(index, val));
    
    return val;
  }
  
  @override
  set length(int newLength) {
    var last = super.length;
    super.length = newLength;
    _controller.add(new ListEvent<E>.expand(last, newLength));
  }
  
  @override
  void clear() {
    for (var i = 0; i < length; i++) {
      _controller.add(new ListEvent<E>.remove(i, this[i]));
    }
    super.clear();
  }
}

class ListEvent<E> {
  int index;
  int _type;
  E value;
  int lastLength;
  int newLength;
  
  ListEvent.add(this.index, this.value) : _type = 0;
  ListEvent.remove(this.index, this.value) : _type = 1;
  ListEvent.expand(this.lastLength, this.newLength) : _type = 2;
  
  bool get isAddEvent => _type == 0;
  bool get isRemoveEvent => _type == 1;
  bool get isExpandEvent => _type == 2;
}