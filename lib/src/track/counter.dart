part of alpha.track;

class Counter {
  int _count;
  
  int get count => _count;
  
  void increment() {
    _count +=1;
  }
  
  void decrement() {
    _count -= 1;
  }
  
  void set(int value) {
    _count = value;
  }
}