part of alpha.async;

Future async(Producer function) {
  return new Future(function);
}

Future chain(List<Action> functions) {
  return async(() => executeChain(functions));
}

void executeChain(List<Action> actions) => actions.forEach((action) => action());
