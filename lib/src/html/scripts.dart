part of alpha.html;

/**
 * Load JavaScript Files one at a time in order.
 */
Future loadScripts(List<String> scripts) {
  var body = document.body;
  var future = new Future.value();
  for (var script in scripts) {
    future.then((_) {
      var e = new ScriptElement();
      var completer = new Completer();
      e.type = "application/javascript";
      e.src = script;
      e.onLoad.listen((event) {
        completer.complete();
      });
      future = completer.future;
      body.append(e);
    });
  }
  return future;
}