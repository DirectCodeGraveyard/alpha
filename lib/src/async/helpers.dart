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

Future async(Producer function) {
  return new Future(function);
}

Future chain(List<Action> functions) {
  return async(() => executeChain(functions));
}

void executeChain(List<Action> actions) => actions.forEach((action) => action());
