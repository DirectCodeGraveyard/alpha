part of alpha.async;

/**
 * Asynchronous edition of the [List.map] function.
 *
 * [input] is the list to handle.
 * [transformer] is a mapping function.
 */
Future<List<dynamic>> mapAsync(List<dynamic> input, dynamic transformer(dynamic it)) {
  var completer = new Completer();

  var list = [];

  new Stream.fromIterable(input)
    .listen(list.add)
    .onDone(() => completer.complete(list));

  return completer.future;
}

/**
 * Iterates over [input] asynchronously.
 */
Future eachAsync(List<dynamic> input, void handler(dynamic it)) {
  var completer = new Completer();

  new Stream.fromIterable(input)
    .listen(handler)
    .onDone(completer.complete);

  return completer.future;
}

/**
 * Filters [input] using the specified [filter].
 */
Future<List<dynamic>> whereAsync(List<dynamic> input, bool filter(dynamic it)) {
  var completer = new Completer();

  var list = [];

  new Stream.fromIterable(input)
    .where(filter)
    .listen(list.add)
    .onDone(() => completer.complete(list));

  return completer.future;
}
