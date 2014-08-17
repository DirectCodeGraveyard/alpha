part of alpha.data;

typedef DistributorFunction<T>(T value);

class Distributor<T> {
  final List<DistributorFunction<T>> functions = [];
  
  Distributor();
  
  void add(DistributorFunction<T> function) {
    functions.add(function);
  }
  
  void emit(T value) {
    for (var function in functions) {
      function();
    }
  }
}