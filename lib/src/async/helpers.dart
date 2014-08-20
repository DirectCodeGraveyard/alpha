part of alpha.async;

Future<List<dynamic>> where(List<dynamic> input, bool filter(dynamic it)) {
  var completer = new Completer();
  
  var elements = [];
  
  new Stream.fromIterable(input)
    .where(filter)
    .listen(elements.add)
    .onDone(() => completer.complete(elements));
  
  return completer.future;
}

typedef dynamic AsynchronousFunction();

Future async(AsynchronousFunction function) {
  return new Future(function);
}
