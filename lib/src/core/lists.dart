part of alpha.core;

/**
 * Takes the elements at the specified [indexes] from [input].
 */
List<dynamic> many(List<dynamic> input, List<int> indexes) {
  var out = [];
  for (var index in indexes) {
    out.add(input[index]);
  }
  return out;
}

/**
 * The opposite of the [List.where] function.
 */
List<dynamic> notWhere(List<dynamic> input, bool filter(dynamic it)) =>
    input.where((it) => !filter(it)).toList();

/**
 * Adds [object] to the end of [input] the specified amount of [times].
 */
void addMultiple(List<dynamic> input, dynamic object, int times) {
  for (int i = 1; i <= times; i++) {
    input.add(object);
  }
}
